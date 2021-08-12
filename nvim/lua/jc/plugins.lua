-- vim:tabstop=2:shiftwidth=2:softtabstop=2
vim.cmd [[packadd packer.nvim]]

return require('packer').startup {
  function(use)
    use 'wbthomason/packer.nvim'                  -- Plugin manager

    -- Lua tooling
    use 'tjdevries/plenary.nvim'                  -- Pseudo lua stdlib
    use 'nvim-lua/popup.nvim'                     -- Lua tools for creating popups
    use 'tjdevries/nlua.nvim'                     -- Tools for writing neovim configuration in lya
    -- TODO nlua Lsp

    ----------------
    -- IDE Things --
    ----------------

    use 'nvim-lua/lsp-status.nvim'                -- Utilities
    use 'folke/lsp-colors.nvim'                   -- Better colors
    use {                                         -- Better info
      'folke/lsp-trouble.nvim',
      config = function() require'jc.plugin_configuration'.trouble() end
    }
    use {                                         -- Neovim integrated lsp client
      'neovim/nvim-lspconfig',
      config = function() require'jc.plugin_configuration'.lsp() end
    }
    use {
      'kabouzeid/nvim-lspinstall',
      cmd = 'LspInstall',
      config = function() require'jc.plugin_configuration'.lspinstall() end
    }
    use {                                         -- Completion framework
      'nvim-lua/completion-nvim',
      config = function() require'jc.plugin_configuration'.completion() end
    }
    use {                                         -- Jump to definition
      'pechorin/any-jump.vim',
      keys = '<Leader>j',
      cmd = 'AnyJump'
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
    use 'ElPiloto/sidekick.nvim'

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
    use 'mg979/vim-visual-multi'                  -- Multiple cursors
    use 'monaqa/dial.nvim'                        -- Better increment / decrement
    use {                                         -- Exchange things
      'tommcdo/vim-exchange',
      keys = 'cx'
    }
    use {                                         -- Commenting tools
      'preservim/nerdcommenter',
      keys = '<Leader>c'
    }
    --use 'SirVer/ultisnips.git'                    -- Snippet engine
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
    use {                                         -- Help with mappings
      'liuchengxu/vim-which-key',
      cmd = {'WhichKey', 'WhichKey'}
    }
    use 'dhruvasagar/vim-table-mode'              -- Table mode
    use {                                         -- Local vimrc files
      'embear/vim-localvimrc',
      config = function() require'jc.plugin_configuration'.localvimrc() end
    }
    use {                                         -- Auto edit as sudo
      'lambdalisue/suda.vim',
      config = function() require'jc.plugin_configuration'.suda() end
    }

    ----------------
    -- Navigation --
    ----------------
    use 'rhysd/accelerated-jk'                    -- Faster j/k
    use 'deris/vim-shot-f'                        -- Show where f / F / t / T leads
    use {                                         -- Easy motion
      'easymotion/vim-easymotion',
      config = function() require'jc.plugin_configuration'.easy_motion() end
    }
    use {                                         -- Mix vim / Tmux pane navigation
      'christoomey/vim-tmux-navigator',
      cmd = {'TmuxNavigateLeft', 'TmuxNavigateRight',
        'TmuxNavigateUp', 'TmuxNavigateDown'},
        config = function() require'jc.plugin_configuration'.tmux_navigator() end
    }
    use {                                         -- Proper buffer removal
      'moll/vim-bbye',
      cmd = {'Bdelete', 'Bwipeout'}
    }
    use {                                         -- Swap windows
      'wesQ3/vim-windowswap',
      keys = '<Leader>ww'
    }

    ----------------
    -- Appearance --
    ----------------
    use {                                         -- Distraction free mode
      'junegunn/goyo.vim',
      cmd = 'Goyo',
      config = function() require'jc.plugin_configuration'.goyo() end
    }
    use {
      'junegunn/limelight.vim',
      cmd = 'Limelight'
    }
    use {                                         -- Nice welcome window
      'mhinz/vim-startify',
      config = function() require'jc.plugin_configuration'.startify() end
    }
    use {                                         -- Nice indentation guides 
      'Yggdroot/indentLine',
      config = function() require'jc.plugin_configuration'.indentLine() end
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
      'jacoborus/tender.vim',
      config = function() require'jc.plugin_configuration'.tender() end
    }
    use 'Canop/patine'
    use 'axvr/photon.vim'
    use 'altercation/vim-colors-solarized'
    use 'iron-e/nvim-highlite'
    use 'jcavallo/flashy-vim'
    use 'dracula/vim'
    use 'drewtempelmeyer/palenight.vim'
    use 'joshdick/onedark.vim'

    ----------------------
    -- Custom Operators --
    ----------------------

    -- Text Objects
    use 'kana/vim-textobj-user'                    -- Tools 1
    use 'kana/vim-operator-user'                   -- Tools 2
    use 'kana/vim-textobj-entire'                  -- "ie / ae"
    use 'kana/vim-textobj-fold'                    -- "iz / az"
    use 'kana/vim-textobj-indent'                  -- "ii / ai"
    use 'kana/vim-operator-replace'                -- "_" to replace into
    use 'wellle/targets.vim'                       -- General inside / around
    use 'andymass/vim-matchup'                     -- Better "%"
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
    use {                                         -- Improved Diff View
      'sindrets/diffview.nvim',
      --cmd = 'DiffViewOpen',
      config = function() require'diffview'.setup{} end
    }

    ---------------
    -- Filetypes --
    ---------------

    --use 'jcavallo/tryton-vim'                       -- Tryton
    use 'masukomi/vim-markdown-folding'               -- Better markdown folding

    -------------------
    -- Miscellaneous --
    -------------------
    -- note taking, requires https://github.com/srid/neuron/releases
    use {
      'oberblastmeister/neuron.nvim',
      config = function() require'jc.plugin_configuration'.neuron() end
    }
    use {                                           -- Faster update times
      'antoinemadec/FixCursorHold.nvim',
      run = function() vim.g.curshold_updatime = 1000 end,
    }
    use 'gyim/vim-boxdraw'                          -- Draw boxes
  end,
}
