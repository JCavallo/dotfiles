local M = {}

function M.tryton_module_path()
	return require("lspconfig.util").root_pattern("tryton.cfg")(vim.fn.expand("%:p"))
end

function M.must_auto_format(path)
	local autoformat_patterns = os.getenv("AUTOFORMAT_PATTERNS")

	if not autoformat_patterns then
		return true
	end
	local patterns = {}
	for pattern in string.gmatch(autoformat_patterns, "[^;]+") do
		table.insert(patterns, pattern)
	end
	for _, pattern in ipairs(patterns) do
		if string.match(path, pattern) then
			return true
		end
	end
	return false
end

function M.copy_current_location()
	local ts = vim.treesitter
	local module_name = vim.fn.fnamemodify(M.tryton_module_path(), ":t")
	local file_name = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:t")
	local class_name =
		ts.get_node_text(M.ts_parent_from_node(ts.get_node(), "class_definition"):child(1), vim.fn.bufnr())
	local contents = module_name .. "/" .. file_name .. "@" .. class_name
	local current_func = M.ts_parent_from_node(ts.get_node(), "function_definition")
	if current_func ~= nil then
		contents = contents .. "::" .. ts.get_node_text(current_func:child(1), vim.fn.bufnr())
	end
	vim.fn.setreg("+", contents)
	print('Copied "' .. contents .. '"')
end

function M.ts_parent_from_node(base_node, target_type)
	if not base_node then
		return nil
	end

	local expr = base_node
	while expr do
		if expr:type() == target_type then
			break
		end
		expr = expr:parent()
	end
	return expr
end

function M.ts_find_siblings(parent_type, target_types)
	local ts_utils = vim.treesitter
	local results = {}

	local current_node = ts_utils.get_node()
	local parent_node = M.ts_parent_from_node(current_node, parent_type)
	if parent_node == nil then
		return
	end

	local function extract_nodes(node, elem, result)
		if type(elem) == "table" then
			for base, sub_targets in pairs(elem) do
				if type(base) == "number" and type(sub_targets) == "string" then
					if node:type() == sub_targets then
						table.insert(result, { node = node })
					end
				elseif type(base) == "number" and type(sub_targets) == "table" then
					extract_nodes(node, sub_targets, result)
				elseif type(base) == "string" and node:type() == base then
					for child in node:iter_children() do
						extract_nodes(child, sub_targets, result)
					end
				end
			end
		else
			if node:type() == elem then
				table.insert(result, { node = node })
			end
		end
	end

	local targets = {}
	targets[parent_type] = target_types
	extract_nodes(parent_node, targets, results)

	if vim.tbl_isempty(results) then
		return
	end
	return results
end

function M.ts_tryton_current_function()
	local vts = vim.treesitter
	local parent_node = M.ts_parent_from_node(vts.get_node(), "function_definition")
	if parent_node == nil then
		return
	end
	return vts.get_node_text(parent_node:child(1), vim.fn.bufnr())
end

function M.ts_tryton_current_model()
	local vts = vim.treesitter
	local parent_node = M.ts_parent_from_node(vts.get_node(), "class_definition")
	if parent_node == nil then
		return
	end
	local query = vim.treesitter.query.parse(
		"python",
		[[ (assignment
        left: ((identifier) @variable.builtin
          (#eq? @variable.builtin "__name__"))
        right: ((string
          (string_start)
          (string_content) @var
          (string_end)))) ]]
	)
	local bufnr = vim.fn.bufnr()
	for capture, match, _ in query:iter_captures(parent_node, bufnr, 0, -1) do
		if capture == 2 then
			return vts.get_node_text(match, bufnr)
		end
	end
end

return setmetatable({}, {
	__index = function(_, k)
		if M[k] then
			return M[k]
		end
	end,
})
