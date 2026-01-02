require("jc.load_lazy")

require("jc.options")

require("jc.plugins")

require("jc.vimscript")

require("jc.functions")

require("jc.mappings")

require("jc.autocommands")

local current = "dark"
if vim.fn.empty(vim.fn.glob(vim.fn.expand("$HOME/.local/.current_theme"))) == 0 then
	current = vim.fn.readfile(vim.fn.expand("$HOME/.local/.current_theme"))[1]
end

vim.o.background = current

vim.g.catppuccin_flavour = "frappe"
-- vim.g.catppuccin_flavour = 'mocha'
-- vim.g.catppuccin_flavour = 'macchiato'
-- vim.g.catppuccin_flavour = 'latte'

vim.cmd("colorscheme tokyonight")
-- vim.g.colorscheme = 'catppuccin'
