return {
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	"b0o/SchemaStore.nvim",
	"MunifTanjim/nui.nvim",
	"jose-elias-alvarez/typescript.nvim",
	"ray-x/guihua.lua",
	"williamboman/mason-lspconfig.nvim",
	"folke/twilight.nvim",
	"folke/which-key.nvim",
	-- Better vim.ui
	{ "tpope/vim-cucumber", lazy = false },

	{ "shortcuts/no-neck-pain.nvim", version = "*", cmd = { "NoNeckPain", "NoNeckPainResize" } },

	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},

	-- TODO: IDK AB THIS MAYBE ????????????????
	{
		"folke/styler.nvim",
		event = "VeryLazy",
		config = {
			themes = {
				markdown = { colorscheme = "oxocarbon" },
				help = { colorscheme = "oxocarbon" },
				NeogitStatus = { colorscheme = "oxocarbon", background = "dark" },
			},
		},
	},

	{
		"nacro90/numb.nvim",
		lazy = false,
		opts = {
			show_numbers = true,
			show_cursorline = true,
			hide_relativenumbers = true,
			centered_peeking = true,
		},
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			start_in_insert = true,
		},
		keys = {
			{ "T", "<cmd>ToggleTerm dir=%:p:h<cr>", desc = "Toggle Terminal" },
		},
	},

	{ "Vonr/align.nvim", event = "BufEnter" },

	-- {
	-- 	"smjonas/inc-rename.nvim",
	-- 	cmd = "IncRename",
	-- 	config = true,
	-- },

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},

	-- --- LSP ---
	-- {
	-- 	"SmiteshP/nvim-navic",
	-- 	config = function()
	-- 		vim.g.navic_silence = true
	-- 		require("nvim-navic").setup({ separator = " ", highlight = true, depth_limit = 5 })
	-- 	end,
	-- },

	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor({})
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
	},

	{
		"simrat39/symbols-outline.nvim",
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
		config = true,
	},

	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	{
		"m-demare/hlargs.nvim",
		event = "VeryLazy",
		enabled = false,
		opts = {
			excluded_argnames = {
				usages = {
					lua = { "self", "use" },
				},
			},
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = {
			auto_open = false,
			use_diagnostic_signs = true, -- en
		},
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
	},

	{
		"Wansmer/treesj",
		keys = {
			{ "J", "<cmd>TSJToggle<cr>" },
		},
		opts = { use_default_keymaps = false },
	},

	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},

	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end,
	},
}
