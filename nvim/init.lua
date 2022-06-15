
require('jc.load_packer')

require('jc.options')

require('jc.plugins')

require('jc.vimscript')

require('jc.mappings')

require('jc.autocommands')

require('jc.misc')

vim.g.my_colorscheme = 'tokyonight'
vim.cmd("colorscheme " .. vim.g.my_colorscheme)
