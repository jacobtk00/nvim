local servers = {
	clangd = {},
	gopls = {
		gofumpt = true,
		staticcheck = true,
		usePlaceholders = true,
		directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
	},
	rust_analyzer = {},
	tsserver = {},
	html = { filetypes = { "html", "twig", "hbs" } },
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
		},
	},
}

return servers
