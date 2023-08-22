local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

-- [[ Setting options ]]
g.c_syntax_for_h = 1
vim.wo.number = true
opt.hlsearch = false
opt.mouse = "a"
opt.breakindent = true
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.swapfile = false
opt.ignorecase = true
opt.smartcase = true
vim.wo.wrap = false
opt.autoindent = true
opt.signcolumn = "yes"
opt.tabstop = 4
opt.shiftwidth = 0
opt.relativenumber = true
opt.hidden = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.scrolloff = 8
opt.cmdheight = 0
opt.pumheight = 12

-- Set completeopt to have a better completion experience, noinsert mode btw
opt.completeopt = "menuone,noselect,noinsert"
opt.termguicolors = true
