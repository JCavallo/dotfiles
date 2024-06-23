require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  ---------
  -- LSP --
  ---------
  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- LSP based utilities
      'jose-elias-alvarez/null-ls.nvim',
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }
  -- Diagnostics via telescope
  use {
    'folke/trouble.nvim',
    config = function() require 'jc.plugin_configuration'.trouble() end
  }

  ----------------
  -- Completion --
  ----------------
  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',  -- completion from lsp
      'L3MON4D3/LuaSnip',  -- snippets
      'saadparwaiz1/cmp_luasnip',  -- access snippets from cmp
      'rafamadriz/friendly-snippets',   -- Snippet collection
      -- 'hrsh7th/cmp-buffer',  -- completion from buffer
      'hrsh7th/cmp-path',  -- completion from path
      'hrsh7th/cmp-cmdline', -- completion on command line
    },
    config = function()
      require("jc.plugin_configuration").completion()
    end,
  }

  ---------------
  -- Debugging --
  ---------------
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    event = "BufReadPre",
    module = { "dap" },
    wants = { "nvim-dap-virtual-text", "nvim-dap-ui" },
    requires = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("jc.plugin_configuration").setup_dap()
    end,
  }

  -----------
  -- Mason --
  -----------
  use {
    'williamboman/mason.nvim',
    requires = {
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'jay-babu/mason-null-ls.nvim',
    },
    config = function()
      require("jc.plugin_configuration").setup_lsp()
    end,
  }

  ----------------
  -- Treesitter --
  ----------------
  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    config = function()
      require("jc.plugin_configuration").treesitter()
    end,
  }
  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }
  use 'romgrk/nvim-treesitter-context'  -- Context of current line

  ---------------
  -- Telescope --
  ---------------
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-writer.nvim'  -- Live grep
    },
    config = function()
      require("jc.plugin_configuration").telescope()
    end,
  }
  use {  -- Faster filtering
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end
  }
  -- use 'nvim-telescope/telescope-dap.nvim' -- Dap integration
  use 'nvim-telescope/telescope-ui-select.nvim' -- Override default vim ui with telescope

  ---------
  -- Git --
  ---------
  use 'tpope/vim-fugitive'  -- The git plugin
  use 'tpope/vim-rhubarb'
  use { -- Show signs!
    'lewis6991/gitsigns.nvim',
    config = function() require 'jc.plugin_configuration'.gitsigns() end
  }
  use 'rhysd/committia.vim'  -- Better commit message UI
  use { -- Simple commit history
    'rhysd/git-messenger.vim',
    cmd = 'GitMessenger'
  }
  use { -- Show current file in github
    'ruanyl/vim-gh-line',
    keys = '<Leader>g'
  }
  use {  -- PR reviewing from inside neovim
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function() require("octo").setup({
      suppress_missing_scope = {
        projects_v2 = true,
      }
    }) end
  }

  ----------------
  -- Navigation --
  ----------------
  use {  -- Jump anywhere
    'ggandor/leap.nvim',
    config = function() require 'jc.plugin_configuration'.leap() end,
  }
  use {  -- Override f / t / F / T
    'ggandor/flit.nvim',
    config = function() require 'jc.plugin_configuration'.flit() end,
  }
  use {  -- Telekinesis
    'ggandor/leap-spooky.nvim',
    config = function() require 'jc.plugin_configuration'.spooky() end,
  }
  use { -- Mix vim / Tmux pane navigation
    'christoomey/vim-tmux-navigator',
    cmd = { 'TmuxNavigateLeft', 'TmuxNavigateRight',
      'TmuxNavigateUp', 'TmuxNavigateDown' },
    config = function() require 'jc.plugin_configuration'.tmux_navigator() end
  }
  -- use { -- Find keys
  --   "folke/which-key.nvim",
  --   config = function() require("which-key").setup {} end
  -- }
  use {
    'ThePrimeagen/harpoon',
    config = function() require 'harpoon'.setup({
        mark_branch = false,
      })
    end
  }

  ----------------------
  -- Custom Operators --
  ----------------------
  use 'kana/vim-textobj-user'                    -- Tools 1
  use 'kana/vim-operator-user'                   -- Tools 2
  use 'kana/vim-operator-replace'                -- "_" to replace into
  use 'wellle/targets.vim'                       -- General inside / around
  use 'tpope/vim-surround'                       -- Surround operators

  ----------------
  -- Misc tools --
  ----------------
  use {
    "rcarriga/nvim-notify",  -- Notifications
    config = function() require 'jc.plugin_configuration'.notify() end,
  }
  use {
    "folke/noice.nvim",  -- Notifications
    config = function() require 'jc.plugin_configuration'.noice() end,
    requires = {
      "MunifTanjim/nui.nvim",
    }
  }
  use { -- Commenting tools
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
  }
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use { -- Tabularize
    'godlygeek/tabular',
    cmd = 'Tabularize'
  }
  use { -- Show colors from color codes
    'norcalli/nvim-colorizer.lua',
    config = function() require 'colorizer'.setup() end
  }
  use 'junegunn/vim-peekaboo' -- Preview register contents
  use 'simnalamburt/vim-mundo' -- Better undo
  use 'tpope/vim-repeat' -- Better repeat
  use { -- Local vimrc files
    'embear/vim-localvimrc',
    config = function() require 'jc.plugin_configuration'.localvimrc() end
  }
  use { -- Auto edit as sudo
    'lambdalisue/suda.vim',
    config = function() require 'jc.plugin_configuration'.suda() end
  }
  use {
    'voldikss/vim-floaterm', -- Floating terminals
    config = function() require 'jc.plugin_configuration'.floaterm() end
  }
  use 'dawsers/telescope-floaterm.nvim'
  use {
    'nvim-neorg/neorg',
    config = function() require 'jc.plugin_configuration'.neorg() end,
    requires = "nvim-neorg/neorg-telescope"
  }

  ----------------
  -- Appearance --
  ----------------
  use {
    'nvim-lualine/lualine.nvim',  -- Fancier statusline
    config = function() require'jc.plugin_configuration'.lualine() end,
  }
  use {
    'kevinhwang91/nvim-ufo',
    config = function() require 'jc.plugin_configuration'.ufo() end,
    requires = 'kevinhwang91/promise-async'
  }
  use { -- Nice welcome window
    'mhinz/vim-startify',
    config = function() require 'jc.plugin_configuration'.startify() end
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function() require 'jc.plugin_configuration'.indent_lines() end
  }
  -- use { -- Better parentheses highlighting
  --   'luochen1990/rainbow',
  --   config = function() vim.g.rainbow_active = 1 end
  -- }
  use 'kyazdani42/nvim-web-devicons' -- Nice icons
  use 'ryanoasis/vim-devicons' -- Moar nice icons
  use 'yamatsum/nvim-web-nonicons' -- Always moar nice icons
  use { -- Highlight undo block
    'tzachar/highlight-undo.nvim',
    config = function() require 'jc.plugin_configuration'.highlight_undo() end
  }
  use {
    'Pocco81/true-zen.nvim',
    config = function() require('true-zen').setup({}) end,
  }

  -----------------
  -- Colorchemes --
  -----------------
  use {
    'folke/twilight.nvim',
    config = function() require 'twilight'.setup({ contex = 20 }) end
  }
  use {
    'jacoborus/tender.vim',
    config = function() require 'jc.plugin_configuration'.tender() end
  }
  use 'axvr/photon.vim'
  use 'drewtempelmeyer/palenight.vim'
  use {
    'folke/tokyonight.nvim',
    config = function() require 'jc.plugin_configuration'.tokyonight() end
  }
  use {
    'ful1e5/onedark.nvim',
    config = function() require 'jc.plugin_configuration'.onedark() end
  }
  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }

  use 'jcavallo/tryton-vim'                       -- Tryton

  ------------------------------------
  -- Force packer sync on first run --
  ------------------------------------
  if vim.g.packer_bootstraping then
    require('packer').sync()
  end
end
)
