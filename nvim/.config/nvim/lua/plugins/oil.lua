local M = {
	"stevearc/oil.nvim",
	lazy = true,
}

M.keys = {
	{ "-", "<cmd>Oil<cr>", desc = "Oil Dir" },
}

M.config = {
	keymaps = {
		["q"] = "actions.close",
	},
}

-- function M.config()
-- 	require("oil").setup()
-- 	vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
-- 	vim.keymap.set("n", "<C-_>", require("oil").close, { desc = "Close parent directory" })
-- end

return M
