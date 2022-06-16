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

local function _buffer_project_files(all)
  local project_path = _get_buffer_project_path(false)
  if project_path then
    if all then
      require('telescope.builtin').find_files(
        {cwd = project_path})
    else
      require('telescope.builtin').find_files({
        find_command = {'rg', '--no-ignore', '--files'},
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

local function _live_grep(dir, path_display)
  require('telescope.builtin').live_grep({
    layout_strategy = 'vertical',
    search_dirs = {dir},
    path_display = path_display,
    use_regex = true,
  })
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

return setmetatable({}, {
  __index = function(_, k)
    if M[k] then
      return M[k]
    else
      return require('telescope.builtin')[k]
    end
  end
})
