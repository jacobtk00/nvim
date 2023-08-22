return {
	{
		"Mofiqul/vscode.nvim",
		init = function()
			require("vscode").load()
		end,
		priority = 1000,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		opts = {
			close_if_last_window = true,
			window = {
				width = 25,
				mappings = { ["u"] = "navigate_up" },
			},
			filestystem = {
				filtered_items = {
					hide_dotfiles = false,
					always_show = { ".gitignore", ".env" },
				},
				follow_current_file = { eneabled = false },
			},
		},
		keys = {
			{ "<leader>pf", "<cmd>Neotree left reveal_force_cwd<cr>", desc = "Neotree" },
		},
	},
	{ "folke/which-key.nvim", opts = {} },
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
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
				globalstatus = true,
			},
		},
	},
	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		keys = { "gc", "gb", "gcc", { "gc", move = "v" }, { "gb", move = "v" } },
	},
	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					pcall(require("telescope").load_extension, "fzf")
				end,
			},
		},
		keys = {
			{
				"<leader>fo",
				function()
					require("telescope.builtin").oldfiles()
				end,
				desc = "Find [O]ld",
			},
			{
				"<leader>b",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find [B]uffers",
			},
			{
				"<leader>fp",
				function()
					require("telescope.builtin").git_files()
				end,
				desc = "Find [P]roject",
			},
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find [F]iles",
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Find [G]rep",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		dependencies = { "windwp/nvim-ts-autotag" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "go", "lua", "tsx", "typescript", "vimdoc", "vim", "bash", "comment" },
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
				additional_vim_regex_highlighting = false,
			})
		end,
	},
	{
		"github/copilot.vim",
		event = "BufRead",
		lazy = true,
		init = function()
			vim.g.copilot_no_tab_map = true
			vim.api.nvim_set_keymap("i", "<C-h>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		config = true,
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end,
	},
}
