-- Clear autocmd
vim.cmd('augroup MyAutoCmd')
vim.cmd('autocmd!')

-- Make directory automatically -> http://vim-users.jp/2011/02/hack202/
vim.cmd[[autocmd MyAutoCmd BufWritePre * call JCCreateFolderIfNecessary(expand('<afile>:p:h'), v:cmdbang)]]

-- Autoreload plugins when updating plugins.lua
vim.cmd[[autocmd MyAutoCmd BufWritePost plugins.lua PackerCompile]]

-- Autoupdate filetype on writes
vim.cmd[[autocmd MyAutoCmd BufWritePost * nested lua require'jc.autocommands'.redetect_filetype()]]

-- Handle non modifiable buffers
vim.cmd[[autocmd MyAutoCmd BufEnter * lua require'jc.autocommands'.handle_no_modifiable()]]

-- Load filetype autocommands
for lang_name in pairs(require'jc.filetypes') do
  vim.cmd('autocmd MyAutoCmd Filetype ' .. lang_name
    .. " lua require'jc.filetypes'." .. lang_name .. "()")
end

vim.cmd('augroup END')

local M = {}

function M.redetect_filetype()
  local current_buffer = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(current_buffer, 'filetype')
  if not filetype then
    vim.cmd[[filetype detect]]
  end
end

function M.handle_no_modifiable()
  local current_buffer = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_get_option(current_buffer, 'modifiable') then
    vim.cmd[[setlocal nofoldenable]]
    vim.cmd[[setlocal foldcolumn=0]]
    vim.cmd[[setlocal colorcolumn=]]
    vim.cmd[[setlocal signcolumn=no]]
  end
end

return M
