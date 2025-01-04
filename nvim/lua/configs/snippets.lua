---@diagnostic disable: unused-local
local M = {}

---Function for luasnip to add using directives needed for snippets
---@param required_using_directive_list string|table
local function add_csharp_using_statement_if_needed(required_using_directive_list)
	if type(required_using_directive_list) == 'string' then
		local temp = required_using_directive_list
		required_using_directive_list = { temp }
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		for _, using_directive in ipairs(required_using_directive_list) do
			if line:match(using_directive) ~= nil then
				table.remove(required_using_directive_list, using_directive)
			end
		end
	end

	-- Add all using directives that remain in the list to be written to top of file
	if #required_using_directive_list > 0 then
		local using_directives_to_write = {}
		for _, using_directive in ipairs(required_using_directive_list) do
			table.insert(using_directives_to_write, string.format('using %s;', using_directive))
		end
		vim.api.nvim_buf_set_lines(0, 0, 0, false, using_directives_to_write)
	end
end

local base_workspace_folder = function()
	local wf = vim.lsp.buf.list_workspace_folders()
	local smallest_path = wf[1]
	for i, v in ipairs(wf) do
		if string.len(v) < string.len(smallest_path) then
			smallest_path = v
		end
	end
	return smallest_path
end

local find_file_extension_in_dir = function(dir, ext)
	return vim.fs.find(function(name, path)
			return name:match(".*%." .. ext .. "$")
		end,
		{ limit = math.huge, type = "file", path = dir }
	)
end

local is_dir_in_path_of_current_file = function(dir)
	local normalized_dir = vim.fs.normalize(dir)
	local curr_file_path = vim.fn.expand('%:p:h')

	-- NOTE: The reason we can't do a simple string.match is
	-- cases like src/Core.Test and src/Core in file src/Core.Test/SomeFile.cs
	-- In this case Core and Core.Test directory would pass
	while string.len(curr_file_path) > 0 and string.len(normalized_dir) <= string.len(curr_file_path) do
		if curr_file_path == normalized_dir then
			return true
		end
		curr_file_path = vim.fn.fnamemodify(curr_file_path, ":h")
	end

	return false
end

local namespace_for_current_file_from_dir = function(root_dir)
	local last_slash_idx = 0
	for i = string.len(root_dir), 1, -1 do
		if string.sub(root_dir, i, i) == '/' then
			last_slash_idx = i
			break
		end
	end

	local curr_dir = vim.fn.expand('%:p:h')
	return curr_dir:sub(last_slash_idx + 1):gsub('/', '.'):gsub('\\', '')
end

local get_csharp_namespace_options = function()
	local base_dir_to_check = base_workspace_folder()

	-- Check if theres a .sln, if that doesnt exist use .csproj
	-- local project_files = find_glob_files_in_dir(base_dir_to_check, "*.sln") or
	-- 	find_glob_files_in_dir(base_dir_to_check, "*.csproj")
	local project_files = vim.tbl_extend(
		"force",
		find_file_extension_in_dir(base_dir_to_check, "sln"),
		find_file_extension_in_dir(base_dir_to_check, "csproj")
	)

	-- Use only .csproj files
	-- local project_files = find_file_extension_in_dir(base_dir_to_check, "csproj")

	-- remove all project files that are not in the current file path
	local curr_file_path = vim.fn.expand('%:p:h')
	for i = #project_files, 1, -1 do
		local f = project_files[i]
		if not is_dir_in_path_of_current_file(vim.fs.dirname(f)) then
			table.remove(project_files, i)
		end
	end

	if project_files == nil or #project_files == 0 then
		return "No project files found"
	end

	local ns = {}
	for _, f in ipairs(project_files) do
		local namespace = namespace_for_current_file_from_dir(vim.fs.dirname(f))
		table.insert(ns, namespace)
	end
	return ns
end

local unique_strings = function(tbl)
	local found = {}
	local res = {}

	for _, v in ipairs(tbl) do
		if type(v) == 'string' and not found[v] then
			table.insert(res, v)
			found[v] = true
		end
	end

	return res
end

local get_csharp_namespace = function()
	local namespace_opts = get_csharp_namespace_options()
	if type(namespace_opts) == 'string' then
		return namespace_opts
	end

	local opts = unique_strings(namespace_opts)
	if #opts < 1 then
		return 'No namespace found'
	end
	return opts[1]
end

