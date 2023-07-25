local cmdline = false
local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-emoji",
		{ "hrsh7th/cmp-cmdline", enabled = cmdline },
		{ "dmitmel/cmp-cmdline-history", enabled = cmdline },
		"hrsh7th/cmp-path",
		-- "saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"onsails/lspkind-nvim",
	},
}

function M.config()
	vim.o.completeopt = "menuone,noselect"

	-- Setup nvim-cmp.
	local cmp = require("cmp")
	local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
	require("luasnip.loaders.from_vscode").lazy_load()

	cmp.setup({
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		-- cmp.setup.filetype("Jenkinsfile", {
		-- 	sources = {
		-- 		{
		-- 			name = "jenkinsfile",
		-- 			option = {
		-- 				jenkins_url = "https://jenkins.co",
		-- 			},
		-- 		},
		-- 	},
		-- }),
		formatting = {
			format = require("plugins.lsp.kind").cmp_format(),
			-- fields = { "abbr", "kind" },
			-- window = {
			-- 	maxwidth = 60,
			-- },
			-- format = require("lspkind").cmp_format({
			-- 	mode = "symbol_text",
			-- 	maxwidth = 10,
			-- 	ellipsis_char = "...",
			-- }),
		},
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-j>"] = cmp.mapping.scroll_docs(4),
			["<C-k>"] = cmp.mapping.scroll_docs(-4),
			["<C-Space>"] = cmp.mapping.complete({}),
			["<C-e>"] = cmp.mapping.close(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				local col = vim.fn.col(".") - 1
				if cmp.visible() then
					cmp.select_next_item(cmp_select_opts)
				---@diagnostic disable-next-line: undefined-field, param-type-mismatch
				elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
					fallback()
				else
					cmp.complete()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item(cmp_select_opts)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
			{ name = "emoji" },
			{ name = "neorg" },
		}),
		-- documentation = {
		--   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		--   winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
		-- },
		experimental = {
			-- ghost_text = {
			-- 	hl_group = "LspCodeLens",
			-- },
		},
	})
	if cmdline then
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				-- { name = "noice_popupmenu" },
				{ name = "path" },
				{ name = "cmdline" },
				-- { name = "cmdline_history" },
			}),
		})
	end
end

return M
