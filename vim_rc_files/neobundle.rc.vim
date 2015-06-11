"===============================================================================
" Global Plugins
"===============================================================================

" Neobundle should already be here
NeoBundleFetch 'Shougo/neobundle.vim'

" Vimproc to be able to manage tasks asynchronously
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build': {
    \     'windows': 'make -f make_mingw32.mak',
    \     'cygwin': 'make -f make_cygwin.mak',
    \     'mac': 'make -f make_mac.mak',
    \     'unix': 'make -f make_unix.mak',
    \     }
    \ }

" Syntax checker
NeoBundleLazy 'scrooloose/syntastic', {
    \ 'filetypes': 'all',
    \ }

" Better indent lines
NeoBundleLazy 'Yggdroot/indentLine',  {
    \ 'filetypes': 'all'
    \ }

" Allow to bI / bA in Line Visual rather than only Visual Block
NeoBundleLazy 'kana/vim-niceblock',  {
    \ 'mappings': '<Plug>',
    \ }

" External fuzzy file search
NeoBundle 'junegunn/fzf'

"===============================================================================
" Interface
"===============================================================================

" Unite: interface framework
NeoBundleLazy 'Shougo/unite.vim', {
    \ 'commands': [{
    \         'name': 'Unite',
    \         'complete': 'customlist,unite#complete_source'},
    \     'UniteWithCursorWord', 'UniteWithInput'],
    \ 'depends': 'Shougo/neomru.vim',
    \ }

" Unite: save / resume sessions
NeoBundleLazy 'Shougo/unite-session', {
    \ 'filetypes': 'all',
    \ }

" Unite: recently used files
NeoBundleLazy 'Shougo/neomru.vim', {
    \ 'filetypes': 'all',
    \ }

" Unite: outline of current file
NeoBundleLazy 'Shougo/unite-outline'

" Unite: use unite for help
NeoBundleLazy 'Shougo/unite-help'

" Use Unite to browse marks
NeoBundleLazy 'tacroe/unite-mark'

" Use unite to see command history
NeoBundleLazy 'thinca/vim-unite-history'

" Use unite to navigate tags
NeoBundle 'tsukkee/unite-tag'

"Navigate quickfix easily
NeoBundle 'osyo-manga/unite-quickfix'

" Unite filetype specific integration
NeoBundleLazy 'osyo-manga/unite-filetype'

" Snippets
NeoBundle 'SirVer/ultisnips', {
    \ 'unite_source': ['ultisnips'],
    \ }
" NeoBundleLazy 'Shougo/neosnippet.vim', {
    " \ 'depends': ['Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim'],
    " \ 'insert': 1,
    " \ 'filetypes': 'snippet',
    " \ 'unite_sources': [
    " \    'neosnippet', 'neosnippet/user', 'neosnippet/runtime'],
    " \ }

" Neocomplete: insert mode completion
NeoBundleLazy 'Shougo/neocomplete.vim', {
    \ 'depends': 'Shougo/context_filetype.vim',
    \ 'insert': 1
    \ }

" Status Line
NeoBundle 'bling/vim-airline'

" Better parenthesis
NeoBundle 'kien/rainbow_parentheses.vim'

" Connect over ssh
NeoBundleLazy 'Shougo/neossh.vim', {
    \ 'filetypes': 'vimfiler',
    \ 'sources': 'ssh',
    \ }

" Better behaviour when sudoing
NeoBundleLazy 'Shougo/unite-sudo'

" Gundo. Never lose your work again
NeoBundleLazy 'sjl/gundo.vim'

" Better than netrw :)
NeoBundleLazy 'Shougo/vimfiler.vim', {
    \ 'depends': 'Shougo/unite.vim',
    \ 'commands': [
    \     {'name': ['VimFiler', 'Edit', 'Write'],
    \         'complete': 'customlist,vimfiler#complete'},
    \     'Read', 'Source'],
    \ 'mappings': '<Plug>',
    \ 'explorer': 1,
    \ }

" Integrated Shell
NeoBundleLazy 'Shougo/vimshell.vim', {
    \ 'commands': [
    \     {'name': 'VimShell',
    \         'complete': 'customlist,vimshell#complete'}],
    \ 'mappings': '<Plug>',
    \ }

" That you can ssh into !
NeoBundleLazy 'ujihisa/vimshell-ssh', {
    \ 'filetypes': 'vimshell',
    \ }

" Accelerated jk, So awesome...
NeoBundleLazy 'rhysd/accelerated-jk', {
    \ 'mappings': '<Plug>(accelerated_jk_',
    \ }

" Use unite to browse hg
NeoBundle 'JCavallo/vim-hg-unite'

" Approximate theme colors
NeoBundle 'godlygeek/csapprox', {'terminal': 1}

" Some colorschemes
NeoBundle 'thinca/vim-guicolorscheme', {'terminal': 1}

" Flashy color theme :)
NeoBundle 'JCavallo/flashy-vim'

"===============================================================================
" Motions
"===============================================================================

" Easier moving
NeoBundle 'Lokaltog/vim-easymotion', {
    \ 'mappings': '<Plug>',
    \ }

" Surround movement
NeoBundle 'tpope/vim-surround'

" Make everything repeatable
NeoBundleLazy 'tpope/vim-repeat', {
    \ 'mappings': '.',
    \ }

" Select by blocks
NeoBundle 'terryma/vim-expand-region'

"===============================================================================
" Filetypes
"===============================================================================

" Better json
NeoBundleLazy 'elzr/vim-json', {
    \   'filetypes': 'json',
    \ }

" Better diff files (folding)
NeoBundleLazy 'sgeb/vim-diff-fold', {
    \   'filetypes': ['diff', 'patch'],
    \ }

" Indent javascript
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
    \ 'filetypes': 'javascript',
    \ }

" Better pep8 autoindent
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
    \ 'filetypes': 'python',
    \ }

" Tryton Specific
NeoBundle 'JCavallo/tryton-vim', {
    \ 'filetypes': ['python', 'xml', 'trpy', 'trxml'],
    \ 'mappings': '<Plug>(tryton-',
    \ }

" Restructured Text: Preview and syntax
NeoBundleLazy 'Rykka/riv.vim', {
    \ 'filetypes': 'rst',
    \ }
NeoBundleLazy 'Rykka/InstantRst', {
    \ 'filetypes': 'rst',
    \ }

" Nim
NeoBundleLazy 'zah/nimrod.vim', {
    \ 'filetypes': 'nim',
    \ }

"===============================================================================
" Other
"===============================================================================

" Use one key to insert multiple values
NeoBundleLazy 'kana/vim-smartchr', {
    \ 'insert': 1,
    \ }

" Better comments
NeoBundle 'scrooloose/nerdcommenter'
