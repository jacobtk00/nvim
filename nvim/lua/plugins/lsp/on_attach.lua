local on_attach = function(client, buffer)
	-- local cap = client.server_capabilities
	-- client.server_capabilities.semanticTokensProvider = nil
	local keymaps = {
		buffer = buffer,
		["<leader>"] = {
			r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
			a = { name = "Code Action", c = { vim.lsp.buf.code_action, "Code Action" } },
			c = {
				name = "+code",
				{
					cond = client.name == "tsserver",
					o = { "<cmd>TypescriptOrganizeImports<CR>", "Organize Imports" },
					R = { "<cmd>TypescriptRenameFile<CR>", "Rename File" },
				},
				{
					cond = client.name == "gopls",
					m = {
						name = "+Mod",
						t = { "<cmd>GoModTidy<cr>", "Mod Tidy" },
					},
				},
				d = { vim.diagnostic.open_float, "Line Diagnostics" },
				l = {
					name = "+lsp",
					i = { "<cmd>LspInfo<cr>", "Lsp Info" },
					a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder" },
					r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove Folder" },
					l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
						"List Folders" },
				},
			},
			x = { d = { "<cmd>Telescope diagnostics<cr>", "Search Diagnostics" } },
		},
		g = {
			name = "+goto",
			d = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
			r = { "<cmd>Telescope lsp_references<cr>", "References" },
			R = { "<cmd>Trouble lsp_references<cr>", "Trouble References" },
			D = { "<cmd>Telescope lsp_declarations<CR>", "Goto Declaration" },
			I = { "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation" },
			t = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
		},
		["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help", mode = { "i" } },
		["K"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
		["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Next Diagnostic" },
		["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Prev Diagnostic" },
		["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>",
			"Next Error" },
		["]e"] = { "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>",
			"Prev Error" },
		["[w"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<CR>",
			"Next Warning", },
		["]w"] = { "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<CR>",
			"Prev Warning", },
	}

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(buffer, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })


	require("which-key").register(keymaps)
end

return on_attach
