-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match

		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
		local backup = vim.fn.fnamemodify(file, ":p:~:h")
		backup = backup:gsub("[/\\]", "%%")
		vim.go.backupext = backup
	end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0
	end,
})

-- Highlighted Yanking
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

-- Autoclose terminal
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "term://*",
	command = "stopinsert",
})

-- vim.opt.pumheight = 12
-- -- Increase Limit on popup rows for cmdline
-- vim.api.nvim_create_autocmd("CmdlineEnter", {
--   callback = function()
--     vim.opt.pumheight = 20
--   end,
-- })
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
--   callback = function()
--     vim.opt.pumheight = 10
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Get Rid of TMUX status bar on enter
-- vim.cmd("autocmd VimEnter,VimLeave * silent !tmux set status")
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { pattern = "*", command = "silent !tmux set status off" })
-- vim.api.nvim_create_autocmd({ "VimLeave" }, { pattern = "*", command = "silent !tmux set status on" })

vim.api.nvim_create_user_command("TmuxStatusToggle", "silent !tmux set status", {})
