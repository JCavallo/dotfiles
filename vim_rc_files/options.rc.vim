"---------------------------------------------------------------------------
" Global Options
"---------------------------------------------------------------------------

" Ignore the case of normal letters.
set ignorecase

" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch

" Highlight search result.
set hlsearch

" Clear search
let @/ = ""

" Searches wrap around the end of the file.
set wrapscan

" Default encoding is UTF8
set encoding=utf-8
set fileencoding=utf8

" unix of course
set fileformat=unix
set fileformats=unix,dos,mac
