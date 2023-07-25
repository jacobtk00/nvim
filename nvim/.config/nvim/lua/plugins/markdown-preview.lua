local M = {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	ft = { "markdown" },
	cmd = {
		"MarkdownPreview",
		"MarkdownPreviewStop",
		"MarkdownPreviewToggle",
	},
}

function M.config()
	vim.g.mkdp_filetypes = { "markdown" }
end

return M
