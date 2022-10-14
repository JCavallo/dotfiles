-- vim:tabstop=2:shiftwidth=2:softtabstop=2
return require('packer').startup {
  function(use)
    use 'wbthomason/packer.nvim'                  -- Plugin manager

    -- Lua tooling
    use 'tjdevries/plenary.nvim'                  -- Pseudo lua stdlib
    use 'nvim-lua/popup.nvim'                     -- Lua tools for creating popups

    ----------------
    -- IDE Things --
    ----------------

    use 'nvim-lua/lsp-status.nvim'                -- Utilities
    use 'folke/lsp-colors.nvim'                   -- Better colors
    use {                                         -- Better info
      'folke/lsp-trouble.nvim',
      config = function() require'jc.plugin_configuration'.trouble() end
    }
    use 'neovim/nvim-lspconfig'                   -- Neovim integrated lsp client
    use {
      'williamboman/nvim-lsp-installer',
      config = function() require'jc.plugin_configuration'.setup_lsp() end
    }
    use {                                         -- Completion framework
      'hrsh7th/nvim-cmp',
      config = function() require'jc.plugin_configuration'.completion() end
    }
    use 'hrsh7th/cmp-buffer'                      -- Completion from Buffers
    use 'hrsh7th/cmp-nvim-lsp'                    -- Completion from LSP
    use 'hrsh7th/cmp-path'                        -- Competion from path
    use 'hrsh7th/cmp-cmdline'                     -- Competion from command history

    use {                                         -- Debugger
      "mfussenegger/nvim-dap",
      opt = true,
      event = "BufReadPre",
      module = { "dap" },
      wants = { "nvim-dap-virtual-text", "DAPInstall.nvim", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
      requires = {
        "ravenxrz/DAPInstall.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap-python",
      },
      config = function()
        require("jc.plugin_configuration").setup_dap()
      end,
    }

    --------------------
    -- Telescope Mode --
    --------------------
    use {
      'nvim-telescope/telescope.nvim',
      config = function() require'jc.plugin_configuration'.telescope() end
    }
    use 'nvim-telescope/telescope-fzf-writer.nvim'  -- Live grep
    use {
      'nvim-telescope/telescope-fzf-native.nvim',   -- Faster filtering
      run = 'make',
    }
    use 'nvim-telescope/telescope-symbols.nvim'     -- Nice Symbols
    use "nvim-telescope/telescope-dap.nvim"  -- Dap integration
    use 'nvim-telescope/telescope-ui-select.nvim'
    use 'rcarriga/nvim-notify'

    -----------------
    -- Tree Sitter --
    -----------------
    use {                                         -- Parser base
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function() require'jc.plugin_configuration'.treesitter() end
    }
    use 'romgrk/nvim-treesitter-context'          -- Show context of current line
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/completion-treesitter'
    use 'windwp/nvim-ts-autotag'                  -- Auto close tags
    use 'vigoux/architext.nvim'
    use 'nvim-treesitter/playground'

    -------------
    -- Editing --
    -------------
    use {                                         -- Better Join / Split
      'AndrewRadev/splitjoin.vim',
      keys = {'gS', 'gJ'}
      }
    use {                                         -- Tabularize
      'godlygeek/tabular',
      cmd = 'Tabularize'
    }
    use {                                         -- Autoclose things
      'cohama/lexima.vim',
      config = function() require'jc.plugin_configuration'.lexima() end
    }
    use {                                         -- Exchange things
      'tommcdo/vim-exchange',
      keys = 'cx'
    }
    use {                                         -- Commenting tools
      'numToStr/Comment.nvim',
      config = function() require('Comment').setup() end,
    }
    use 'quangnguyen30192/cmp-nvim-ultisnips'     -- Ulti-Snips / cmp link
    use 'SirVer/ultisnips'                        -- Snippet engine
    use 'honza/vim-snippets'                      -- Snippet collection

    -----------
    -- Tools --
    -----------
    use {                                         -- Show colors from color codes
      'norcalli/nvim-colorizer.lua',
      config = function() require'colorizer'.setup() end
    }
    use 'junegunn/vim-peekaboo'                   -- Preview register contents
    use 'simnalamburt/vim-mundo'                  -- Better undo
    use 'tpope/vim-repeat'                        -- Better repeat
    use 'dhruvasagar/vim-table-mode'              -- Table mode
    use {                                         -- Local vimrc files
      'embear/vim-localvimrc',
      config = function() require'jc.plugin_configuration'.localvimrc() end
    }
    use {                                         -- Auto edit as sudo
      'lambdalisue/suda.vim',
      config = function() require'jc.plugin_configuration'.suda() end
    }
    use {
      'voldikss/vim-floaterm',                  -- Floating terminals
      config = function() require'jc.plugin_configuration'.floaterm() end
    }
    use 'dawsers/telescope-floaterm.nvim'
    use {
      'nvim-neorg/neorg',
      config = function() require'jc.plugin_configuration'.neorg() end,
      requires = "nvim-neorg/neorg-telescope"
    }

    ----------------
    -- Navigation --
    ----------------
    use {
      'ggandor/leap.nvim',
      config = function() require'jc.plugin_configuration'.leap() end,
    }
    use {                                         -- Mix vim / Tmux pane navigation
      'christoomey/vim-tmux-navigator',
      cmd = {'TmuxNavigateLeft', 'TmuxNavigateRight',
      'TmuxNavigateUp', 'TmuxNavigateDown'},
      config = function() require'jc.plugin_configuration'.tmux_navigator() end
    }
    use {                                         -- Find keys
      "folke/which-key.nvim",
      config = function() require("which-key").setup{} end
    }
    use {
      'ThePrimeagen/harpoon',
      config = function() require'harpoon'.setup({
        mark_branch = false,
      }) end
    }

    ----------------
    -- Appearance --
    ----------------
    use {
      'kevinhwang91/nvim-ufo',
      config = function() require'jc.plugin_configuration'.ufo() end,
      requires = 'kevinhwang91/promise-async'
    }
    use {                                         -- Nice welcome window
      'mhinz/vim-startify',
      config = function() require'jc.plugin_configuration'.startify() end
    }
    use {
      'lukas-reineke/indent-blankline.nvim',
      config = function() require'jc.plugin_configuration'.indent_lines() end
    }
    use {                                         -- Better parentheses highlighting
      'luochen1990/rainbow',
      config = function() vim.g.rainbow_active = 1 end
    }
    use 'kyazdani42/nvim-web-devicons'             -- Nice icons
    use 'ryanoasis/vim-devicons'                   -- Moar nice icons
    use 'yamatsum/nvim-web-nonicons'               -- Always moar nice icons
    use 'machakann/vim-highlightedundo'            -- Highlight undo block
    use 'machakann/vim-highlightedyank'            -- Highlight yanked block

    -- Colorschemes
    use {
      'folke/twilight.nvim',
      config = function() require'twilight'.setup({contex = 20}) end
    }
    use {
      'jacoborus/tender.vim',
      config = function() require'jc.plugin_configuration'.tender() end
    }
    use 'axvr/photon.vim'
    use 'drewtempelmeyer/palenight.vim'
    use {
      'folke/tokyonight.nvim',
      config = function() require'jc.plugin_configuration'.tokyonight() end
    }
    use {
      'ful1e5/onedark.nvim',
      config = function() require'jc.plugin_configuration'.onedark() end
    }
    use {
      "catppuccin/nvim",
      as = "catppuccin"
    }

    ----------------------
    -- Custom Operators --
    ----------------------

    -- Text Objects
    use 'kana/vim-textobj-user'                    -- Tools 1
    use 'kana/vim-operator-user'                   -- Tools 2
    use 'kana/vim-textobj-entire'                  -- "ie / ae"
    use 'kana/vim-textobj-indent'                  -- "ii / ai"
    use 'kana/vim-operator-replace'                -- "_" to replace into
    use 'wellle/targets.vim'                       -- General inside / around
    use 'tpope/vim-surround'                       -- Surround operators

    -----------------
    -- Status Line --
    -----------------
    use {
      'hoob3rt/lualine.nvim',
      config = function() require'jc.plugin_configuration'.lualine() end
    }

    ----------------
    -- Git Things --
    ----------------
    use 'rhysd/committia.vim'                     -- Better commit message UI
    use {                                         -- Simple commit history
      'rhysd/git-messenger.vim',
      cmd = 'GitMessenger'
    }
    use {                                         -- Show signs !
      'lewis6991/gitsigns.nvim',
      config = function() require'jc.plugin_configuration'.gitsigns() end
    }
    use {                                         -- Show current file in github
      'ruanyl/vim-gh-line',
      keys = '<Leader>g'
    }
    use {
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function () require"octo".setup() end
    }

    ---------------
    -- Filetypes --
    ---------------

    --use 'jcavallo/tryton-vim'                       -- Tryton
    use 'masukomi/vim-markdown-folding'               -- Better markdown folding
    use {                                             -- Markdown previewer
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install'
    }

    -------------------
    -- Miscellaneous --
    -------------------
    use {
      'renerocksai/telekasten.nvim',
      config = function() require'jc.plugin_configuration'.telekasten() end,
      requires = 'renerocksai/calendar-vim'
    }
    use {                                           -- Faster update times
      'antoinemadec/FixCursorHold.nvim',
      run = function() vim.g.curshold_updatime = 100 end,
    }
    use 'gyim/vim-boxdraw'                          -- Draw boxes
  end,
}
