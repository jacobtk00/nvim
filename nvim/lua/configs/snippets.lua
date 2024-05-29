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

local return_filename = function()
	return vim.fn.fnamemodify(vim.fn.expand('%'), ':t')
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

	local snippets = {
		s("ns", {
			t("namespace "),
			f(function()
				local s = vim.lsp.buf.list_workspace_folders()

				local smallest_string = s[1]
				for i, v in ipairs(s) do
					if string.len(v) < string.len(smallest_string) then
						smallest_string = v
					end
				end

				local last_slash_idx = 0
				for i = string.len(smallest_string), 1, -1 do
					if string.sub(smallest_string, i, i) == '/' then
						last_slash_idx = i
						break
					end
				end

				local curr_dir = vim.fn.expand('%:p:h')
				return curr_dir:sub(last_slash_idx + 1):gsub('/', '.'):gsub('\\', '')
			end),
			t(";"),
		}),

		s(
			'regex match',
			fmt(
				[[
        if(Regex.IsMatch({}, @"{}"))
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

	ls.add_snippets(nil, { all = snippets })
end

return M
