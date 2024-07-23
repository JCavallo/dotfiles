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


local _get_tryton_name = function (current)
  print(current)
  if current == true then
    return require('jc.utils').ts_tryton_current_model()
  else
    vim.cmd([[normal "jyi']])
    return vim.fn.getreg('j')
  end
end

function M.tryton_model_project_grep(opts)
  local name = _get_tryton_name(opts.current)
  _live_grep(_get_buffer_project_path(true), 'shorten',
    "__name__ = '" .. name .. "'")
end

function M.tryton_model_directory_grep(opts)
  local name = _get_tryton_name(opts.current)
  _live_grep(vim.fn.getcwd(), 'full',
    "__name__ = '" .. name .. "'")
end

function M.tryton_model_git_grep(opts)
  local name = _get_tryton_name(opts.current)
  _live_grep(_get_buffer_git_path(), 'full',
    "__name__ = '" .. name .. "'")
end

function M.tryton_model_module_grep(opts)
  local name = _get_tryton_name(opts.current)
  _live_grep(_get_tryton_module_path(), 'full',
    "__name__ = '" .. name .. "'")
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

function M.treesitter_siblings(opts)
  local pickers = require("telescope.pickers")
  local conf = require('telescope.config').values
  local finders = require("telescope.finders")
  local utils = require('jc.utils')
  local results = utils.ts_find_siblings(opts.parent, opts.targets)
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
