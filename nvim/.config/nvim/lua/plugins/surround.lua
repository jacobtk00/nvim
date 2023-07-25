local M = {
	"kylechui/nvim-surround",
	version = "*",
	-- event = "BufEnter",
}
M.keys = {
	"cs",
	"ys",
	"ds",
}
function M.config()
	require("nvim-surround").setup()
end

return M
