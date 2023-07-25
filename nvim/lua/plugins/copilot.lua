local M = {
	"github/copilot.vim",
	event = "BufRead",
	lazy = true,
}

function M.init()
	vim.g.copilot_no_tab_map = true
	vim.api.nvim_set_keymap("i", "<C-h>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
	-- vim.g.copilot_filetypes = {
	-- 	["*"] = false,
	-- 	["javascript"] = true,
	-- 	["typescript"] = true,
	-- 	["javascriptreact"] = true,
	-- 	["typescriptreact"] = true,
	-- 	["json"] = true,
	-- 	["lua"] = true,
	-- 	["rust"] = true,
	-- 	["c"] = true,
	-- 	["python"] = true,
	-- 	["go"] = true,
	-- }
end

return M
