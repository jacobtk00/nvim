-- [[ Keymaps ]]
vim.keymap.set("n", "^", "<C-6>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { noremap = true })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { noremap = true })

vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true })
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<c-y>", '"*y', { silent = true })

-- Quickfix keymaps
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

vim.keymap.set("t", "\\", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n><C-w>h")

-- Diagnostic keymaps
vim.keymap.set(
	"n", "[d",
	function() vim.diagnostic.jump({ count = -1, float = true }) end,
	{ desc = "Go to previous diagnostic message" }
)
vim.keymap.set(
	"n", "]d",
	function() vim.diagnostic.jump({ count = 1, float = true }) end,
	{ desc = "Go to next diagnostic message" }
)
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

-- Tmux keymaps
vim.keymap.set("n", "T", "<cmd>silent !tmux split -p 25 -c %:p:h<CR>")

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })


vim.keymap.set("n", "<leader>gg", function()
	require("lazy.util").float_term({ "lazygit" }, {
		cwd = vim.fn.expand("%:p:h"),
		terminal = true,
		close_on_exit = true,
		enter = true,
		float = {
			size = { width = 0.9, height = 0.9 },
			margin = { top = 0, right = 0, bottom = 0, left = 0 },
		},
	})
end, { desc = "LazyGit" })
