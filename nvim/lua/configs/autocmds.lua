vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Make terminal look normal and start in insert
vim.api.nvim_create_autocmd("TermOpen", {
	command = "setlocal listchars= nonumber norelativenumber nocursorline",
})
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "",
	command = "startinsert",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help", "man", "notify",
		"lspinfo", "spectre_panel", "startuptime",
		"tsplayground", "PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.h",
	callback = function()
		vim.bo.filetype = "cpp"
	end,
})
