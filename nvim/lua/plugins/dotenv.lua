local M = {
	"ellisonleao/dotenv.nvim",
	cmd = "Dotenv",
}

function M.config()
	require("dotenv").setup({
		enable_on_load = true, -- will load your .env file upon loading a buffer
		verbose = false, -- show error notification if .env file is not found and if .env is loaded
	})
end

return M
