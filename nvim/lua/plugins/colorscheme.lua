local DEFAULT_THEME = "flow"

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
}
