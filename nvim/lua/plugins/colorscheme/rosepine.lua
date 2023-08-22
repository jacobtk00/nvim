local M = {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	priority = 999,
}

-- M.opts = {
-- 	disable_background = true,
-- }
function M.config()
	require("rose-pine").setup({
		disable_background = true,
		disable_float_background = true,
	})
	-- vim.cmd([[ colorscheme rose-pine ]])
	-- vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return M
