local M = {}

local jc_utils = require("jc.utils")

function M.builtin()
	require("telescope.builtin").builtin()
end

function M.quickfix()
	require("telescope.builtin").quickfix({
		layout_strategy = "vertical",
	})
end

function M.find_all_files()
	require("telescope.builtin").find_files({
		find_command = { "rg", "--no-ignore", "--files" },
	})
end

local function _files_current_buffer(all)
	if all then
		require("telescope.builtin").find_files({
			find_command = { "rg", "--no-ignore", "--files" },
			cwd = vim.fn.expand("%:p:h"),
		})
	else
		require("telescope.builtin").find_files({
			cwd = vim.fn.expand("%:p:h"),
		})
	end
end

function M.files_current_buffer_directory()
	_files_current_buffer(false)
end

function M.all_files_current_buffer_directory()
	_files_current_buffer(true)
end

function M.buffer_git_files()
	require("telescope.builtin").git_files({ cwd = vim.fn.expand("%:p:h") })
end

local function _get_buffer_git_path()
	return require("lspconfig.util").root_pattern(".git")(vim.fn.expand("%:p"))
end

local function _get_buffer_project_path(gitfallback)
	local project_path = os.getenv("PROJECT_PATH")
	if not project_path then
		project_path = require("lspconfig.util").root_pattern(".project")(vim.fn.expand("%:p"))
	end
	if not project_path and gitfallback then
		project_path = _get_buffer_git_path()
	end
	return project_path
end

local function _buffer_project_files(include_all)
	local project_path = _get_buffer_project_path(true)
	if project_path then
		if include_all then
			require("telescope.builtin").find_files({
				find_command = { "rg", "--no-ignore", "--files" },
				cwd = project_path,
			})
		else
			require("telescope.builtin").find_files({
				find_command = { "rg", "--files" },
				cwd = project_path,
			})
		end
	else
		require("telescope.builtin").git_files({ cwd = vim.fn.expand("%:p") })
	end
end

function M.buffer_project_all_files()
	_buffer_project_files(true)
end

function M.buffer_project_files()
	_buffer_project_files(false)
end

function M.buffer_tryton_module_files()
	require("telescope.builtin").find_files({ cwd = jc_utils.tryton_module_path() })
end

local function _live_grep(dir, path_display, default)
	local config = {
		layout_strategy = "vertical",
		search_dirs = { dir },
		path_display = path_display,
		use_regex = true,
	}
	if default ~= nil then
		config.default_text = default
	end
	require("telescope.builtin").live_grep(config)
end

function M.live_buffer_grep()
	_live_grep(vim.fn.expand("%:p:h"), "tail")
end

function M.live_project_grep()
	_live_grep(_get_buffer_project_path(true), "shorten")
end

function M.live_directory_grep()
	_live_grep(vim.fn.getcwd())
end

function M.live_git_grep()
	_live_grep(_get_buffer_git_path())
end

function M.live_tryton_module_grep()
	_live_grep(jc_utils.tryton_module_path())
end

function M.buffer_grep()
	_live_grep(vim.fn.expand("%:p"))
end

local function _grep_string(dir, path_display)
	require("telescope.builtin").grep_string({
		layout_strategy = "vertical",
		search_dirs = { dir },
		path_display = path_display,
		use_regex = true,
	})
end

function M.buffer_search()
	_grep_string(vim.fn.expand("%:p:h"))
end

function M.project_search()
	_grep_string(_get_buffer_project_path(true))
end

function M.directory_search()
	_grep_string(vim.fn.getcwd())
end

function M.git_search()
	_grep_string(_get_buffer_git_path())
end

function M.tryton_module_search()
	_grep_string(jc_utils.tryton_module_path())
end

