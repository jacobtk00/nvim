local g = vim.g
local opt = vim.opt

g.mapleader = " "
g.maplocalleader = " "

-- Lazy pm install
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim",       tag = "legacy", opts = {} },
		},
	},

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"rafamadriz/friendly-snippets",
		},
	},

	{ "folke/which-key.nvim",          opts = {} },
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "|" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end
				-- Actions
				map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>")
				map("n", "]h", "<cmd>Gitsigns next_hunk<CR>")
				map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>")
				map("n", "<leader>gs", gs.stage_buffer)
				map("n", "<leader>gu", gs.undo_stage_hunk)
				map("n", "<leader>gR", gs.reset_buffer)
				map("n", "<leader>gp", gs.preview_hunk)
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end)
				map("n", "<leader>gB", gs.toggle_current_line_blame)
				map("n", "<leader>gd", gs.diffthis)
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end)
				map("n", "<leader>gx", gs.toggle_deleted)

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("gruvbox")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
		},
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim",         opts = {} },
	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

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
vim.wo.signcolumn = "yes"
opt.tabstop = 4
opt.signcolumn = "yes"
opt.hidden = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.scrolloff = 8

-- Set completeopt to have a better completion experience, noinsert mode btw
opt.completeopt = "menuone,noselect,noinsert"
opt.termguicolors = true

-- [[ Keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>fp", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>xd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

-- [[ Configure Treesitter ]]
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "cpp", "go", "lua", "python", "rust", "tsx", "typescript", "vimdoc", "vim", "bash" },
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			scope_incremental = "<CR>",
			node_incremental = "<TAB>",
			node_decremental = "<S-TAB>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

local on_attach = function(client, buffer)
	-- local cap = client.server_capabilities
	local keymaps = {
		buffer = buffer,
		["<leader>"] = {
			r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
			a = { name = "Code Action", c = { vim.lsp.buf.code_action, "Code Action" } },
			c = {
				name = "+code",
				{
					cond = client.name == "tsserver",
					o = { "<cmd>TypescriptOrganizeImports<CR>", "Organize Imports" },
					R = { "<cmd>TypescriptRenameFile<CR>", "Rename File" },
				},
				{
					cond = client.name == "gopls",
					m = {
						name = "+Mod",
						t = { "<cmd>GoModTidy<cr>", "Mod Tidy" },
					},
				},
				-- f = {
				-- 	cond = cap.documentFormatting,
				-- 	{ require("plugins.lsp.formatting").format, "Format Document" },
				-- },
				d = { vim.diagnostic.open_float, "Line Diagnostics" },
				l = {
					name = "+lsp",
					i = { "<cmd>LspInfo<cr>", "Lsp Info" },
					a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
					r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
					l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
						"List Folders" },
				},
			},
			x = { d = { "<cmd>Telescope diagnostics<cr>", "Search Diagnostics" } },
		},
		g = {
			name = "+goto",
			d = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
			r = { "<cmd>Telescope lsp_references<cr>", "References" },
			R = { "<cmd>Trouble lsp_references<cr>", "Trouble References" },
			D = { "<cmd>Telescope lsp_declarations<CR>", "Goto Declaration" },
			I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
			t = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
		},
		["<C-k>"] = {
			"<cmd>lua vim.lsp.buf.signature_help()<CR>",
			"Signature Help",
			mode = { --[["n", ]]
				"i",
			},
		},
		["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
		["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Next Diagnostic" },
		["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Prev Diagnostic" },
		["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>",
			"Next Error" },
		["]e"] = { "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>",
			"Prev Error" },
		["[w"] = {
			"<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<CR>",
			"Next Warning",
		},
		["]w"] = {
			"<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<CR>",
			"Prev Warning",
		},
	}

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(buffer, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })


	require("which-key").register(keymaps)
end

local servers = {
	clangd = {},
	gopls = {},
	rust_analyzer = {},
	tsserver = {},
	html = { filetypes = { "html", "twig", "hbs" } },
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostics = { globals = { 'vim' } },
		},
	},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- [[ Configure nvim-cmp ]]
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
