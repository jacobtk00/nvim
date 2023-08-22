local M = {
	"neovim/nvim-lspconfig",
	-- opts = { inlay_hints = { enabled = true } },
	event = "BufReadPre",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		-- "simrat39/rust-tools.nvim",
		{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
		{
			"folke/neodev.nvim",
			opts = {
				debug = true,
				experimental = {
					pathStrict = true,
				},
				library = {
					runtime = "~/projects/neovim/runtime/",
					library = { plugins = { "neotest" }, types = true },
				},
			},
		},
	},
}

function M.config()
	require("mason")
	require("plugins.lsp.diagnostics").setup()

	local function on_attach(client, bufnr)
		require("plugins.lsp.user_commands").setup(client, bufnr)
		-- require("nvim-navic").attach(client, bufnr)
		require("plugins.lsp.formatting").setup(client, bufnr)
		require("plugins.lsp.keys").setup(client, bufnr)

		-- if client.server_capabilities.inlayHintProvider then
		-- 	vim.lsp.buf.inlay_hint(bufnr, true)
		-- end
	end

	local servers = {
		ansiblels = {},
		bashls = {},
		clangd = {
			cmd = {
				"clangd",
				"--background-index",
				"--suggest-missing-includes",
				"--clang-tidy",
			},
			filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda", "proto" },
		},
		cssls = {},
		dockerls = {},
		tsserver = {},
		html = {
			filetypes = { "html" },
			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
			},
		},
		jsonls = {
			on_new_config = function(new_config)
				new_config.settings.json.schemas = new_config.settings.json.schemas or {}
				vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
			end,
			settings = {
				json = {
					format = {
						enable = true,
					},
					validate = { enable = true },
				},
			},
		},
		gopls = {},
		marksman = {},
		pyright = {},
		rust_analyzer = {
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
					procMacro = { enable = true },
					checkOnSave = {
						command = "clippy",
						extraArgs = {
							"--no-deps",
						},
					},
					inlayHints = { locationLinks = false },
					diagnostics = {
						enable = true,
						experimental = { enable = true },
					},
				},
			},
		},
		yamlls = {
			settings = {
				yaml = {
					format = { enable = true },
					validate = true,
					hover = true,
					completion = true,
					schemaStore = {
						url = "https://www.schemastore.org/api/json/catalog.json",
						enable = true,
					},
				},
			},
		},
		-- sqlls = {
		-- 	single_file_support = true,
		-- },
		lua_ls = {
			single_file_support = true,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					completion = { workspaceWord = true, callSnippet = "Both" },
					misc = {
						parameters = {
							"--log-level=trace",
						},
					},
					diagnostics = {
						groupSeverity = { strong = "Warning", strict = "Warning" },
						groupFileStatus = {},
						unusedLocalExclude = { "_*" },
					},
					format = {
						enable = false,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
							continuation_indent_size = "2",
						},
					},
				},
			},
		},
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	local options = {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	}

	for server, opts in pairs(servers) do
		opts = vim.tbl_deep_extend("force", {}, options, opts or {})

		-- if server == "gopls" then
		-- 	-- require("go").setup()
		-- end

		if server == "tsserver" then
			require("typescript").setup({ server = opts })
		else
			require("lspconfig")[server].setup(opts)
		end
	end

	require("plugins.null-ls").setup(options)
end

return M
