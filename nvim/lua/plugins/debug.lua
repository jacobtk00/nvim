local debug = {
	'mfussenegger/nvim-dap',
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',
		-- 'NicholasMata/nvim-dap-cs',
	}
}

debug.config = function()
	local dap = require('dap')
	local dap_utils = require('dap.utils')
	dap.configurations.cs = {
		{
			type = "coreclr",
			name = "Launch",
			request = "launch",
			program = function()
				local current_working_dir = vim.fn.getcwd()
				return require('util.dapcsutil').select_dll(current_working_dir) or dap.ABORT
			end,
		},
		{
			type = "coreclr",
			name = "Attach",
			request = "attach",
			processId = dap_utils.pick_process,
		},
	}
	dap.adapters.coreclr = {
		type = 'executable',
		command = "netcoredbg",
		args = { '--interpreter=vscode' }
	}
	dap.adapters.netcoredbg = {
		type = 'executable',
		command = "netcoredbg",
		args = { '--interpreter=vscode' }
	}

	local dapui = require('dapui')
	dapui.setup()

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	-- dap.listeners.before.event_terminated["dapui_config"] = function()
	-- 	dapui.close()
	-- end
	-- dap.listeners.before.event_exited["dapui_config"] = function()
	-- 	dapui.close()
	-- end
end

debug.keys = {
	{ '<leader>dc', function() require("dap").continue() end,                                                    desc = 'Continue' },
	{ '<leader>do', function() require("dap").step_over() end,                                                   desc = 'Step Over' },
	{ '<leader>di', function() require("dap").step_into() end,                                                   desc = 'Step Into' },
	{ '<leader>do', function() require("dap").step_out() end,                                                    desc = 'Step Out' },
	{ '<leader>db', function() require("dap").toggle_breakpoint() end,                                           desc = 'Toggle Breakpoint' },
	{ '<leader>dB', function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,        desc = 'Set Breakpoint' },
	{ '<leader>lp', function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = 'Log Point' },
	{ '<leader>dr', function() require("dap").repl.open() end,                                                   desc = 'Open REPL' },
	{ '<leader>dl', function() require("dap").run_last() end,                                                    desc = 'Run Last' },
	{ '<leader>ds', function() require("dap").terminate() end,                                                   desc = "Terminate" },
	{ '<leader>du', function() require("dapui").toggle() end,                                                    desc = "Dap UI" },
}

return debug
-- 			local dir = vim.loop.cwd() .. '/' .. vim.fn.glob 'bin/Debug/net*/linux-x64/'
-- 			local name = dir .. vim.fn.glob('*.csproj'):gsub('%.csproj$', '.dll')
-- 			if not vim.fn.exists(name) then os.execute 'dotnet build -r linux-x64' end
-- 			return name
-- dap.adapters.coreclr = {
-- 	type = 'executable',
-- 	command = '/usr/local/bin/netcoredbg/netcoredbg',
-- 	args = { '--interpreter=vscode' }
-- }
-- dap.configurations.cs = {
-- 	{
-- 		type = "coreclr",
-- 		name = "launch - netcoredbg",
-- 		request = "launch",
-- 		env = "ASPNETCORE_ENVIRONMENT=Development",
-- 		args = {
-- 			"/p:EnvironmentName=Development",
-- 			"--urls=http://localhost:5002",
-- 			"--environment=Development",
-- 		},
-- 		program = function()
-- 			local dir = vim.loop.cwd() .. '/' .. vim.fn.glob 'bin/Debug/net*/linux-x64/'
-- 			local name = dir .. vim.fn.glob('*.csproj'):gsub('%.csproj$', '.dll')
-- 			if not vim.fn.exists(name) then os.execute 'dotnet build -r linux-x64' end
-- 			return name
-- 		end,
-- 	},
-- }
