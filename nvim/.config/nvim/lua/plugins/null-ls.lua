local M = {
	"jose-elias-alvarez/null-ls.nvim",
}

function M.setup(options)
	local null_ls = require("null-ls")

	local formatting = null_ls.builtins.formatting
	local code_actions = null_ls.builtins.code_actions
	-- local diagnostics = null_ls.builtins.diagnostics

	local sources = {
		formatting.prettier.with({ --[[ filetypes = prettier_filetypes, ]]
			extra_args = {
				"--no-semi", --[[ "--tab-width=4"  ]]
			},
		}),
		-- formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.google_java_format,
		-- formatting.shfmt.with({
		-- 	filetypes = { "sh", "zsh", "bash" },
		-- 	args = { "-i", "2" },
		-- }),
		formatting.goimports, -- need to add to path
		code_actions.gitsigns,
		code_actions.gomodifytags,
		-- null_ls.builtins.diagnostics.golangci_lint,
		-- null_ls.builtins.diagnostics.revive,
		-- null_ls.builtins.formatting.golines.with({
		-- 	extra_args = {
		-- 		"--max-len=180",
		-- 		"--base-formatter=gofumpt",
		-- 	},
		-- }),

		-- diagnostics.revive,
		require("typescript.extensions.null-ls.code-actions"),
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
end

function M.has_formatter(ft)
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	return #available > 0
end

return M
