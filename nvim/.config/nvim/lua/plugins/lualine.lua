local M = {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
}

function M.config()
	require("lualine").setup({
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				"neo-tree",
				"help",
				"packer",
				"neogitstatus",
				"Trouble",
				"Outline",
				"toggleterm",
				"zsh",
				"no-neck-pain",
			},
			global_status = true,
		},
		sections = {
			lualine_x = { "filetype" },
			lualine_c = {
				{ "filename" },
				{
					require("noice").api.status.search.get,
					cond = require("noice").api.status.search.has,
					color = { fg = "#ff9e64" },
				},
				{
					require("noice").api.status.mode.get,
					cond = require("noice").api.status.mode.has,
					color = { fg = "#ff9e64" },
				},
			},
		},
	})
end

return M
