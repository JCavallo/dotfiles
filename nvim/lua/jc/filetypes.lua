local M = {}

function M.html()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
end

function M.javascript()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
end

function M.lua()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
end

function M.vim()
  vim.g.vim_indent_cont = 4
  vim.g.vimsyn_folding = 'afPl'
end

function M.xml()
  vim.g.xml_syntax_folding = true
  vim.b.wrap = true
end

function M.yaml()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
end

return M