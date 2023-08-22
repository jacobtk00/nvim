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

local keymap_restore = {}
local dap_maps = {
	{
		key = "K",
		cmd = "<Cmd>lua require('dap.ui.widgets').hover()<CR>",
		desc = "Hover",
	},
	{
		key = "db",
		cmd = "<cmd>lua require('dap').toggle_breakpoint()<cr>",
		desc = "Toggle Breakpoint",
	},
	{
		key = "dc",
		cmd = "<cmd>lua require('dap').continue()<cr>",
		desc = "Continue",
	},
	{
		key = "do",
		cmd = "<cmd>lua require('dap').step_over()<cr>",
		desc = "Step Over",
	},
	{
		key = "di",
		cmd = "<cmd>lua require('dap').step_into()<cr>",
		desc = "Step Into",
	},
	{
		key = "dw",
		cmd = "<cmd>lua require('dap.ui.widgets').hover()<cr>",
		desc = "Widgets",
	},
	{
		key = "dr",
		cmd = "<cmd>lua require('dap').repl.open()<cr>",
		desc = "Repl",
	},
	{
		key = "du",
		cmd = "<cmd>lua require('dapui').toggle({})<cr>",
		desc = "Dap UI",
	},
	{
		key = "ds",
		cmd = "<cmd>lua require('dap').terminate()<cr>",
		desc = "Stop DAP",
	},
}

function In_DapMap(key)
	for _, map in pairs(dap_maps) do
		if map.key == key then
			return true
		end
	end
	return false
end

function Setup_Keymaps()
	for _, buf in pairs(vim.api.nvim_list_bufs()) do
		local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
		for _, keymap in pairs(keymaps) do
			if In_DapMap(keymap.lhs) then
				table.insert(keymap_restore, keymap)
				vim.api.nvim_buf_del_keymap(buf, "n", keymap.lhs)
			end
		end
	end
	local function key(lhs, rhs, desc)
		vim.api.nvim_set_keymap("n", lhs, rhs, { desc = desc, silent = true })
	end

	for _, map in pairs(dap_maps) do
		key(map.key, map.cmd, map.desc)
	end
end

function Restore_Keymaps()
	print("Restoring keymaps")
	for _, keymap in pairs(keymap_restore) do
		vim.api.nvim_set_keymap(keymap.mode, keymap.lhs, keymap.rhs, {
			silent = keymap.silent == 1,
		})
	end
	keymap_restore = {}
end

function M.config()
	local dap = require("dap")
	dap.defaults.fallback.terminal_win_cmd = "tabnew"

	dap.listeners.after["event_initialized"]["keymaps"] = function()
		print("End debug session. Restoring keymaps")
		Setup_Keymaps()
	end

	dap.listeners.after["event_terminated"]["keymaps"] = function()
		print("End debug session. Restoring keymaps")
		Restore_Keymaps()
	end

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
