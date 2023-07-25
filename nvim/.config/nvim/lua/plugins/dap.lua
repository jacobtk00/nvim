local M = {
	"mfussenegger/nvim-dap",

	dependencies = {
		{
			"rcarriga/nvim-dap-ui",

			config = function()
				require("dapui").setup()
			end,
		},
		{ "jbyuki/one-small-step-for-vimkind" },
		{ "mxsdev/nvim-dap-vscode-js" },
		{ "theHamsta/nvim-dap-virtual-text" },
		{
			"microsoft/vscode-js-debug",
			lazy = true,
			event = "VeryLazy",
			build = "npm install --legacy-peer-deps && npm run compile",
			version = "v1.*",
		},
	},
}

function M.init()
	vim.keymap.set("n", "<leader>db", function()
		require("dap").toggle_breakpoint()
	end, { desc = "Toggle Breakpoint" })

	vim.keymap.set("n", "<leader>dc", function()
		require("dap").continue()
	end, { desc = "Continue" })

	vim.keymap.set("n", "<leader>do", function()
		require("dap").step_over()
	end, { desc = "Step Over" })

	vim.keymap.set("n", "<leader>di", function()
		require("dap").step_into()
	end, { desc = "Step Into" })

	vim.keymap.set("n", "<leader>dw", function()
		require("dap.ui.widgets").hover()
	end, { desc = "Widgets" })

	vim.keymap.set("n", "<leader>dr", function()
		require("dap").repl.open()
	end, { desc = "Repl" })

	vim.keymap.set("n", "<leader>du", function()
		require("dapui").toggle({})
	end, { desc = "Dap UI" })

	vim.keymap.set("n", "<leader>ds", function()
		require("dap").terminate()
	end, { desc = "Stop DAP" })

	-- vim.keymap.set("n", "<leader>ds", function()
	-- 	require("osv").launch({ port = 8086 })
	-- end, { desc = "Launch Lua Debugger Server" })
	--
	-- vim.keymap.set("n", "<leader>dd", function()
	-- 	require("osv").run_this()
	-- end, { desc = "Launch Lua Debugger" })
end

function M.config()
	local dap = require("dap")

	require("nvim-dap-virtual-text").setup({})
	require("dap-vscode-js").setup({
		debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
		debugger_cmd = { "js-debug-adapter" },
		node_path = "node",
		adapters = {
			"pwa-node",
			"pwa-chrome", --[[ "node-terminal" ]]
		},
	})
	local js = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"node2",
	}
	for _, lang in ipairs(js) do
		dap.configurations[lang] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-chrome",
				request = "launch",
				name = "Launch Chrome",
			},
			-- Vitest
			-- {
			-- 	type = "pwa-node",
			-- 	request = "launch",
			-- 	name = "Launch Test Program (pwa-node with vitest)",
			-- 	cwd = vim.fn.getcwd(),
			-- 	program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
			-- 	args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
			-- 	autoAttachChildProcesses = true,
			-- 	smartStep = true,
			-- 	console = "integratedTerminal",
			-- 	skipFiles = { "<node_internals>/**", "node_modules/**" },
			-- },
		}
	end

	-- Golang
	dap.adapters.delve = {
		type = "server",
		port = "${port}",
		executable = {
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}" },
		},
	}
	dap.configurations.go = {
		{
			type = "delve",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "delve",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		-- works with go.mod packages and sub packages
		{
			type = "delve",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}
end

return M
