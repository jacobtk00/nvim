local CMP = {
	'saghen/blink.cmp',
	dependencies = {
		-- 'rafamadriz/friendly-snippets',
		{
			'L3MON4D3/LuaSnip',
			version = 'v2.*',
			build = "make install_jsregexp",
			config = function()
				require("luasnip/loaders/from_vscode").lazy_load()
				require("configs.snippets").configure_snippets()
			end
		}
	},
	version = '*',
	opts = {
		keymap = { preset = 'enter', ['<c-h>'] = {} },
		appearance = {
			-- use_nvim_cmp_as_default = true,
			nerd_font_variant = 'mono'
		},
		completion = {
			accept = {
				-- experimental auto-brackets support
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},
		snippets = {
			preset = 'luasnip',
			-- expand = function(snippet)
			-- 	require('luasnip').lsp_expand(snippet)
			-- end,
			-- active = function(filter)
			-- 	if filter and filter.direction then
			-- 		return require('luasnip').jumpable(filter.direction)
			-- 	end
			-- 	return require('luasnip').in_snippet()
			-- end,
			-- jump = function(direction) require('luasnip').jump(direction) end,
		},
		cmdline = {
			enabled = false
		},
		sources = {
			default = { 'lsp', "easy-dotnet", 'snippets', 'path', 'buffer' },
			providers = {
				["easy-dotnet"] = {
					name = "easy-dotnet",
					enabled = true,
					module = "easy-dotnet.completion.blink",
					score_offset = 10000,
					async = true,
				},
			},
			-- providers = {
			-- 	snippets = {
			-- 		should_show_items = function(ctx)
			-- 			return ctx.trigger.initial_kind ~= 'trigger_character'
			-- 		end
			-- 	}
			-- }
		},
		signature = { enabled = true },
		enabled = function()
			return not vim.tbl_contains({ "DressingInput", "markdown", "copilot-chat" }, vim.bo.filetype)
				and vim.bo.buftype ~= "prompt"
				and vim.b.completion ~= false
		end,
	}
}
return CMP
