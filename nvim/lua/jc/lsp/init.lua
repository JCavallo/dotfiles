local Path = require('plenary.path')

local has_lsp, lspconfig = pcall(require, 'lspconfig')
local _, lspconfig_util = pcall(require, 'lspconfig.util')
if not has_lsp then
  return
end

local nvim_status = require('lsp-status')
