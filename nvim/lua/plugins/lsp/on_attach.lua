local on_attach = function(client, buffer)
	-- local cap = client.server_capabilities
	-- client.server_capabilities.semanticTokensProvider = nil
	-- if client.name == "gopls" then
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover, {
			border = 'single'
		}
	)
	local keymaps = {
		{ "<C-k>",       "<cmd>lua vim.lsp.buf.signature_help()<CR>",                                           desc = "Signature Help",       mode = "i" },
		{ "<leader>a",   group = "Code Action" },
		{ "<leader>ac",  vim.lsp.buf.code_action,                                                               desc = "Code Action" },
		{ "<leader>c",   group = "code" },
		{ "<leader>cd",  vim.diagnostic.open_float,                                                             desc = "Line Diagnostics" },
		{ "<leader>cl",  group = "lsp" },
		{ "<leader>cla", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",                                     desc = "Add Folder" },
		{ "<leader>cli", "<cmd>LspInfo<cr>",                                                                    desc = "Lsp Info" },
		{ "<leader>cll", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",               desc = "List Folders" },
		{ "<leader>clr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",                                  desc = "Remove Folder" },
		{ "<leader>r",   "<cmd>lua vim.lsp.buf.rename()<CR>",                                                   desc = "Rename" },
		{ "<leader>xd",  "<cmd>Telescope diagnostics<cr>",                                                      desc = "Telescope Diagnostics" },
		{ "K",           "<cmd>lua vim.lsp.buf.hover()<CR>",                                                    desc = "Hover" },
		{ "[d",          "<cmd>lua vim.diagnostic.goto_prev()<CR>",                                             desc = "Next Diagnostic" },
		{ "[e",          "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>",   desc = "Next Error" },
		{ "[w",          "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<CR>", desc = "Next Warning" },
		{ "]d",          "<cmd>lua vim.diagnostic.goto_next()<CR>",                                             desc = "Prev Diagnostic" },
		{ "]e",          "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>",   desc = "Prev Error" },
		{ "]w",          "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<CR>", desc = "Prev Warning" },
		{ "g",           group = "goto" },
		{ "gD",          "<cmd>Telescope lsp_declarations<CR>",                                                 desc = "Goto Declaration" },
		{ "gI",          "<cmd>Telescope lsp_implementations<CR>",                                              desc = "Goto Implementation" },
		{ "gR",          "<cmd>Trouble lsp_references<cr>",                                                     desc = "Trouble References" },
		{ "gd",          "<cmd>Telescope lsp_definitions<cr>",                                                  desc = "Goto Definition" },
		{ "gi",          "<cmd>lua vim.lsp.buf.implementation()<CR>",                                           desc = "Goto Implementation" },
		{ "gr",          "<cmd>Telescope lsp_references<cr>",                                                   desc = "References" },
		{ "gt",          "<cmd>Telescope lsp_type_definitions<cr>",                                             desc = "Goto Type Definition" },
	}

	local is_lsp_buf = function()
		return vim.api.nvim_get_current_buf() == buffer
	end
	for _, keymap in ipairs(keymaps) do
		keymap.cond = is_lsp_buf
	end

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(buffer, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })


	require("which-key").add(keymaps)
end

return on_attach
