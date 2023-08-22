-- [[ Keymaps ]]
vim.keymap.set("n", "^", "<C-6>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true })
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<c-y>", '"*y', { silent = true })

vim.keymap.set("t", "\\", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-w>n", "<C-\\><C-n><C-w>h")


-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
