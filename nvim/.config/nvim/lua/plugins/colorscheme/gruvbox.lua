local M = {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
}

function M.config()
	vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})
	require("gruvbox").setup({
		transparent_mode = true,
	})
end

return M
