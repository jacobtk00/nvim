local DEFAULT_THEME = "vscode"

local config = function(plugin, opts)
	if plugin.name == DEFAULT_THEME or plugin.name == DEFAULT_THEME .. ".nvim" then
		require(DEFAULT_THEME).setup(opts)
		vim.cmd("colorscheme " .. DEFAULT_THEME)
	end
end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent"
			},
		},
		config = config,
	},

	{
		"0xstepit/flow.nvim",
		lazy = false,
		priority = 1000,
		tag = "v2.0.0",
		opts = {
			theme = {
				style = "dark",
				transparent = true,
			}
		},
		config = config,
	},

	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			transparent = true,
		},
		config = config,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "macchiato",
			transparent_background = true,
			integrations = {
				telescope = true,
				nvimtree = true,
				which_key = true,
				markdown = true,
				cmp = true,
				gitsigns = true,
				lsp_trouble = true,
				notify = true,
				noice = true,
			},
		},
		config = config,
	}
}
