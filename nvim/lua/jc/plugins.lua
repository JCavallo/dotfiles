vim.g.have_nerd_font = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

require('lazy').setup({
  { -- Tools
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- Notification view
      'numToStr/Comment.nvim', -- Comment tooling
      'tpope/vim-sleuth', -- Autodetect tabstop / shiftwidth
      {
        'godlygeek/tabular', -- Tabularize to align
        cmd = 'Tabularize'
      },
      'norcalli/nvim-colorizer.lua', -- Colors from color codes #13f21a
      'junegunn/vim-peekaboo', -- Preview register contents
      'simnalamburt/vim-mundo', -- Better undo
      'tpope/vim-repeat', -- Better repeat
      'embear/vim-localvimrc', -- Local vimrc files
      'lambdalisue/suda.vim', -- Auto edit with sudo

    },
    config = function()
      require("jc.plugin_configuration").setup_tools()
    end,
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',  -- completion from lsp
      'L3MON4D3/LuaSnip',  -- snippets
      'saadparwaiz1/cmp_luasnip',  -- access snippets from cmp
      'rafamadriz/friendly-snippets',   -- Snippet collection
      'hrsh7th/cmp-path',  -- completion from path
      'hrsh7th/cmp-cmdline', -- completion on command line
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      require("jc.plugin_configuration").setup_completion()
    end,
  },
  { -- Language Server
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'jay-babu/mason-null-ls.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        }
      },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require("jc.plugin_configuration").setup_lsp()
    end,
  },
  { --Debug
    'mfussenegger/nvim-dap',
    event = "BufReadPre",
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'theHamsta/nvim-dap-virtual-text',
      -- languages
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      require("jc.plugin_configuration").setup_dap()
    end,
  },
  { -- Treesitter
    'nvim-treesitter/nvim-treesitter',
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'romgrk/nvim-treesitter-context',
    },
    config = function()
      require("jc.plugin_configuration").setup_treesitter()
    end,
  },
  { -- Telescope
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-writer.nvim',
    },
    config = function()
      require("jc.plugin_configuration").setup_telescope()
    end,
  },
  { -- Git
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb',
      'rhysd/committia.vim',
      {
        'rhysd/git-messenger.vim',
        cmd = 'GitMessenger'
      },
      'lewis6991/gitsigns.nvim',
      {  -- PR reviewing from inside neovim
        'pwntester/octo.nvim',
        requires = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope.nvim',
          'kyazdani42/nvim-web-devicons',
        },
      },
    },
    config = function()
      require("jc.plugin_configuration").setup_git()
    end,
  },
  { -- Navigation
    'ggandor/leap.nvim',
    dependencies = {
      'ggandor/flit.nvim',
      'ggandor/leap-spooky.nvim',
      {
        'christoomey/vim-tmux-navigator',
        cmd = { 'TmuxNavigateLeft', 'TmuxNavigateRight',
          'TmuxNavigateUp', 'TmuxNavigateDown' },
      },
      'ThePrimeagen/harpoon',
    },
    config = function()
      require("jc.plugin_configuration").setup_navigation()
    end,
  },
  { -- Appearance
    'nvim-lualine/lualine.nvim',  -- Fancier statusline
    dependencies = {
      'mhinz/vim-startify', -- Welcome window
      'lukas-reineke/indent-blankline.nvim', -- Indent lines
      -- Colorschemes start here
      'folke/twilight.nvim',
      'jacoborus/tender.vim',
      'axvr/photon.vim',
      'drewtempelmeyer/palenight.vim',
      {
        'folke/tokyonight.nvim',
        lazy = false
      },
      "catppuccin/nvim",
    },
    config = function()
      require("jc.plugin_configuration").setup_appearance()
    end,
  },
  { -- Custom text objects
    'wellle/targets.vim',
    dependencies = {
      'kana/vim-textobj-user',
      'kana/vim-operator-user',
      'kana/vim-operator-replace',
      'tpope/vim-surround',
    },
  },
  ---------------------------- Misc -------------------------------
  {
    'tzachar/highlight-undo.nvim', -- Highlight undo
    event = "VeryLazy",
    opts = {
      duration = 300,
    }
  },
  'jcavallo/tryton-vim',
},
{
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