local _get_tryton_name = function(current)
	if vim.bo.filetype == "xml.trxml" then
		vim.cmd([[ normal "jyit ]])
		return vim.fn.getreg("j")
	end
	if current == true then
		return jc_utils.ts_tryton_current_model()
	else
		vim.cmd([[normal "jyi"]])
		return vim.fn.getreg("j")
	end
end

local function _ast_grep_with_rule(rule, path, telescope_opts)
	local pickers = require("telescope.pickers")
	local conf = require("telescope.config").values
	local finders = require("telescope.finders")
	local data = vim.system({ "sg", "scan", "--json", "--inline-rules", rule }, { text = true, cwd = path }):wait()
	local results = {}
	for _, result in pairs(vim.json.decode(data.stdout)) do
		table.insert(
			results,
			path
				.. "/"
				.. result.file
				.. ":"
				.. result.range.start.line + 1
				.. ":"
				.. result.range.start.column
				.. ":"
				.. string.match(result.text, "^([^\r\n]*)")
		)
	end
	if results == nil then
		return
	end

	telescope_opts.symbol_width = 200
	telescope_opts.show_line = false
	pickers
		.new(telescope_opts, {
			prompt_title = telescope_opts.prompt_title or "Filter",
			finder = finders.new_table({
				results = results,
				entry_maker = telescope_opts.entry_maker
					or require("telescope.make_entry").gen_from_vimgrep(telescope_opts),
			}),
			sorter = conf.generic_sorter(telescope_opts),
			previewer = conf.grep_previewer(telescope_opts),
		})
		:find()
end

function M.tryton_function_overrides(params)
	if params == nil then
		params = {}
	end
	if params.opts == nil then
		params.opts = {}
	end
	if params.function_name == "ask" then
		params.function_name = vim.fn.input("Function Name: ")
	elseif params.function_name == "cursor" then
		params.function_name = vim.fn.expand("<cword>")
	elseif params.function_name == "current" then
		params.function_name = jc_utils.ts_tryton_current_function()
		params.model_name = "current"
	end
	if params.model_name == nil then
		local default_model = _get_tryton_name(true) or "nil"
		params.model_name = vim.fn.input("Model Name (" .. default_model .. "): ")
		if params.model_name == nil or params.model_name == "" then
			params.model_name = default_model
		end
	elseif params.model_name == "ask" then
		params.model_name = vim.fn.input("Model Name: ")
	elseif params.model_name == "cursor" then
		params.model_name = _get_tryton_name(false)
	elseif params.model_name == "current" then
		params.model_name = _get_tryton_name(true)
	elseif params.model_name == "clipboard" then
		params.model_name = vim.fn.getreg("*")
	end
	local path
	if params.path == "buffer" then
		path = vim.fn.expand("%:p:h")
	elseif params.path == "directory" then
		path = vim.fn.getcwd()
	elseif params.path == "project" or params.path == nil then
		path = _get_buffer_project_path(true)
	elseif params.path == "module" then
		path = jc_utils.tryton_module_path()
	elseif params.path == "git" then
		path = _get_buffer_git_path()
	end
	if params.opts.results_title == nil then
		local title = "Results for " .. params.model_name
		if params.function_name ~= nil then
			title = title .. "->" .. params.function_name
		end
		params.opts.results_title = title
	end
	local rule
	if params.function_name == nil then
		rule = [[
id: setup_overrides
language: Python
rule:
  kind: class_definition
  has:
    stopBy:
      kind: expression_statement
    kind: expression_statement
    has:
      any:
        - pattern: __name__ = ']] .. params.model_name .. [['
        - pattern: __name__ = "]] .. params.model_name .. '"'
	else
		rule = [[
id: setup_overrides
language: Python
rule:
  kind: function_definition
  pattern: def ]] .. params.function_name .. [[

  inside:
    stopBy:
      kind: class_definition
    kind: class_definition
    has:
      stopBy:
        kind: expression_statement
      kind: expression_statement
      has:
        any:
          - pattern: __name__ = ']] .. params.model_name .. [['
          - pattern: __name__ = "]] .. params.model_name .. '"'
	end
	return _ast_grep_with_rule(rule, path, params.opts or {})
end

function M.tryton_model_grep(opts)
	M.tryton_function_overrides({
		function_name = nil,
		model_name = opts.mode,
		path = opts.path,
		opts = { layout_strategy = "vertical" },
	})
end

function M.tryton_function_grep(opts)
	M.tryton_function_overrides({
		function_name = "current",
		model_name = nil,
		path = opts.path,
		opts = { layout_strategy = "vertical" },
	})
end

function M.tryton_field_project_grep()
	vim.cmd([[normal "jyiw]])
	_live_grep(_get_buffer_project_path(true), "shorten", " " .. vim.fn.getreg("j") .. " = fields.")
end

function M.tryton_field_directory_grep()
	vim.cmd([[normal "jyiw]])
	_live_grep(vim.fn.getcwd(), "full", " " .. vim.fn.getreg("j") .. " = fields.")
end

function M.tryton_field_git_grep()
	vim.cmd([[normal "jyiw]])
	_live_grep(_get_buffer_git_path(), "full", " " .. vim.fn.getreg("j") .. " = fields.")
end

function M.tryton_field_module_grep()
	vim.cmd([[normal "jyiw]])
	_live_grep(jc_utils.tryton_module_path(), "full", " " .. vim.fn.getreg("j") .. " = fields.")
end

function M.force_refresh_treesitter(options)
	options.bufnr = vim.fn.bufnr()
	require("telescope.builtin").treesitter(options)
end

----------------------
-- Sibling searcher --
----------------------

function M.treesitter_siblings(opts)
	local pickers = require("telescope.pickers")
	local conf = require("telescope.config").values
	local finders = require("telescope.finders")
	local results = jc_utils.ts_find_siblings(opts.parent, opts.targets)
	if results == nil then
		return
	end
	-- return result
	opts.symbol_width = 200
	opts.show_line = false
	pickers
		.new(opts, {
			prompt_title = "Siblings",
			finder = finders.new_table({
				results = results,
				entry_maker = opts.entry_maker or require("telescope.make_entry").gen_from_treesitter(opts),
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),
		})
		:find()
end

-- Credits @ https://www.petergundel.de/git/neovim/telescope/2023/03/22/git-jump-in-neovim-with-telescope.html
function M.git_hunks()
	require("telescope.pickers")
		.new({
			finder = require("telescope.finders").new_oneshot_job({ "git", "jump", "--stdout", "diff" }, {
				entry_maker = function(line)
					local filename, lnum_string = line:match("([^:]+):(%d+).*")

					-- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
					-- return nil if filename is /dev/null because this means the file was deleted.
					if filename:match("^/dev/null") then
						return nil
					end

					return {
						value = filename,
						display = line,
						ordinal = line,
						filename = filename,
						lnum = tonumber(lnum_string),
					}
				end,
			}),
			sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
			previewer = require("telescope.config").values.grep_previewer({}),
			results_title = "Git hunks",
			prompt_title = "Git hunks",
			layout_strategy = "vertical",
		}, {})
		:find()
end

return setmetatable({}, {
	__index = function(_, k)
		if M[k] then
			return M[k]
		else
			return require("telescope.builtin")[k]
		end
	end,
})
