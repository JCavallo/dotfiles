-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    -- If in windows WSL, use clip.exe for copy
    -- https://github.com/neovim/neovim/issues/19204#issuecomment-1175028634
    if vim.fn.has('wsl') == 1 then
      vim.fn.system('clip.exe', vim.fn.getreg('"'))
    end
    vim.highlight.on_yank({
      timeout = 40,
    })
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

vim.cmd('augroup MyAutoCmd')
vim.cmd('autocmd!')

-- Make directory automatically -> http://vim-users.jp/2011/02/hack202/
vim.cmd[[autocmd MyAutoCmd BufWritePre * call JCCreateFolderIfNecessary(expand('<afile>:p:h'), v:cmdbang)]]

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
  if not vim.api.nvim_get_option_value('modifiable', { buf = current_buffer}) then
    vim.cmd[[setlocal nofoldenable]]
    vim.cmd[[setlocal foldcolumn=0]]
    vim.cmd[[setlocal colorcolumn=0]]
    vim.cmd[[setlocal signcolumn=no]]
  end
end

function M.default_configuration()
  vim.bo.expandtab = true
end

return M
