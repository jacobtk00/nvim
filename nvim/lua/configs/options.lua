---@diagnostic disable: assign-type-mismatch
local g = vim.g
local opt = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------------------------------------------------------------------------
--- General
--------------------------------------------------------------------------------
opt.mouse = "a" -- For fun
-- opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.completeopt = { "menuone", "noinsert", "noselect" }
opt.autoindent = true
opt.wildignore = {
	"__pycache__",
	"*.o",
	"*~",
	"*.pyc",
	"*pycache*",
	"*.so",
	"*.swp",
	"*/.git/",
	"*.class",
	"*/target/*",
	"*/node_modules/*",
}
opt.scrolloff = 8
opt.spell = false
opt.wrap = false

opt.shortmess:append("W") -- don't show written
opt.shortmess:append("I") -- don't show the default intro message
opt.shortmess:append("c") -- don't show redundant messages from ins-completion-menu
opt.shortmess:append("C") -- don't show scanning msgs
opt.shortmess:append("s") -- don't show search hit bottom
opt.shortmess:append("F") -- don't show file info when editing a file
-- opt.shortmess:append("A") -- don't show swap file msg
-- opt.shortmess:append("O") -- don't show scanning msgs
-- vim.o.shortmess = "filnxtToOFWIcC"
-- shortmess=OnftiFWxTsocIlAC

opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.laststatus = 0 -- maybe 3??

--------------------------------------------------------------------------------
--- UI
--------------------------------------------------------------------------------
opt.relativenumber = true
opt.showmatch = true
opt.splitright = true
opt.splitbelow = false
opt.ignorecase = true
opt.smartcase = true
opt.cmdheight = 0
opt.signcolumn = "yes"
opt.termguicolors = true
-- opt.fillchars = { eob = " " }
opt.hlsearch = false
opt.incsearch = true
opt.cursorline = false
opt.confirm = true

opt.number = true
opt.pumheight = 12

-- See ":h fo-table" for options
-- Disables comment on new line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

--------------------------------------------------------------------------------
--- Tabs
--------------------------------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

--------------------------------------------------------------------------------
--- Memory,CPU
--------------------------------------------------------------------------------
opt.hidden = true
opt.synmaxcol = 240
opt.updatetime = 500

--------------------------------------------------------------------------------
--- Startup
--------------------------------------------------------------------------------
g.python3_host_prog = "/opt/homebrew/bin/python3"
g.c_syntax_for_h = 1

--------------------------------------------------------------------------------
--- NEOVIDE
--------------------------------------------------------------------------------
if g.neovide then
	opt.guifont = { "JetBrains Mono", ":h24" }
	g.neovide_scale_factor = 200.0
	--vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_remember_window_size = true
end

-- local indent = 2
--
--
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "
-- vim.g.node_host_prog = "/Users/folke/.pnpm-global/5/node_modules/neovim/bin/cli.js"
-- vim.opt.autowrite = true -- enable auto write
-- vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
-- -- vim.opt.concealcursor = "nc" -- Hide * markup for bold and italic
-- vim.opt.conceallevel = 3 -- Hide * markup for bold and italic
-- vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
-- vim.opt.cursorline = true -- Enable highlighting of the current line
-- vim.opt.expandtab = true -- Use spaces instead of tabs
-- vim.opt.backup = true
-- vim.opt.spelllang = { "en" }
--
-- vim.o.formatoptions = "jcroqlnt" -- tcqj
-- vim.opt.guifont = "FiraCode Nerd Font:h11"
-- vim.opt.grepprg = "rg --vimgrep"
-- vim.opt.grepformat = "%f:%l:%c:%m"
-- vim.opt.hidden = true -- Enable modified buffers in background
-- vim.opt.ignorecase = true -- Ignore case
-- vim.opt.inccommand = "nosplit" -- preview incremental substitute
-- vim.opt.joinspaces = false -- No double spaces with join after a dot
-- vim.opt.list = true -- Show some invisible characters (tabs...
-- vim.opt.mouse = "a" -- enable mouse mode
-- vim.opt.number = true -- Print line number
-- vim.opt.pumblend = 10 -- Popup blend
-- vim.opt.pumheight = 10 -- Maximum number of entries in a popup
-- vim.opt.relativenumber = true -- Relative line numbers
-- vim.opt.scrolloff = 8 -- Lines of context
-- vim.opt.shiftround = true -- Round indent
-- vim.opt.shiftwidth = indent -- Size of an indent
-- vim.opt.laststatus = 0
-- vim.opt.showmode = false -- dont show mode since we have a statusline
-- vim.opt.sidescrolloff = 8 -- Columns of context
-- vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
-- vim.opt.smartcase = true -- Don't ignore case with capitals
-- vim.opt.smartindent = true -- Insert indents automatically
--
-- vim.opt.splitbelow = true -- Put new windows below current
-- vim.opt.splitright = true -- Put new windows right of current
-- vim.opt.tabstop = indent -- Number of spaces tabs count for
-- vim.opt.termguicolors = true -- True color support
-- vim.opt.undofile = true
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- vim.opt.undolevels = 10000
-- vim.opt.updatetime = 200 -- save swap file and trigger CursorHold
-- vim.opt.swapfile = false
-- vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
-- vim.opt.completeopt = "menu,menuone,noselect"
-- vim.opt.wrap = false -- Disable line wrap
-- vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
-- vim.opt.fillchars = {
--   --   horiz = "━",
--   --   horizup = "┻",
--   --   horizdown = "┳",
--   --   vert = "┃",
--   --   vertleft = "┫",
--   --   vertright = "┣",
--   --   verthoriz = "╋",im.o.fillchars = [[eob: ,
--   -- fold = " ",
--   foldopen = "",
--   -- foldsep = " ",
--   foldclose = "",
-- }
-- vim.g.markdown_recommended_style = 0
-- vim.opt.splitkeep = "screen"
-- vim.o.shortmess = "filnxtToOFWIcC"
