local tests = {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet"
	}
}

tests.config = function()
	local neotest = require("neotest")
	neotest.setup({
		adapters = {
			require("neotest-dotnet")
		}
	})
end

tests.keys = {
	{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run Test File" },
	{ "<leader>tr", function() require("neotest").run.run() end,                     desc = "Run nearest test" },
	{ "<leader>ts", function() require("neotest").run.stop() end,                    desc = "Stop test" },
	{ "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
}

return tests
