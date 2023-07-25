local M = {
	"nvim-neotest/neotest",
	dependencies = {
		"antoinemadec/FixCursorHold.nvim",
		"haydenmeade/neotest-jest",
		"nvim-neotest/neotest-go",
	},
	lazy = false,
}

function M.init()
	vim.keymap.set("n", "<leader>tr", function()
		require("neotest").run.run()
	end, { desc = "Test Function" })

	vim.keymap.set("n", "<leader>tp", function()
		require("neotest").run.run(vim.fn.getcwd())
	end, { desc = "Test Project" })

	vim.keymap.set("n", "<leader>tf", function()
		require("neotest").run.run(vim.fn.expand("%"))
	end, { desc = "Test File" })

	vim.keymap.set("n", "<leader>to", function()
		require("neotest").output_panel.toggle()
	end, { desc = "Output Panel" })

	vim.keymap.set("n", "<leader>ts", function()
		require("neotest").summary.toggle()
	end, { desc = "Test Summary" })

	vim.keymap.set("n", "<leader>tk", function()
		require("neotest").run.stop()
		vim.diagnostic.reset()
	end, { desc = "Kill Tests" })

	-- Check race condition EX
	-- vim.keymap.set("n", "<leader>tg", function()
	-- 	require("neotest").run.run({ vim.fn.getcwd(), extra_args = { "-race" } })
	-- end)
end

function M.config()
	-- For some reason i need this ?????
	-- get neotest namespace (api call creates or returns namespace)
	local neotest_ns = vim.api.nvim_create_namespace("neotest")
	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				return message
			end,
		},
	}, neotest_ns)

	require("neotest").setup({
		adapters = {
			-- require("neotest-jest")({
			-- 	jestCommand = "npm test --",
			-- 	jestConfigFile = "custom.jest.config.ts",
			-- 	env = { CI = true },
			-- 	cwd = function(path)
			-- 		return vim.fn.getcwd()
			-- 	end,
			-- }),
			require("neotest-go")({
				experimental = {
					test_table = true,
				},
				args = { "-count=1", "-timeout=60s" },
			}),
		},
		summary = {
			mappings = {
				attach = "a",
				expand = { "<CR>", "<2-LeftMouse>" },
				expand_all = "e",
				jumpto = "i",
				output = "o",
				run = "r",
				short = "O",
				stop = "s",
			},
			diagnostic = { enabled = true },
		},
		-- icons = {
		-- 	expanded = "",
		-- 	child_prefix = "",
		-- 	child_indent = "",
		-- 	final_child_prefix = "",
		-- 	non_collapsible = "",
		-- 	collapsed = "",
		--
		-- 	passed = "",
		-- 	running = "",
		-- 	failed = "",
		-- 	unknown = "",
		-- 	skipped = "",
		-- },
		-- summary = {
		-- 	mappings = {
		-- 		attach = "a",
		-- 		expand = { "<CR>", "<2-LeftMouse>" },
		-- 		expand_all = "e",
		-- 		jumpto = "i",
		-- 		output = "o",
		-- 		run = "r",
		-- 		short = "O",
		-- 		stop = "s",
		-- 	},
		-- },
		-- diagnostic = { enabled = true },
	})
end

return M
