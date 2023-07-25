local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
	print("jdtls not found")
	return
end

local home = vim.env.HOME
-- local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/"
-- local lombok_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
-- local equinox_version = "1.6.400.v20210924-0641"

WORKSPACE_PATH = home .. "/workspace/"
if vim.fn.has("mac") == 1 then
	OS_NAME = "mac"
elseif vim.fn.has("unix") == 1 then
	OS_NAME = "linux"
elseif vim.fn.has("win32") == 1 then
	OS_NAME = "win"
else
	vim.notify("Unsupported OS", vim.log.levels.WARN)
end

-- local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
-- local workspace_dir = WORKSPACE_PATH .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {

	cmd = {

		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		"/Users/jacobtk/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
		"-configuration",
		"/Users/jacobtk/.local/share/nvim/mason/packages/jdtls/config_" .. "mac",
		"-data",
		"/Users/jacobtk/projects/dev/java",
	},

	on_attach = function(client, bufnr)
		require("plugins.lsp.user_commands").setup(client, bufnr)
		-- require("nvim-navic").attach(client, bufnr)
		require("plugins.lsp.formatting").setup(client, bufnr)
		require("plugins.lsp.keys").setup(client, bufnr)
	end,
	capabilities = capabilities,
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = false,
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
		-- extendedClientCapabilities = extendedClientCapabilities,
		flags = {
			allow_incremental_sync = true,
		},
	},
	init_options = {
		-- bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	},
	--
	-- -- 💀
	-- -- This is the default if not provided, you can remove it. Or adjust as needed.
	-- -- One dedicated LSP server & client will be started per unique root_dir
	-- -- root_dir = require("jdtls.setup").find_root(root_markers) ,
	-- root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
}

jdtls.start_or_attach(config)
