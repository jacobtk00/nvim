return {
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },

	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "wintermute-cell/gitignore.nvim" },
		-- { "danielfalk/smart-open.nvim" },
		-- { "tami5/sqlite.lua" },
	},
	keys = {
		{ "<leader>F", "<cmd>Telescope find_files<cr>", desc = "Find File" },
		{ "<leader>gi", "<cmd>Gitignore<cr>", desc = "Generate .gitignore" },
	},
	config = function()
		-- local actions = require("telescope.actions")
		local telescope = require("telescope")
		telescope.load_extension("fzf")
		local troubleProvider, err = require("trouble.providers.telescope")
		if err then
		else
			telescope.setup({
				defaults = {
					mappings = {
						i = { ["<c-q>"] = troubleProvider.open_with_trouble },
						n = { ["<c-q>"] = troubleProvider.open_with_trouble },
					},
				},
			})
		end
		-- telescope.setup({
		--   mappings = {
		--       i = { ["<C-q>"] =
		-- })
		-- telescope.load_extension("smart_open")
	end,
}
