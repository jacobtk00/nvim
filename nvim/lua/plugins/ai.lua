local M = {

	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				mux = {
					backend = "tmux",
					enabled = false,
				},
			},
		},
		cmd = "Sidekick",
		keys = {
			-- {
			-- 	"<tab>",
			-- 	function()
			-- 		-- if there is a next edit, jump to it, otherwise apply it if any
			-- 		if not require("sidekick").next_jump_or_apply() then
			-- 			return "<Tab>" -- fallback to normal tab
			-- 		end
			-- 	end,
			-- 	expr = true,
			-- 	desc = "Goto/Apply Next Edit Suggestion",
			-- },
			{
				"<c-.>",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
				remap = true,
			},
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function() require("sidekick.cli").select() end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function() require("sidekick.cli").close() end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function() require("sidekick.cli").send({ msg = "{this}" }) end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function() require("sidekick.cli").send({ msg = "{file}" }) end,
				desc = "Send File",
			},
			{
				"<c-.>",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<esc>",
				"stopinsert",
				mode = { "t" },
				desc = "Sidekick Select Prompt",
			},
			-- Example of a keybinding to open Claude directly
			-- {
			-- 	"<leader>ac",
			-- 	function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
			-- 	desc = "Sidekick Toggle Claude",
			-- },
		},
	},
	{
		-- in case auth isnt working here is a way to manually set up access token:
		-- 1. initiate device code flow:
		-- curl -s https://github.com/login/device/code -X POST -d "client_id=Iv1.b507a08c87ecfe98&scope=read:user"
		-- 3. go to github.com/login/device and enter the user_code to authorize
		-- 2. get access token (replace DEVICE_CODE with the code received in step 1):
		-- curl -s https://github.com/login/oauth/access_token -X POST -d "client_id=Iv1.b507a08c87ecfe98&device_code=YOUR_DEVICE_CODE&grant_type=urn:ietf:params:oauth:grant-type:device_code" | grep -o "access_token=[^&]*" | cut -d= -f2
		-- edit the ~/.config/github-copilot/hosts.json file to include the access token:
		-- {
		--  "github.com": {
		--  "user": "your_github_username",
		--  "oauth_token": "your_access_token"
		--  }
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		-- event = "BufReadPost",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-h>" } },
			-- copilot_model = "gpt-52",
		}
	},
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	branch = "main",
	-- 	event = "BufRead",
	-- 	dependencies = {
	-- 		{ "zbirenbaum/copilot.lua" },
	-- 		{ "nvim-lua/plenary.nvim" },
	-- 	},
	-- 	keys = {
	-- 		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
	-- 	},
	-- 	opts = {},
	-- }
}

return M
