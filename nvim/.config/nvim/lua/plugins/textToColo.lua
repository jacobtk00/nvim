local M = {
	"svermeulen/text-to-colorscheme.nvim",
}

function M.config()
	require("text-to-colorscheme").setup({
		ai = {
			openai_api_key = "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",
			gpt_model = "gpt-3.5-turbo",
		},
	})
end

return M
