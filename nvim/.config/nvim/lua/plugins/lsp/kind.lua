local M = {}

M.icons = {
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Enum = "了 ",
	EnumMember = " ",
	Field = " ",
	File = " ",
	Folder = " ",
	Function = " ",
	Interface = "ﰮ ",
	Keyword = " ",
	Method = "ƒ ",

	Property = " ",
	Snippet = "﬌ ",
	Struct = " ",
	Text = " ",
	Unit = " ",
	Value = " ",
	Variable = " ",
}

local MAX_WIDTH = 20

local function trim_string(s)
	if s:len() > MAX_WIDTH then
		return string.sub(s, 1, MAX_WIDTH - 3) .. "…"
	end
	return s
end

function M.cmp_format()
	-- @_entry: cmp.Entry
	-- @vim_item: vim.CompletedItem
	return function(_entry, vim_item)
		if M.icons[vim_item.kind] then
			vim_item.kind = M.icons[vim_item.kind] .. vim_item.kind
		end
		vim_item.max_width = 25
		vim_item.abbr = trim_string(vim_item.abbr)
		vim_item.menu = ""
		-- vim_item.menu = vim_item.menu
		-- vim_item.fields = { "abbr" }
		return vim_item
	end
end

return M
