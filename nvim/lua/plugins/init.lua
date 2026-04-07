return {
	-- {
	-- 	'anasinnyk/nvim-k8s-crd',
	-- 	event = { 'BufEnter *.yaml' },
	-- 	dependencies = { 'neovim/nvim-lspconfig' },
	-- 	opts = {
	-- 		cache_dir = vim.fn.expand("$HOME/.cache/nvim-k8s-crd/"),
	-- 		k8s = { file_mask = "*.yaml", }
	-- 	},
	-- },
	--{
	{
		"folke/zen-mode.nvim",
		opts = {},
		keys = {
			{ "<leader>z", function() require("zen-mode").toggle() end, desc = "Zen Mode" },
		},
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
		config = function()
			require("easy-dotnet").setup({ --[[  lsp = { enabled = false }  ]] })
		end,
		cmd = "Dotnet",
		ft = { "cs", "csproj", "sln", "slnx", "props", "csx", "targets" },
	},

	-- NOTE: if roslyn is not working, or switching between projects stops roslyn, it may be because a limit on notifications. try increasing the limit:
	-- echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
	{
		"seblj/roslyn.nvim",
		event = { "BufReadPre", "BufNewFile" },
		enabled = false,
		-- ft = "cs",
		opts = {
			-- disable if slow
			-- filewatching = "roslyn",
			-- broad_search = true,
		}
	},
	{
		"stevearc/oil.nvim",
		lazy = true,
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Oil Dir" },
		},
		config = {
			keymaps = {
				["q"] = "actions.close",
			},
		},
	},
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true,
		keys = {
			{ "<leader>nn", "<cmd>Neogen<cr>",       desc = "Neogen Func" },
			{ "<leader>nc", "<cmd>Neogen class<cr>", desc = "Neogen Class" },
			{ "<leader>nf", "<cmd>Neogen func<cr>",  desc = "Neogen Func" },
		},
		opts = {
			languages = {
				cs  = { template = { annotation_convention = "xmldoc" } },
				go  = { template = { annotation_convention = "godoc" } },
				lua = { template = { annotation_convention = "emmylua" } },
				sh  = { template = { annotation_convention = "google_bash" } },
			}
		}
	},


	-- UI
	{
		"stevearc/dressing.nvim",
		-- commit = "1f2d120",
		event = "BufReadPost",
		opts = {
			input = { win_options = { winblend = 0 } },
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				disabled_filetypes = { statusline = { "java" } },
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
				globalstatus = true,
			},
		},
	},
	{
		"folke/styler.nvim",
		config = function()
			require("styler").setup({
				themes = {
					DiffView = { colorscheme = "tokyonight-night" },
				},
			})
		end,
	},

	-- Desperately need
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		dependencies = { "windwp/nvim-ts-autotag" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "go", "lua", "tsx", "typescript", "vimdoc", "vim", "bash", "comment" },
				auto_install = false,
				highlight = { enable = true, additional_vim_regex_highlighting = false },
				indent = { enable = true },
				autotag = { enable = true },
				additional_vim_regex_highlighting = false,
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
		opts = {
		},
		keys = {
			{ "<leader>xc", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
			{
				"]c",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment"
			},
			{
				"[c",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Next Todo Comment"
			},
		},
		lazy = false,
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/trouble.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					pcall(require("telescope").load_extension, "fzf")
				end,
			},
		},
		config = function()
			-- local trouble, err = require("trouble.providers.telescope")
			local trouble, err = require("trouble.sources.telescope")
			if not err then
				require("telescope").setup({
					defaults = {
						mappings = {
							i = { ["<c-q>"] = trouble.open, ["<c-f>"] = require("telescope.actions").smart_send_to_qflist },
							n = { ["<c-q>"] = trouble.open },
						},
					},
				})
			end
		end,
		keys = {
			{ "<leader>fo", require("telescope.builtin").oldfiles,   desc = "Find [O]ld" },
			{ "<leader>b",  require("telescope.builtin").buffers,    desc = "Find [B]uffers" },
			{ "<leader>fp", require("telescope.builtin").git_files,  desc = "Find [P]roject" },
			{ "<leader>ff", require("telescope.builtin").find_files, desc = "Find [F]iles" },
			{ "<leader>fg", require("telescope.builtin").live_grep,  desc = "Find [G]rep" },
			{
				"<leader>fw",
				function()
					require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
				end,
				desc = "Find [W]ord"
			},
			{
				"<leader>fn",
				function()
					require("telescope.builtin").find_files({ default_text = vim.fn.expand("<cword>") })
				end,
				desc = "Find [N]amed File"
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			default_component_configs = {
				file_size = { enabled = false },
				last_modified = { enable = false },
				type = { enabled = false },
			},
			close_if_last_window = true,
			window = {
				width = 25,
				mappings = { ["u"] = "navigate_up" },
			},
			filesystem = {
				hijack_netrw_behavior = "open_default",
				filtered_items = {
					hide_dotfiles = false,
					hide_hidden = true,
					hide_by_name = { "node_modules", "__pycache__" },
					always_show = { ".gitignore", ".env" },
				},
				follow_current_file = { enabled = false },
				use_libuv_file_watcher = true,
			},
		},
		keys = {
			{ "<leader>pf", "<cmd>Neotree left reveal_force_cwd<cr>", desc = "Neotree" },
		},
	},
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		keys = { "gc", "gb", "gcc", { "gc", mode = "v" }, { "gb", mode = "v" } },
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		keys = { "cs", "ys", "ds" },
		opts = {},
	},

	-- Quality of life
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { auto_open = false, use_diagnostic_signs = true, focus = true },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics<cr>",                                                 desc = "Trouble Diagnostic" },
			{ "<leader>xe", "<cmd>Trouble diagnostics filter.severity = vim.diagnostic.severity.ERROR<cr>", desc = "Trouble Error" },
			{ "<leader>gr", "<cmd>Trouble lsp_references<cr>",                                              desc = "Trouble References" },
		},
		lazy = false
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, desc)
					local opts = { desc = desc, silent = true }
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']h', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']h', bang = true })
					else
						gs.nav_hunk('next')
					end
				end)

				map('n', '[h', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[h', bang = true })
					else
						gs.nav_hunk('prev')
					end
				end)
				-- Actions
				map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>")
				map("n", "<leader>gs", gs.stage_buffer, "Stage Buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
				map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
				map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame Line")
				map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle Blame")
				map("n", "<leader>gd", gs.diffthis, "Diff This")
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, "Diff This (cached)")
				map("n", "<leader>gx", gs.toggle_deleted, "Toggle Deleted")

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Hunk")
			end,
		},
	},
	{ "folke/which-key.nvim", opts = {} },
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		-- config = true,
		opts = {
			keymaps = { view = { { "n", "q", "<cmd>DiffviewClose<cr>", { silent = true } } } },
			view = { default = { winbar_info = true } },
			hooks = {
				diff_buf_read = function(bufnr)
					-- Change local options in diff buffers
					vim.opt_local.wrap = false
					vim.opt_local.list = false
					vim.opt_local.colorcolumn = { 80 }
					vim.opt.fillchars:append({ diff = "╱" })
				end,
				diff_buf_win_enter = function(bufnr, winid, ctx)
					-- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
					-- the right.
					if ctx.layout_name:match("^diff2") then
						if ctx.symbol == "a" then
							vim.opt_local.winhl = table.concat({
								"DiffAdd:DiffviewDiffAddAsDelete",
								"DiffDelete:DiffviewDiffDelete",
								"DiffChange:DiffAddAsDelete",
								"DiffText:DiffDeleteText",
							}, ",")
						elseif ctx.symbol == "b" then
							vim.opt_local.winhl = table.concat({
								"DiffDelete:DiffviewDiffDelete",
								"DiffChange:DiffAdd",
								"DiffText:DiffAddText",
							}, ",")
						end
					end
				end,
			},
		},
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
		end,
	},
	-- {
	-- 	"NvChad/nvim-colorizer.lua",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("colorizer").setup()
	-- 	end,
	-- },
}
