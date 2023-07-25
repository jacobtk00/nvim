local M = {
	"akinsho/nvim-bufferline.lua",
	event = "BufAdd",
}

function M.config()
	require("bufferline").setup({
		options = {
			mode = "tabs",
			auto_close = true,
			always_show_bufferline = false,
			offsets = {
				{
					text = "Neo-Tree",
					filetype = "neo-tree",
					text_align = "center",
					separator = true,
				},
			},
		},
	})
end

return M
