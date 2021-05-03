vim.cmd [[packadd packer.nvim]]

return require('packer').startup {
  function(use)
    use 'wbthomason/packer.nvim'

    use 'tjdevries/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-telescope/telescope.nvim'


    use {
      'jacoborus/tender.vim',
      config = function()
        vim.g.tender_italic = 1;
        vim.g.tender_bold = 1;
      end
    }

    -- Requires https://github.com/srid/neuron/releases
    use {
      'oberblastmeister/neuron.nvim',
      config = function() require'neuron'.setup{} end
    }









    -- use 'tjdevries/nlua.nvim'
    -- use 'tpope/vim-sensible'
    -- use 'tjdevries/astronauta.nvim'
    -- use 'nvim-lua/popup.nvim'
    -- use 'nvim-telescope/telescope.nvim'
    -- use { 'nvim-telescope/telescope-fzf-native.nvim', run = "make", }
    -- use 'nvim-telescope/telescope-fzf-writer.nvim'
    -- use 'nvim-telescope/telescope-symbols.nvim'
    -- use 'nvim-telescope/telescope-github.nvim'

    -- use {
    --   'antoinemadec/FixCursorHold.nvim',
    --   run = function()
    --     vim.g.curshold_updatime = 1000
    --   end,
    -- }

    -- use 'mhinz/vim-startify'
    -- use 'ryanoasis/vim-devicons'
    -- use 'kyazdani42/nvim-web-devicons'
    -- use 'yamatsum/nvim-web-nonicons'
    -- use 'sjl/gundo.vim'
    -- use 'neovim/nvim-lspconfig'
    -- use 'wbthomason/lsp-status.nvim'
    -- use 'haorenW1025/completion-nvim'
    -- use 'nvim-treesitter/nvim-treesitter'
    -- use {
    --   'nvim-treesitter/completion-treesitter',
    --   run = function() vim.cmd [[TSUpdate]] end
    -- }
    -- use 'rhysd/committia.vim'
    -- use 'rhysd/git-messenger.vim'
    -- use 'lewis6991/gitsigns.nvim'

    -- -- Colorschemes
    -- use 'Canop/patine'
    -- use 'axvr/photon.vim'
    -- use 'altercation/vim-colors-solarized'
    -- use 'Iron-E/nvim-highlite.git'
    -- use 'jcavallo/flashy-vim'
    -- use 'dracula/vim'
  end,
}
