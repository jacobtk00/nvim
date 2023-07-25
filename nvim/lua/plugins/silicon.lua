local M = {
	"krivahtoo/silicon.nvim",
	build = "./install.sh build",
	cmd = { "Silicon" },
	-- lazy = false,
}

function M.config()
	require("silicon").setup({
		font = "JetBrains Mono Nerd Font=16",
		theme = "Dracula",
		pad_horiz = 0,
		pad_vert = 0,
	})
end

return M
