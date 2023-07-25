local M = {}

local function buf_command(bufnr, name, fn, opts)
	vim.api.nvim_buf_create_user_command(bufnr, name, fn, opts or {})
end

function M.setup(_, buffer)
	buf_command(buffer, "LspHover", vim.lsp.buf.hover)
	buf_command(buffer, "LspDiagPrev", vim.diagnostic.goto_prev)
	buf_command(buffer, "LspDiagNext", vim.diagnostic.goto_next)
	buf_command(buffer, "LspDiagLine", vim.diagnostic.open_float)
	buf_command(buffer, "LspDiagQuickfix", vim.diagnostic.setqflist)
	buf_command(buffer, "LspSignatureHelp", vim.lsp.buf.signature_help)
	buf_command(buffer, "LspTypeDef", vim.lsp.buf.type_definition)
	buf_command(buffer, "LspAct", function()
		vim.lsp.buf.code_action()
	end)
	buf_command(buffer, "LspRename", function()
		vim.lsp.buf.rename()
	end)

	-- telescope
	buf_command(buffer, "LspRef", "Telescope lsp_references")
	buf_command(buffer, "LspSym", "Telescope lsp_workspace_symbols")
	buf_command(buffer, "LspDef", "Telescope lsp_definitions")
end

return M
