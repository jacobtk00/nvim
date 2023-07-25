local M = {
	"anuvyklack/windows.nvim",
	event = "WinNew",
	dependencies = {
		{ "anuvyklack/middleclass" },
		{ "anuvyklack/animation.nvim", enabled = false },
	},
	keys = {
		{ "<leader>sm", "<cmd>WindowsMaximize<cr>", desc = "Zoom" },
		{ "<leader>se", "<cmd>WindowsEqualize<cr>", desc = "Equalize" },
		{ "<leader>sa", "<cmd>WindowsToggleAutowidth<cr>", desc = "Auto Width" },
	},
}

function M.config()
	vim.o.winwidth = 5
	vim.o.equalalways = false
	require("windows").setup({
		animation = { enable = false, duration = 150 },
	})
end

return M
