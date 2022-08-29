-- Leader
vim.g.mapleader = ','

-- Search options
vim.opt.ignorecase = true           -- Ignore case
vim.opt.smartcase = true            -- Unless the pattern starts with a Cap

-- Status line
vim.opt.showmode = false            -- We use a custom status line

-- Command window
vim.opt.showcmd = true              -- Print last command used
vim.opt.cmdheight = 1               -- Height of the command bar
vim.opt.cmdwinheight = 10           -- Max height of the command line
vim.opt.inccommand = 'split'        -- Preview command results when appliable

-- Editing
vim.opt.virtualedit = 'block,onemore'  -- Allow cursor to "be" at line end
vim.opt.shiftround = true           -- Round indents to shiftwidth
vim.opt.linebreak = true            -- Break long lines
vim.opt.smarttab = true             -- Be smart when tabbing
vim.opt.expandtab = true            -- No one wants actual tabs, only spaces
vim.opt.tabstop = 4                 -- Display tabs with 4 spaces
vim.opt.softtabstop = 4             -- Always
vim.opt.shiftwidth = 4              -- Always
vim.opt.cindent = true              -- Be a little more intelligent when indenting
vim.opt.backspace = 'indent,eol,start'  -- Allow backspace to delete everything
vim.opt.joinspaces = false          -- I know where spaces should be
vim.opt.formatoptions = ''
  .. 'c'                          -- Auto wrap comments
  .. 'q'                          -- Auto format comments with gq
  .. 'r'                          -- Continue comments on "enter"
  .. 'j'                          -- Remove useless comment lines
  .. 'n'                          -- Detect lists and format accordingly

-- Navigation
vim.opt.whichwrap = 'h,l,b,s'       -- Allow to use h / l at start / end of line

-- Wrapping
vim.opt.wrap = false                -- Do not automatically wrap text
vim.opt.showbreak = "↪"             -- Show line breaks
 
-- View options
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Show line numbers relative
                                  -- Disable if performance is really bad
vim.opt.cursorline = true          -- Highlight current line
vim.opt.list = true                -- Show special chars, list below
vim.opt.listchars = "tab:→ ,nbsp:␣,trail:·,extends:»,precedes:«"   -- eol:↲,
vim.opt.showmatch = true            -- Show matching parentheses
vim.opt.signcolumn = 'yes'          -- Always display the sign column to avoid flickering
vim.opt.concealcursor = 'nc'        -- Conceal in normal / command mode

-- Split options
vim.opt.showtabline = 1             -- We don't use tabs, for now
vim.opt.scrolloff = 10              -- Make it so there are always ten lines below my cursor
vim.opt.equalalways = true          -- Buffers should have more or less the same size
vim.opt.splitright = true           -- Prefer windows splitting to the right
vim.opt.splitbelow = true           -- Prefer windows splitting to the bottom
vim.opt.winwidth = 30               -- Minimum split width
vim.opt.winheight = 1               -- Minimum split height

-- Per buffer, should probably depend on the language
vim.opt.textwidth = 79              -- Limit text width
vim.opt.colorcolumn = '80'         -- and show the limit
vim.opt.shiftwidth = 4              -- Indent by 4 spaces

-- Completion
vim.opt.infercase = true            -- Ignore case when completing
vim.opt.wildignore = '__pycache__,' -- Ignore useless files
    .. '*.o,*~,*.pyc,*pycache*,node_modules/**,.hg,*.orig,*.rej' 
    .. '*.obj,*~,.git,eggs/**' 
vim.opt.wildmode = 'longest,full'   -- Complete with best match
vim.opt.wildoptions = 'pum'         -- Nice popup
-- Recommanded configuration for nvim-cmp
vim.opt.completeopt = 'menu,menuone,noselect'

-- Backup / History
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.opt.directory = vim.fn.stdpath('data') .. '/swap'
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.history = 1000

-- Folding (nvim-ufo)
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldmethod = 'manual'
--
-- Folding (Treesitter)
-- vim.opt.foldmethod = 'indent'       -- Fold based on syntax
-- vim.opt.foldlevelstart = 1          -- Fold everything at first

-- Misc
vim.opt.belloff = 'all'             -- Just turn the dang bell off
vim.opt.pumblend = 17               -- Blend pop up with the background
vim.opt.lazyredraw = false          -- Always redraw
vim.opt.hidden = true               -- Hide rather than delete buffers
vim.opt.updatetime = 1000           -- Make updates happen faster
vim.opt.mouse = 'n'                 -- Mouse was eaten by the cat
vim.opt.shada = "!,'1000,<50,s10,h" -- Shada file configuration
vim.opt.modelines = 1               -- One modeline is enough
vim.opt.clipboard = 'unnamedplus'   -- Use system clipboard
vim.opt.termguicolors = true        -- Use true colors
