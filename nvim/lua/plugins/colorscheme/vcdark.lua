local M = {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 999,
}

-- M.opts = {
-- 	disable_background = true,
-- }
function M.config()
	require("vscode").setup({
		italic_comments = true,
	})
	require("vscode").load("dark")
end

return M
