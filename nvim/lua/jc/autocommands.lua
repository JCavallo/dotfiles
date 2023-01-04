-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      timeout = 40,
    })
  end,
  group = highlight_group,
  pattern = '*',
})

vim.cmd('augroup MyAutoCmd')
vim.cmd('autocmd!')

-- Make directory automatically -> http://vim-users.jp/2011/02/hack202/
vim.cmd[[autocmd MyAutoCmd BufWritePre * call JCCreateFolderIfNecessary(expand('<afile>:p:h'), v:cmdbang)]]

-- Autoreload plugins when updating plugins.lua
vim.cmd[[autocmd MyAutoCmd BufWritePost plugins.lua PackerCompile]]

-- Handle non modifiable buffers
vim.cmd[[autocmd MyAutoCmd BufEnter * lua require'jc.autocommands'.handle_no_modifiable()]]

-- Defaults we will want everywhere
vim.cmd[[autocmd MyAutoCmd BufEnter * lua require'jc.autocommands'.default_configuration()]]

----------------------------- Filetype Aliases --------------------------------
vim.cmd[[autocmd MyAutoCmd BufEnter *.yaml.tmpl setlocal filetype=yaml]]
-------------------------------------------------------------------------------

-- Load filetype autocommands
for lang_name in pairs(require'jc.filetypes') do
  vim.cmd('autocmd MyAutoCmd Filetype ' .. lang_name
    .. " lua require'jc.filetypes'." .. lang_name .. "()")
end

vim.cmd('augroup END')

local M = {}

function M.handle_no_modifiable()
  local current_buffer = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_get_option(current_buffer, 'modifiable') then
    vim.cmd[[setlocal nofoldenable]]
    vim.cmd[[setlocal foldcolumn=0]]
    vim.cmd[[setlocal colorcolumn=]]
    vim.cmd[[setlocal signcolumn=no]]
  end
end

function M.default_configuration()
  vim.bo.expandtab = true
end

return M
