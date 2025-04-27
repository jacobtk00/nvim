local M = {
	"nvimtools/none-ls.nvim"
}

function M.setup(options)
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	local code_actions = null_ls.builtins.code_actions
	local diagnostics = null_ls.builtins.diagnostics

	local sources = {
		formatting.prettier.with({ --[[ filetypes = prettier_filetypes, ]]
			extra_args = {
				"--no-semi", --[[ "--tab-width=4"  ]]
			},
		}),
		formatting.google_java_format,
		formatting.goimports, -- need to add to path
		formatting.csharpier,
		-- formatting.clang_format.with({
		-- 	extra_args = {
		-- 		-- "-style=file:" .. vim.fn.expand("~/projects/C/.clang-format"),
		-- 		"-style=file:~/.clang-format",
		-- 		-- '-style="{IndentWidth: 8}"',
		-- 	},
		-- }),
		-- formatting.astyle,
		code_actions.impl,
		code_actions.gitsigns,
		code_actions.gomodifytags,
		-- formatting.eslint_d,
		-- code_actions.eslint_d.with({
		-- 	only_local = "node_modules/.bin/eslint",
		-- }),
		-- diagnostics.eslint_d.with({
		-- 	diagnostics_format = "[eslint] #{m}\n(#{c})",
		-- }),
		-- require("typescript.extensions.null-ls.code-actions"),
	}
	--root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),

	-- local gotest = require("go.null_ls").gotest()
	-- table.insert(sources, gotest)
	null_ls.setup({
		sources = sources,
		debug = true,
		debounce = 1000,
		default_timeout = 1000,
		save_after_format = false,
		on_attach = options.on_attach,
	})

	--  'lua require("null-ls").toggle("eslint_d")'

	local SHOULD_USE_ESLINT = false
	vim.api.nvim_create_user_command("EslintToggle", function()
		local ft = vim.bo.filetype
		local uses_eslint = ft == "javascript"
			or ft == "javascriptreact"
			or ft == "typescript"
			or ft == "typescriptreact"
		if M.has_formatter(ft) and uses_eslint then
			require("null-ls").toggle("eslint_d")
			SHOULD_USE_ESLINT = not SHOULD_USE_ESLINT
		end
	end, {})

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
		-- command = "EslintToggle",
		callback = function()
			if require("null-ls").is_registered("eslint_d") and not SHOULD_USE_ESLINT then
				require("null-ls").disable("eslint_d")
			end
		end,
	})
end

function M.has_formatter(ft)
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	return #available > 0
end

return M
