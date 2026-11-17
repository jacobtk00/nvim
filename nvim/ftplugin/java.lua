local root = vim.fs.root(0, { "mvnw", "gradlew", ".git" })
	or vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts" })
	or vim.fn.getcwd()
local workspace = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root, ":t")
local mason = vim.fn.stdpath("data") .. "/mason/packages/"
local bundles = vim.fn.glob(mason .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
for _, jar in ipairs(vim.fn.glob(mason .. "java-test/extension/server/*.jar", true, true)) do
	if not vim.tbl_contains({
		"com.microsoft.java.test.runner-jar-with-dependencies.jar",
		"jacocoagent.jar",
	}, vim.fn.fnamemodify(jar, ":t")) then
		table.insert(bundles, jar)
	end
end
local cmd = {
	"jdtls",
	"-data",
	workspace,
	"--jvm-arg=-javaagent:" .. vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar",
}
for arg in (vim.env.JDTLS_JVM_ARGS or ""):gmatch("%S+") do
	table.insert(cmd, "--jvm-arg=" .. arg)
end

require("jdtls").start_or_attach({
	cmd = cmd,
	cmd_env = vim.fn.executable("/usr/libexec/java_home") == 1
			and { JAVA_HOME = vim.trim(vim.fn.system({ "/usr/libexec/java_home", "-v", "26" })) }
		or nil,
	root_dir = root,
	init_options = { bundles = bundles },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	on_attach = require("plugins.lsp.on_attach"),
	settings = {
		java = {
			signatureHelp = { enabled = true },
			completion = {
				favoriteStaticMembers = {
					-- "org.hamcrest.MatcherAssert.assertThat",
					-- "org.hamcrest.Matchers.*",
					-- "org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"sun.*",
					-- "jdk.*",
				},
			},
		},
	},
	flags = { debounce_text_changes = 150 },
})
