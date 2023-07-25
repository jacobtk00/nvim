local M = {
	"projekt0n/github-nvim-theme",
	-- Loads when doing `colo github`
	lazy = true,
	-- priority = 999,
	-- event = "ColorScheme", -- ColorSchemePre
}

function M.config()
	require("github-theme").setup({
		dark_sidebar = true,
		theme_style = "dark_default",
	})
end

return M
