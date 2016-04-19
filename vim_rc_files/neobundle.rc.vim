"===============================================================================
" Global Plugins
"===============================================================================

" Syntax checker
NeoBundleLazy 'scrooloose/syntastic', {
    \ 'filetypes': 'all',
    \ }

" Better indent lines
NeoBundleLazy 'Yggdroot/indentLine',  {
    \ 'filetypes': 'all'
    \ }

"===============================================================================
" Interface
"===============================================================================

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

" Status Line
NeoBundle 'bling/vim-airline'

" Better parenthesis
NeoBundle 'kien/rainbow_parentheses.vim'

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

" Use unite to browse hg
NeoBundle 'JCavallo/vim-hg-unite'

" Flashy color theme :)
NeoBundle 'JCavallo/flashy-vim'

"===============================================================================
" Motions
"===============================================================================

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

" Indent javascript
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
    \ 'filetypes': 'javascript',
    \ }

" Tryton Specific
NeoBundle 'JCavallo/tryton-vim', {
    \ 'filetypes': ['python', 'xml', 'trpy', 'trxml'],
    \ 'mappings': '<Plug>(tryton-',
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
