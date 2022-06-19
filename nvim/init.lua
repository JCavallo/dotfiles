
require('jc.load_packer')

require('jc.options')

require('jc.plugins')

require('jc.vimscript')

require('jc.mappings')

require('jc.autocommands')

require('jc.misc')

vim.g.catppuccin_flavour = 'frappe'
-- vim.g.catppuccin_flavour = 'mocha'
-- vim.g.catppuccin_flavour = 'macchiato'
-- vim.g.catppuccin_flavour = 'latte'

vim.g.tokyonight_style = "night"


vim.g.my_colorscheme = 'tokyonight'
-- vim.g.my_colorscheme = 'catppuccin'

vim.cmd("colorscheme " .. vim.g.my_colorscheme)
