local M = {
	"numToStr/Comment.nvim",
	-- event = "BufEnter",
}

M.keys = {
	"gc",
	"gb",
	"gcc",
	{ "gc", mode = "v" },
	{ "gb", mode = "v" },
}

function M.config()
	require("Comment").setup({
		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	})
end

return M
