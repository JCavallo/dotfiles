require('jc.load_packer')

require('jc.options')

require('jc.plugins')

-- Set in load_packer, will be true on the first run
if vim.g.packer_bootstraping then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

require('jc.vimscript')

require('jc.mappings')

require('jc.autocommands')


vim.g.catppuccin_flavour = 'frappe'
-- vim.g.catppuccin_flavour = 'mocha'
-- vim.g.catppuccin_flavour = 'macchiato'
-- vim.g.catppuccin_flavour = 'latte'

vim.g.my_colorscheme = 'tokyonight'
-- vim.g.my_colorscheme = 'catppuccin'
