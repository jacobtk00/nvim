local LSP = {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		{ "williamboman/mason.nvim", config = true },
		{
			"j-hui/fidget.nvim",
			tag = "legacy",
			event = "LspAttach",
			enabled = function()
				return vim.bo.filetype ~= "java"
			end,
		},
		"b0o/SchemaStore.nvim",
		"someone-stole-my-name/yaml-companion.nvim",
		"nvim-telescope/telescope.nvim"
	},
}

function LSP.config()
	local on_attach = require("plugins.lsp.on_attach")
	local servers = require("plugins.lsp.servers")

	-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

	require("mason").setup({
		registries = {
			"github:mason-org/mason-registry",
			"github:Crashdummyy/mason-registry",
		},
	})
	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
		automatic_enable = false,
	})

	for server_name, server_config in pairs(servers) do
		if server_name ~= "jdtls" and server_name ~= "omnisharp" then
			vim.lsp.config(server_name, {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = servers[server_name],
				filetypes = (servers[server_name] or {}).filetypes,
				flags = { debounce_text_changes = 150 },
			})
			vim.lsp.enable(server_name)
		end
	end

	require("plugins.null-ls").setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
	require("telescope").load_extension("yaml_schema")
	require("fidget").setup()
end

return LSP
