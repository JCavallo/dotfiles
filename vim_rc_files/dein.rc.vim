" dein configurations.

let g:dein#install_progress_type = 'echo'
let g:dein#install_message_type = 'echo'
let g:dein#enable_notification = 1
let g:dein#notification_icon = expand($VIM_FOLDER . '/rc/signs/warn.png')

let s:path = expand($CACHE . '/dein')
if dein#load_state(s:path)
    call dein#begin(s:path)

    " Core plugins
    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/denite.nvim')
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('SirVer/ultisnips.git')
    call dein#add('honza/vim-snippets')
    call dein#add('vim-airline/vim-airline.git')
    call dein#add('neomake/neomake')
    call dein#add('scrooloose/nerdcommenter')
    call dein#add('sjl/gundo.vim')

    " Dependencies
    call dein#add('mattn/webapi-vim')
    call dein#add('Shougo/context_filetype.vim')
    call dein#add('Shougo/neoinclude.vim')
    call dein#add('tyru/open-browser.vim')

    " Unite plugins
    " call dein#add('Shougo/junkfile.vim')
    call dein#add('chemzqm/unite-location')
    " call dein#add('JCavallo/vim-hg-unite')
    " call dein#add('JCavallo/unite-yarm')

    " Edition plugins
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('tpope/vim-surround')
    call dein#add('tpope/vim-repeat')
    call dein#add('terryma/vim-expand-region')
    call dein#add('kana/vim-operator-user')
    call dein#add('kana/vim-niceblock')
    call dein#add('easymotion/vim-easymotion')
    call dein#add('rhysd/accelerated-jk')
    call dein#add('kana/vim-operator-replace')
    call dein#add('rhysd/vim-operator-surround')
    call dein#add('junegunn/goyo.vim')
    call dein#add('lambdalisue/gina.vim')

    " Visual plugins
    " call dein#add('Yggdroot/indentLine')  " Performance killer
    call dein#add('tyru/open-browser.vim')
    call dein#add('kannokanno/previm')
    call dein#add('Konfekt/FastFold')
    call dein#add('junegunn/rainbow_parentheses.vim')
    call dein#add('Shougo/echodoc.vim')
    call dein#add('vim-scripts/AnsiEsc.vim')
    call dein#add('gu-fan/riv.vim')
    call dein#add('gu-fan/InstantRst')

    " Filetype plugins
    call dein#add('sheerun/vim-polyglot')
    call dein#add('thinca/vim-ft-diff_fold')
    call dein#add('thinca/vim-ft-vim_fold')
    call dein#add('thinca/vim-ft-help_fold')
    call dein#add('plasticboy/vim-markdown')
    call dein#add('nelstrom/vim-markdown-folding')
    call dein#add('ekalinin/Dockerfile.vim')
    call dein#add('Shougo/neco-vim')
    call dein#add('Shougo/neco-syntax')
    call dein#add('JCavallo/tryton-vim')
    " call dein#local('/home/giovanni/Projets/nvim_plugins', {}, ['tryton-vim'])
    call dein#add('carlitux/deoplete-ternjs')
    call dein#add('mklabs/vim-backbone')
    " call dein#add('JCavallo/nvim-nim')
    call dein#local('/home/giovanni/Projets/nvim_plugins', {}, ['nvim-nim'])
    call dein#add('zchee/deoplete-jedi')
    call dein#add('zchee/deoplete-clang')

    " Colorschemes plugins
    call dein#add('JCavallo/flashy-vim')
    call dein#add('Canop/patine')

    " Misc plugins
    call dein#add('vimwiki/vimwiki')
    call dein#add('christoomey/vim-tmux-navigator')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

call map(dein#check_clean(), "delete(v:val, 'rf')")

if dein#check_install()
    call dein#install()
endif
