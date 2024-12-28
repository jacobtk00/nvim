local CMP = {
	'saghen/blink.cmp',
	dependencies = 'rafamadriz/friendly-snippets',
	version = '*',
	opts = {
		keymap = { preset = 'enter' },
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
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
			cmdline = {},
		},
		signature = { enabled = true },
		enabled = function()
			return not vim.tbl_contains({ "DressingInput", "markdown" }, vim.bo.filetype)
				and vim.bo.buftype ~= "prompt"
				and vim.b.completion ~= false
		end,
	}
}
return CMP
