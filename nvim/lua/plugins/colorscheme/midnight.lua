local M = { "dasupradyumna/midnight.nvim", lazy = false, priority = 1000 }

function M.config()
	vim.cmd([[ colorscheme midnight ]])
	vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {})
end

return { M }
