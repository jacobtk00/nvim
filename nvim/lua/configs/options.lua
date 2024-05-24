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
opt.splitright = true

opt.shortmess:append("W") -- don't show written
opt.shortmess:append("I") -- don't show the default intro message
opt.shortmess:append("c") -- don't show redundant messages from ins-completion-menu
opt.shortmess:append("C") -- don't show scanning msgs
opt.shortmess:append("s") -- don't show search hit bottom
opt.shortmess:append("F") -- don't show file info when editing a file

-- Set completeopt to have a better completion experience, noinsert mode btw
opt.completeopt = "menuone,noselect,noinsert"
opt.termguicolors = true
