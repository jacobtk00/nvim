return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- views = {
		-- 	mini = {
		-- 		align = "message-left",
		-- 		position = {
		-- 			col = 0,
		-- 		},
		-- 	},
		-- },

		redirect = {
			view = "popup",
			filter = { event = "msg_show" },
		},
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				-- ["cmp.entry.get_documentation"] = true,
			},
		},
		messages = {
			enabled = false,
		},
		cmdline = { view = "cmdline" },
		presets = {
			bottom_search = true,
			command_palette = false,
			long_message_to_split = true,
			inc_rename = true,
			lsp_doc_border = true,
		},
		routes = {
			-- Avoid written messages
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "written",
				},
				opts = { skip = true },
			},
		},
	},

    -- stylua: ignore
   keys = {
        { "<c-\\>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<c-j>", function() if not require("noice.lsp").scroll(4) then return "<c-j>" end end, silent = true, expr = true },
      { "<c-k>", function() if not require("noice.lsp").scroll(-4) then return "<c-k>" end end, silent = true, expr = true },
    },
}
