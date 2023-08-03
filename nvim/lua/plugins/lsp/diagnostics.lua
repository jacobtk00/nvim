local M = {}

M.signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

function M.setup()
	-- Automatically update diagnostics
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		virtual_text = { spacing = 4, prefix = "●" },
		severity_sort = true,
		signs = true,
		float = {
			border = "single",
		},
	})

	for type, icon in pairs(M.signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

return M

-- • {contents}  (table) of lines to show in window
-- • {syntax}    (string) of syntax to set for opened buffer
-- • {opts}      (table) with optional fields (additional keys are passed
--               on to |nvim_open_win()|)
--               • height: (integer) height of floating window
--               • width: (integer) width of floating window
--               • wrap: (boolean, default true) wrap long lines
--               • wrap_at: (integer) character to wrap at for computing
--                 height when wrap is enabled
--               • max_width: (integer) maximal width of floating window
--               • max_height: (integer) maximal height of floating window
--               • pad_top: (integer) number of lines to pad contents at
--                 top
--               • pad_bottom: (integer) number of lines to pad contents at
--                 bottom
--               • focus_id: (string) if a popup with this id is opened,
--                 then focus it
--               • close_events: (table) list of events that closes the
--                 floating window
--               • focusable: (boolean, default true) Make float focusable
--               • focus: (boolean, default true) If `true`, and if
--                 {focusable} is also `true`, focus an existing floating
--                 window with the same {focus_id}
