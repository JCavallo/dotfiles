local M = {}

function M.builtin()
  require('telescope.builtin').builtin()
end

function M.quickfix()
  require('telescope.builtin').quickfix({
    layout_strategy = 'vertical',
  })
end

function M.find_all_files()
  require('telescope.builtin').find_files {
    find_command = { 'rg', '--no-ignore', '--files', },
  }
end

local function _files_current_buffer(all)
  if all then
    require('telescope.builtin').find_files({
      find_command = { 'rg', '--no-ignore', '--files', },
      cwd = vim.fn.expand('%:p:h'),
    })
  else
    require('telescope.builtin').find_files({
      cwd = vim.fn.expand('%:p:h'),
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
  require('telescope.builtin').git_files(
    {cwd = vim.fn.expand('%:p:h')})
end

local function _get_buffer_git_path()
  return require('lspconfig.util').root_pattern('.git')(vim.fn.expand('%:p'))
end

local function _get_tryton_module_path()
  return require('lspconfig.util').root_pattern('tryton.cfg')(vim.fn.expand('%:p'))
end

local function _get_buffer_project_path(gitfallback)
  local project_path = os.getenv('PROJECT_PATH')
  if not project_path then
    project_path = require('lspconfig.util').root_pattern(
      '.project')(vim.fn.expand('%:p'))
  end
  if not project_path and gitfallback then
    project_path = _get_buffer_git_path()
  end
  return project_path
end

local function _buffer_project_files(include_all)
  local project_path = _get_buffer_project_path(false)
  if project_path then
    if include_all then
      require('telescope.builtin').find_files({
        find_command = {'rg', '--no-ignore', '--files'},
        cwd = project_path})
    else
      require('telescope.builtin').find_files({
        find_command = {'rg', '--files'},
        cwd = project_path})
    end
  else
    require('telescope.builtin').git_files(
      {cwd = vim.fn.expand('%:p')})
  end
end

function M.buffer_project_all_files()
  _buffer_project_files(true)
end

function M.buffer_project_files()
  _buffer_project_files(false)
end

function M.buffer_tryton_module_files()
  require('telescope.builtin').find_files(
    {cwd = _get_tryton_module_path()})
end

local function _live_grep(dir, path_display, default)
  local config = {
      layout_strategy = 'vertical',
      search_dirs = {dir},
      path_display = path_display,
      use_regex = true,
    }
  if default ~= nil then
    config.default_text = default
  end
  require('telescope.builtin').live_grep(config)
end

function M.live_buffer_grep()
  _live_grep(vim.fn.expand('%:p:h'), 'tail')
end

function M.live_project_grep()
  _live_grep(_get_buffer_project_path(true), 'shorten')
end

function M.live_directory_grep()
  _live_grep(vim.fn.getcwd())
end

function M.live_git_grep()
  _live_grep(_get_buffer_git_path())
end

function M.live_tryton_module_grep()
  _live_grep(_get_tryton_module_path())
end

function M.buffer_grep()
  _live_grep(vim.fn.expand('%:p'))
end

local function _grep_string(dir, path_display)
  require('telescope.builtin').grep_string({
    layout_strategy = 'vertical',
    search_dirs = {dir},
    path_display = path_display,
    use_regex = true,
  })
end

function M.buffer_search()
  _grep_string(vim.fn.expand('%:p:h'))
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
  _grep_string(_get_tryton_module_path())
end

function M.tryton_model_project_grep()
  vim.cmd([[normal "jyi']])
  _live_grep(_get_buffer_project_path(true), 'shorten',
    "__name__ = '" .. vim.fn.getreg('j') .. "'")
end

function M.tryton_model_directory_grep()
  vim.cmd([[normal "jyi']])
  _live_grep(vim.fn.getcwd(), 'full',
    "__name__ = '" .. vim.fn.getreg('j') .. "'")
end

function M.tryton_model_git_grep()
  vim.cmd([[normal "jyi']])
  _live_grep(_get_buffer_git_path(), 'full',
    "__name__ = '" .. vim.fn.getreg('j') .. "'")
end

function M.tryton_model_module_grep()
  vim.cmd([[normal "jyi']])
  _live_grep(_get_tryton_module_path(), 'full',
    "__name__ = '" .. vim.fn.getreg('j') .. "'")
end

function M.tryton_field_project_grep()
  vim.cmd([[normal "jyiw]])
  _live_grep(_get_buffer_project_path(true), 'shorten',
    " " .. vim.fn.getreg('j') .. " = fields.")
end

function M.tryton_field_directory_grep()
  vim.cmd([[normal "jyiw]])
  _live_grep(vim.fn.getcwd(), 'full',
    " " .. vim.fn.getreg('j') .. " = fields.")
end

function M.tryton_field_git_grep()
  vim.cmd([[normal "jyiw]])
  _live_grep(_get_buffer_git_path(), 'full',
    " " .. vim.fn.getreg('j') .. " = fields.")
end

function M.tryton_field_module_grep()
  vim.cmd([[normal "jyiw]])
  _live_grep(_get_tryton_module_path(), 'full',
    " " .. vim.fn.getreg('j') .. " = fields.")
end

function M.force_refresh_treesitter(options)
  options.bufnr = vim.fn.bufnr()
  require('telescope.builtin').treesitter(options)
end

----------------------
-- Sibling searcher --
----------------------

_find_siblings = function (opts)
  local ts_utils = require'nvim-treesitter.ts_utils'
  local results = {}

  local get_parent_from_node = function (base_node, target_type)
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

  local current_node = ts_utils.get_node_at_cursor()
  local parent_type = opts.parent
  local target_types = opts.targets
  local parent_node = get_parent_from_node(current_node, parent_type)
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

function M.treesitter_siblings(opts)
  local pickers = require("telescope.pickers")
  local conf = require('telescope.config').values
  local finders = require("telescope.finders")
  local results = _find_siblings(opts)
  if results == nil then
    return
  end
  -- return result
  opts.symbol_width = 200
  opts.show_line = false
  pickers.new(opts, {
      prompt_title = "Siblings",
      finder = finders.new_table {
          results = results,
          entry_maker = opts.entry_maker or
            require('telescope.make_entry').gen_from_treesitter(opts),
      },
      sorter = conf.generic_sorter(opts),
      previewer = conf.grep_previewer(opts),
  })
  :find()
end

return setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})
