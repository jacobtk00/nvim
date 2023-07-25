vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
vim.keymap.set("n", "^", "<C-6>")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>nohl<cr><esc>") -- ?? vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers previewer=false theme=ivy<cr>")
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers previewer=false theme=ivy<cr>")

vim.keymap.set("c", "<S-Enter>", function()
	require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

-- vim.keymap.set("<S-T>", ":FloatermNew --height=0.8 --width=0.8<CR>")
-- vim.keymap.set("n", "T", '<cmd>lua require("lazy.util").float_term()<cr>')
-- vim.keymap.set("n", "T", "<cmd>ToggleTerm size=40 direction=horizontal<cr>")

-- local plugin_dir = '"' .. vim.fn.stdpath("config")('"')
-- vim.api.nvim_create_user_command("LazyTerm", '<cmd>lua require("lazy.util").float_term(' .. plugin_dir .. ")<cr>", {})

vim.keymap.set("t", "\\", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n><C-w>h")

-- Move selected line/block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Yank to clipboard
vim.keymap.set("v", "<c-y>", '"*y', { silent = true })

-- Aligns to a string, looking left and with previews
vim.keymap.set("x", "aw", function()
	require("align").align_to_string(false, true, true)
end, { noremap = true, silent = true })

local wk = require("which-key")

wk.setup({
	show_help = false,
	triggers = "auto",
	plugins = { spelling = true, registers = false, marks = true },
	key_labels = { ["<leader>"] = "SPC" },
})

local leader = {
	["p"] = {
		["f"] = { "<cmd>Neotree left reveal_force_cwd<cr>", "Tree" },
	},
	["f"] = {
		name = "+Telescope",
		["f"] = { "<cmd>Telescope find_files<cr>", "Files" },
		["g"] = { "<cmd>Telescope live_grep<cr>", "Grep" },
		["o"] = { "<cmd>Telescope oldfiles<cr>", "Old" },
		["p"] = { "<cmd>Telescope git_files<cr>", "Git" },
	},
	-- ["b"] = { name = "Buffers", "<cmd>Telescope buffers previewer=false theme=ivy<cr>" },
	["g"] = {
		-- g = { ":FloatermNew --height=0.9 --width=0.9 lazygit<CR>" },
		g = {
			function()
				require("lazy.util").float_term({ "lazygit" })
			end,
			"LazyGit",
		},
	},
	x = {
		name = "+errors",
		x = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble" },
		t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
		T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
		l = { "<cmd>lopen<cr>", "Open Location List" },
		q = { "<cmd>copen<cr>", "Open Quickfix List" },
	},
	["w"] = {
		name = "+Window",
		["o"] = { "<cmd>tabnew<cr>", "New" },
		["c"] = { "<cmd>tabclose<cr>", "Close" },
		["h"] = { "<cmd>tabprevious<cr>", "Previous" },
		["l"] = { "<cmd>tabnext<cr>", "Next" },
		["H"] = { "<cmd>tabmove -1<cr>", "Swap Left" },
		["L"] = { "<cmd>tabmove +1<cr>", "Swap Right" },
		["t"] = { "<cmd>tabnew | terminal<cr>", "New Term" },
	},
	["s"] = {
		name = "+Split",
		["v"] = { "<cmd>vsplit<cr>", "Vertical" },
		["s"] = { "<cmd>split<cr>", "Horizontal" },
	},
}

local g = {
	a = {
		name = "Align",
		w = {
			function()
				local a = require("align")
				a.operator(a.align_to_string, { is_pattern = false, reverse = true, preview = true })
			end,
			"Word",
		},
		a = {
			function()
				local a = require("align")
				a.operator(a.align_to_char, { length = 1, reverse = true, preview = true })
			end,
			"Char",
		},
	},
}
--nmap("<leader>D", "<cmd>ToggleDiag<cr>")
--nmap("<leader>b", "<cmd>Telescope buffers previewer=false theme=ivy<cr>")

-- nmap("<leader>b", "<cmd>Telescope buffers<cr>")
-- -- nmap("<leader>tt", "<cmd>TroubleToggle workspace_diagnostics<cr>")
-- nmap("<leader>tk", function()
--   require("neotest").run.stop()
--   vim.diagnostic.reset()
-- end)

wk.register(leader, { prefix = "<leader>" })
wk.register(g, { prefix = "g" })
wk.register({ g = { name = "+goto" } })
