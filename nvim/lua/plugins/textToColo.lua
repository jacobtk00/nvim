local M = {
	"svermeulen/text-to-colorscheme.nvim",
}

function M.config()
	require("text-to-colorscheme").setup({
		ai = {
			openai_api_key = "***REMOVED***",
			gpt_model = "gpt-3.5-turbo",
		},
	})
end

return M
