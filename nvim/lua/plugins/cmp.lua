local CMP = {
	-- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		'saadparwaiz1/cmp_luasnip',
		"rafamadriz/friendly-snippets",
		{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" }
	},
}

-- [[ Configure nvim-cmp ]]
function CMP.config()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	require("luasnip.loaders.from_vscode").lazy_load()
	luasnip.config.setup({})

	cmp.setup({
		snippet = {
			expand = function(args)
				-- luasnip.lsp_expand(args.body)
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip").lsp_expand(args.body)
			end,
		},
		completion = { completeopt = "menu,menuone,noinsert", docs_initially_visible = false },
		formatting = {
			format = function(_entry, vim_item)
				local a = vim_item.abbr
				if #a > 20 then
					vim_item.abbr = string.sub(a, 1, 20) .. "..."
				end

				local w = vim_item.word
				if #w > 20 then
					vim_item.word = string.sub(w, 1, 20) .. "..."
				end

				local m = vim_item.menu and vim_item.menu or ""
				if #m > 20 then
					vim_item.menu = string.sub(m, 1, 20) .. "..."
				end
				return vim_item
			end,
		},

		mapping = cmp.mapping.preset.insert({
			["<c-n>"] = cmp.mapping.select_next_item(),
			["<c-p>"] = cmp.mapping.select_prev_item(),
			["<c-u>"] = cmp.mapping.scroll_docs(-4),
			["<c-d>"] = cmp.mapping.scroll_docs(4),
			["<c-Space>"] = cmp.mapping.complete(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			["<C-l>"] = cmp.mapping(function()
				if cmp.visible_docs() then
					cmp.close_docs()
				else
					cmp.open_docs()
				end
			end),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
		},
	})
end

return CMP
