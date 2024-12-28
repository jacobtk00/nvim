return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
				styles = { sidebars = "transparent", floats = "transparent" },
			})
			-- vim.cmd("colorscheme tokyonight")
		end,
	},

	{
		"0xstepit/flow.nvim",
		lazy = false,
		priority = 1000,
		tag = "v2.0.0",
		config = function()
			require("flow").setup({
				theme = { style = "dark", transparent = true },
			})
			vim.cmd("colorscheme flow")
		end
	},

	{
		"Mofiqul/vscode.nvim",
		init = function()
			require("vscode").load()
		end,
		priority = 1000,
	},
}
