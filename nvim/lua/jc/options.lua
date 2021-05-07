-- Search options
vim.o.ignorecase = true           -- Ignore case
vim.o.smartcase = true            -- Unless the pattern starts with a Cap

-- Status line
vim.o.showmode = false            -- We use a custom status line

-- Command window
vim.o.showcmd = true              -- Print last command used
vim.o.cmdheight = 1               -- Height of the command bar
vim.o.cmdwinheight = 10           -- Max height of the command line
vim.o.inccommand = 'split'        -- Preview command results when appliable

-- Editing
vim.o.virtualedit = 'block,onemore'  -- Allow cursor to "be" at line end
vim.o.autoindent = true           -- Autoindent new lines
vim.o.smartindent = true          -- Do it smartly :)
vim.o.shiftround = true           -- Round indents to shiftwidth
vim.o.linebreak = true            -- Break long lines
vim.o.smarttab = true             -- Be smart when tabbing
vim.o.expandtab = true            -- No one wants actual tabs, only spaces
vim.o.tabstop = 4                 -- Display tabs with 4 spaces
vim.o.softtabstop = 4             -- Always
vim.o.shiftwidth = 4              -- Always
vim.o.cindent = true              -- Be a little more intelligent when indenting
vim.o.backspace = 'indent,eol,start'  -- Allow backspace to delete everything
vim.o.joinspaces = false          -- I know where spaces should be
vim.o.formatoptions = ''
  .. 'c'                          -- Auto wrap comments
  .. 'q'                          -- Auto format comments with gq
  .. 'r'                          -- Continue comments on "enter"
  .. 'j'                          -- Remove useless comment lines
  .. 'n'                          -- Detect lists and format accordingly

-- Navigation
vim.o.whichwrap = 'h,l,b,s'       -- Allow to use h / l at start / end of line

-- Wrapping
vim.o.wrap = false                -- Do not automatically wrap text
vim.o.showbreak = "↪"             -- Show line breaks
 
-- View options
vim.wo.number = true              -- Show line numbers
vim.wo.relativenumber = true      -- Show line numbers relative
                                  -- Disable if performance is really bad
vim.wo.cursorline = true          -- Highlight current line
vim.wo.list = true                -- Show special chars, list below
vim.wo.listchars = "tab:→ ,nbsp:␣,trail:·,extends:»,precedes:«"   -- eol:↲,
vim.o.showmatch = true            -- Show matching parentheses
vim.o.signcolumn = 'yes'          -- Always display the sign column to avoid flickering

-- Split options
vim.o.showtabline = 1             -- We don't use tabs, for now
vim.o.scrolloff = 10              -- Make it so there are always ten lines below my cursor
vim.o.equalalways = true          -- Buffers should have more or less the same size
vim.o.splitright = true           -- Prefer windows splitting to the right
vim.o.splitbelow = true           -- Prefer windows splitting to the bottom
vim.o.winwidth = 30               -- Minimum split width
vim.o.winheight = 1               -- Minimum split height

-- Per buffer, should probably depend on the language
vim.o.textwidth = 79              -- Limit text width
vim.wo.colorcolumn = '80'         -- and show the limit
vim.o.shiftwidth = 4              -- Indent by 4 spaces

-- Completion
vim.o.infercase = true            -- Ignore case when completing
vim.o.wildignore = '__pycache__,' -- Ignore useless files
    .. '*.o,*~,*.pyc,*pycache*,node_modules/**,.hg,*.orig,*.rej' 
    .. '*.obj,*~,.git,eggs/**' 
vim.o.wildmode = 'longest,full'   -- Complete with best match
vim.o.wildoptions = 'pum'         -- Nice popup
-- Recommanded configuration for completion.nvim
vim.o.completeopt = 'menuone,noinsert,noselect'

-- Backup / History
vim.o.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.o.directory = vim.fn.stdpath('data') .. '/swap'
vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.undoreload = 10000
vim.o.history = 1000

-- Folding  (Note : this is actually overriden by treesitter configuration)
vim.o.foldmethod = 'indent'       -- Fold based on syntax
vim.o.foldlevelstart = 1          -- Fold everything at first

-- Misc
vim.o.belloff = 'all'             -- Just turn the dang bell off
vim.o.pumblend = 17               -- Blend pop up with the background
vim.o.lazyredraw = false          -- Always redraw
vim.o.hidden = true               -- Hide rather than delete buffers
vim.o.updatetime = 1000           -- Make updates happen faster
vim.o.mouse = 'n'                 -- Mouse was eaten by the cat
vim.o.shada = "!,'1000,<50,s10,h" -- Shada file configuration
vim.o.modelines = 1               -- One modeline is enough
vim.o.clipboard = 'unnamedplus'   -- Use system clipboard
vim.o.termguicolors = true        -- Use true colors
