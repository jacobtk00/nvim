local M = {}

local number_indices = function(array)
	local result = {}
	for i, value in ipairs(array) do
		result[i] = i .. ": " .. value
	end
	return result
end

local display_options = function(prompt_title, options)
	options = number_indices(options)
	table.insert(options, 1, prompt_title)

	local choice = vim.fn.inputlist(options)

	if choice > 0 then
		return options[choice + 1]
	else
		return nil
	end
end

local file_selection = function(cmd, opts)
	local results = vim.fn.systemlist(cmd)

	if #results == 0 then
		print(opts.empty_message)
		return
	end

	if opts.allow_multiple then
		return results
	end

	local result = results[1]
	if #results > 1 then
		result = display_options(opts.multiple_title_message, results)
	end

	return result
end

local project_selection = function(project_path, allow_multiple)
	local check_csproj_cmd = string.format('find %s -type f -name "*.csproj"', project_path)
	local project_file = file_selection(check_csproj_cmd, {
		empty_message = 'No csproj files found in ' .. project_path,
		multiple_title_message = 'Select project:',
		allow_multiple = allow_multiple
	})
	return project_file
end

M.select_dll = function(project_path)
	local bin_path = project_path .. '/bin'

	local check_net_folders_cmd = string.format('find %s -type d -name "net*"', bin_path)
	local net_bin = file_selection(check_net_folders_cmd, {
		empty_message = 'No dotnet directories found in the "bin" directory. Ensure project has been built.',
		multiple_title_message = "Select NET Version:"
	})
	if net_bin == nil then
		return
	end

	local project_file = project_selection(project_path)
	if project_file == nil then
		return
	end
	local project_name = vim.fn.fnamemodify(project_file, ":t:r")

	local dll_path = net_bin .. '/' .. project_name .. '.dll'
	return dll_path
end

return M
