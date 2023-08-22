local M = {
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
}

M.opts = {
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
		vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none" })
		vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { bg = "none" })
	end,
}

return M
