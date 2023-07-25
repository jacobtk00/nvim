-- vim.cmd([[let g:neo_tree_remove_legacy_commands = 1 ]])
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	keys = {
		-- { "<leader>fT", "<cmd>Neotree toggle<CR>", desc = "NeoTree (cwd)" },
		{ "<leader>fT", "<cmd>Neotree toggle<CR>", desc = "Neotree %:p:h" },
		-- { "<leader>e", "<leader>ft", desc = "NeoTree (root dir)", remap = true },
		{ "<leader>e", "<leader>fT", desc = "NeoTree", remap = true },
	},
	-- init = function()
	-- 	vim.g.neo_tree_remove_legacy_commands = 1
	-- 	if vim.fn.argc() == 1 then
	-- 		local stat = vim.loop.fs_stat(vim.fn.argv(0))
	-- 		if stat and stat.type == "directory" then
	-- 			require("neo-tree")
	-- 		end
	-- 	end
	-- end,
	opts = {
		close_if_last_window = true,
		window = {
			position = "left",
			width = 25,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = false,
				},
				["<2-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["S"] = "open_split",
				["s"] = "open_vsplit",
				-- ["S"] = "split_with_window_picker",
				-- ["s"] = "vsplit_with_window_picker",
				["u"] = "navigate_up",
				["t"] = "open_tabnew",
				["w"] = "open_with_window_picker",
				["C"] = "close_node", -- Default is C
				["a"] = {
					"add",
					config = {
						show_path = "relative", -- "none", "relative", "absolute"
					},
				},
				["A"] = "add_directory", -- also accepts the config.show_path option.
				["D"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy", -- takes text input for destination
				["m"] = "move", -- takes text input for destination
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["P"] = { "toggle_preview", config = { use_float = true } },
				["o"] = function(var)
					local cmd = "open " .. var.path
					os.execute(cmd)
				end,
			},
		},
		filesystem = {
			hijack_netrw_behavior = "open_default",
			filtered_items = {
				hide_dotfiles = false,
				hide_hidden = true, -- only works on Windows for hidden files/directories
				hide_by_name = {
					"node_modules",
					"__pycache__",
				},
				always_show = {
					".gitignore",
					".env",
				},
			},
			follow_current_file = { enabled = false },
			use_libuv_file_watcher = true,
		},
	},
}

--require("neo-tree").setup({
--  close_if_last_window = true,
--  window = {
--    position = "left",
--    width = 25,
--    mapping_options = {
--      noremap = true,
--      nowait = true,
--    },
--    mappings = {
--      ["<space>"] = {
--        "toggle_node",
--        nowait = false,
--      },
--      ["<2-LeftMouse>"] = "open",
--      ["<cr>"] = "open",
--      ["S"] = "open_split",
--      ["s"] = "open_vsplit",
--      -- ["S"] = "split_with_window_picker",
--      -- ["s"] = "vsplit_with_window_picker",
--      ["u"] = "navigate_up",
--      ["t"] = "open_tabnew",
--      ["w"] = "open_with_window_picker",
--      ["C"] = "close_node", -- Default is C
--      ["a"] = {
--        "add",
--        config = {
--          show_path = "relative", -- "none", "relative", "absolute"
--        },
--      },
--      ["A"] = "add_directory", -- also accepts the config.show_path option.
--      ["D"] = "delete",
--      ["r"] = "rename",
--      ["y"] = "copy_to_clipboard",
--      ["x"] = "cut_to_clipboard",
--      ["p"] = "paste_from_clipboard",
--      ["c"] = "copy", -- takes text input for destination
--      ["m"] = "move", -- takes text input for destination
--      ["q"] = "close_window",
--      ["R"] = "refresh",
--      ["?"] = "show_help",
--      ["P"] = { "toggle_preview", config = { use_float = true } },
--      ["o"] = function(var)
--        local cmd = "open " .. var.path
--        os.execute(cmd)
--      end,
--    },
--  },
--  filesystem = {
--    filtered_items = {
--      hide_hidden = true, -- only works on Windows for hidden files/directories
--      hide_by_name = {
--        "node_modules",
--        "__pycache__",
--      },
--      always_show = {
--        ".gitignore",
--        ".env",
--      },
--    },
--    follow_current_file = false,
--    use_libuv_file_watcher = true,
--  },
--})
