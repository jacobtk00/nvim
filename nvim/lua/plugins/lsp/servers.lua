local servers = {
	clangd = {},
	-- gopls = {},
	-- rust_analyzer = {},
	ts_ls = {},
	html = { filetypes = { "html", "twig", "hbs" } },
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
		},
	},
	-- omnisharp = {
	-- 	-- cmd = { "/usr/bin/omnisharp", "--languageserver" },
	-- 	-- filetypes = { "cs" },
	-- 	-- root_dir = require("lspconfig").util.root_pattern("*.sln", "*.csproj", "*.fsproj"),
	-- },
	jsonls = {
		schemas = require('schemastore').json.schemas(),
		validate = { enable = true },
	},
	yamlls = {
		yaml = {
			format = {
				enable = true,
				singleQuote = true,
				printWidth = 120,
			},
			hover = true,
			completion = true,
			validate = true,
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			-- customTags = { '!Ref', '!ImportValue', '!Sub', '!GetAtt', '!GetAZs',
			-- 	'!If', '!Not', '!Equals', '!And', '!Or',
			-- 	'!FindInMap', '!Base64', '!Cidr', '!Join', '!Select', '!Split',
			-- },
			schemas = require("schemastore").yaml.schemas(),
			-- schemas = {
			-- 	-- kubernetes = "*.yaml",
			-- 	["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
			-- 	".pipelines/*.{yml,yaml}",
			-- 	["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
			-- 	["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			-- 	["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
			-- 	["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
			-- 	["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
			-- 	["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
			-- 	["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
			-- 	["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
			-- 	["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
			-- 	["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
			-- 	"*api*.{yml,yaml}",
			-- 	["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
			-- 	"*docker-compose*.{yml,yaml}",
			-- 	["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
			-- 	"*flow*.{yml,yaml}",
			-- 	["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] =
			-- 	"*.cf.{yml,yaml}",
			-- 	["https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json"] =
			-- 	"*template.{yml,yaml}"
			-- },
			flags = { debounce_text_changes = 150 },
		},
	},
	jdtls = {},
}

return servers

