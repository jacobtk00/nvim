-- log that config is starting

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
vim.lsp.set_log_level("DEBUG")

local workspace_dir = "/home/jake/.workspace/" ..
project_name                                                   -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local config = {}

config.cmd = { -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	"java",    -- or '/path/to/java17_or_newer/bin/java'
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-javaagent:" .. vim.env.HOME .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
	-- '-noverify',
	"-Xms1g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
	"-jar",
	vim.fn.glob("/Users/jacobtk/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
	"-configuration",
	"/Users/jacobtk/.local/share/nvim/mason/packages/jdtls/config_" .. "mac",
	"-data",
	"/Users/jacobtk/projects/dev/java",
}

config.root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })

-- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
config.settings = {
	java = {
		-- signatureHelp = { enabled = true },
		-- completion = {
		-- 	favoriteStaticMembers = {
		-- 		"org.hamcrest.MatcherAssert.assertThat",
		-- 		"org.hamcrest.Matchers.*",
		-- 		"org.hamcrest.CoreMatchers.*",
		-- 		"org.junit.jupiter.api.Assertions.*",
		-- 		"java.util.Objects.requireNonNull",
		-- 		"java.util.Objects.requireNonNullElse",
		-- 		"org.mockito.Mockito.*",
		-- 	},
		-- 	filteredTypes = {
		-- 		"com.sun.*",
		-- 		"io.micrometer.shaded.*",
		-- 		"java.awt.*",
		-- 		"jdk.*",
		-- 		"sun.*",
		-- 	},
		-- },
	},
}

config.on_attach = require("plugins.lsp.on_attach")
config.capabilities = capabilities
-- config.handlers["language/status"] = function() end

require("jdtls").start_or_attach(config)
