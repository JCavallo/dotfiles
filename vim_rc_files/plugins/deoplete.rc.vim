"---------------------------------------------------------------------------
" deoplete.nvim
"---------------------------------------------------------------------------
set completeopt+=noinsert

" Close preview after completion
autocmd CompleteDone * pclose!

call deoplete#custom#source('ghc', 'sorters', ['sorter_word'])
" call deoplete#custom#source('_', 'matchers', ['matcher_head'])
" call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" Use auto delimiter
" call deoplete#custom#source('_', 'converters',
"       \ ['converter_auto_paren',
"       \  'converter_auto_delimiter', 'remove_overlap'])
call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'converter_truncate_abbr',
      \ ])
      "  \ 'converter_truncate_menu',

" call deoplete#custom#source('buffer', 'min_pattern_length', 9999)

let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'
" let g:deoplete#keyword_patterns.tex = '\\?[a-zA-Z_]\w*'
let g:deoplete#keyword_patterns.tex = '[^\w|\s][a-zA-Z_]\w*'

let g:deoplete#omni#input_patterns = {}
let g:deoplete#omni#input_patterns.python = ''
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
let g:deoplete#omni#functions.nim = 'omni#nim'

" inoremap <silent><expr> <C-t> deoplete#mappings#manual_complete('file')

let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_camel_case = 1

" deoplete-clang "{{{
" libclang shared library path
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'

" clang builtin header path
let g:deoplete#sources#clang#clang_header = '/usr/include/clang'

" libclang default compile flags
let g:deoplete#sources#clang#flags = ['-x', 'c++', '-std=c++11']

" compile_commands.json directory path
" Not file path. Need build directory path
" let g:deoplete#sources#clang#clang_complete_database =
"       \ expand('~/src/neovim/build')
"}}}