function M.configure_snippets()
	local ls = require("luasnip")
	local s = ls.snippet
	local sn = ls.snippet_node
	local isn = ls.indent_snippet_node
	local t = ls.text_node
	local i = ls.insert_node
	local f = ls.function_node
	local c = ls.choice_node
	local d = ls.dynamic_node
	local r = ls.restore_node
	local events = require("luasnip.util.events")
	local ai = require("luasnip.nodes.absolute_indexer")
	local extras = require("luasnip.extras")
	local l = extras.lambda
	local rep = extras.rep
	local p = extras.partial
	local m = extras.match
	local n = extras.nonempty
	local dl = extras.dynamic_lambda
	local fmt = require("luasnip.extras.fmt").fmt
	local fmta = require("luasnip.extras.fmt").fmta
	local conds = require("luasnip.extras.expand_conditions")
	local postfix = require("luasnip.extras.postfix").postfix
	local types = require("luasnip.util.types")
	local parse = require("luasnip.util.parser").parse_snippet
	local ms = ls.multi_snippet
	local k = require("luasnip.nodes.key_indexer").new_key

	vim.keymap.set({ "i", "s" }, "<C-E>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end, { silent = true })

	local function create_template(construct)
		local template_with_construct = string.format(
			[[
				namespace {};

				public %s {}
				{{
					{}
				}}
			]],
			construct
		)

		return fmt(
			template_with_construct,
			{
				f(function() return get_csharp_namespace() end),
				f(function() return vim.fn.expand('%:t:r') end),
				i(0),
			}
		)
	end

	local csharp = {
		-- Tries to get the correct namespace
		-- s("ns", {
		-- 	t("namespace "),
		-- 	d(1, function()
		-- 		local options = get_csharp_namespace_options()
		-- 		if type(options) == 'string' then
		-- 			return sn(nil, { t('string') })
		-- 		end
		--
		-- 		local tnodes = {}
		-- 		for _, option in ipairs(options) do
		-- 			table.insert(tnodes, t(option))
		-- 		end
		-- 		return
		-- 			sn(nil, {
		-- 				c(1, tnodes),
		-- 			})
		-- 	end),
		-- 	t(";"),
		-- }),

		s("ns", fmt([[
			namespace {};

			{}
		]], {
			f(function() return get_csharp_namespace() end),
			i(0),
		})),
		s("class-template", create_template("class")),
		s("interface-template", create_template("interface")),
		s("struct-template", create_template("struct")),
		s("enum-template", create_template("enum")),
		s("abstract-class-template", create_template("abstract class")),
		s("static-class-template", create_template("static class")),

		-- s("ns", {
		-- 	t("namespace "),
		-- 	f(get_csharp_namespace),
		-- 	t(";"),
		-- }),

		s(
			'regex match',
			fmt(
				[[
        if (Regex.IsMatch({}, @"{}"))
        {{
            {}
        }}
        ]],
				{
					i(1, '"source"'),
					i(2, '.*'),
					i(3),
				}
			),
			{
				callbacks = {
					[-1] = {
						-- Write needed using directives before expanding snippet so positions are not messed up
						[events.pre_expand] = function()
							add_csharp_using_statement_if_needed('System.Text.RegularExpressions')
						end,
					},
				},
			}
		),

		s(
			'regex matches',
			fmt(
				[[
        var matches = Regex.Matches({}, @"{}")
                           .Cast<Match>()
                           .Select(match => {})
                           .Distinct();
        ]],
				{
					i(1),
					i(2, '.*'),
					i(3, 'match'),
				}
			),
			{
				callbacks = {
					[-1] = {
						-- Write needed using directives before expanding snippet so positions are not messed up
						[events.pre_expand] = function()
							add_csharp_using_statement_if_needed({
								'System.Linq',
								'System.Text.RegularExpressions',
							})
						end,
					},
				},
			}
		),

		s(
			{
				trig = '///',
				descr = 'XML comment summary',
			},
			fmt(
				[[
    /// <summary>
    /// {}
    /// </summary>{}
    ]],
				{
					i(1),
					i(2),
				}
			),
			{
				callbacks = {
					[-1] = {
						-- Set vim comment mode to help continue writing the XML comment
						-- Pressing the trigger of '///' again would trigger the snippet again
						[events.enter] = function()
							vim.cmd('set formatoptions+=cro')
						end,
					},

					[2] = {
						-- Disable the vim settings after leaving the snippet
						[events.leave] = function()
							vim.cmd('set formatoptions-=cro')
						end,
					},
				},
			}
		),

		s(
			'XML XML',
			fmt([[{}]], {
				c(1, {
					sn(
						nil,
						fmt(
							[[
                   <summary>{}</summary>
                   ]],
							{
								i(1, 'Test test test'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                 <remarks>{}</remarks>
                 ]],
							{
								i(1, 'Specifies that text contains supplementary information about the program element'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <param name="{}">{}</param>
                ]],
							{
								i(1),
								i(2, 'Specifies the name and description for a function or method parameter'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <typeparam name="{}">{}</typeparam>
                ]],
							{
								i(1),
								i(2, 'Specifies the name and description for a type parameter'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <returns>{}</returns>
                ]],
							{
								i(1, 'Describe the return value of a function or method'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <exception cref="{}">{}</exception>
                ]],
							{
								i(1, 'Exception type'),
								i(
									2,
									'Specifies the type of exception that can be generated and the circumstances under which it is thrown'
								),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <seealso cref="{}"/>
                ]],
							{
								i(
									1,
									'Specifies the type of exception that can be generated and the circumstances under which it is thrown'
								),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <para>{}</para>
                ]],
							{
								i(1,
									'Specifies a paragraph of text. This is used to separate text inside the remarks tag'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <code>{}</code>
                ]],
							{
								i(
									1,
									'Specifies that text is multiple lines of code. This tag can be used by generators to display text in a font that is appropriate for code'
								),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <paramref name="{}"/>
                ]],
							{
								i(1, 'Specifies a reference to a parameter in the same documentation comment'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <typeparamref name="{}"/>
                ]],
							{
								i(1, 'Specifies a reference to a type parameter in the same documentation comment'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <c>{}</c>
                ]],
							{
								i(1, 'Specifies a reference to a type parameter in the same documentation comment'),
							}
						)
					),

					sn(
						nil,
						fmt(
							[[
                <see cref="{}">{}</see>
                ]],
							{
								i(1, 'reference'),
								i(2, 'Specifies a reference to a type parameter in the same documentation comment'),
							}
						)
					),

					--
				}),
			})
		),
	}

	ls.add_snippets("cs", csharp)
end

return M
