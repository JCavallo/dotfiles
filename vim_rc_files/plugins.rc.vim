"---------------------------------------------------------------------------
" Plugin:
"

if neobundle#tap('neocomplete.vim') "{{{
  let g:neocomplete#enable_at_startup = 1
  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/neocomplete.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/neosnippet.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('ultisnips') "{{{
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
  call neobundle#untap()
endif "}}}

if neobundle#tap('vimshell.vim') "{{{
  " <C-Space>: switch to vimshell.
  nmap <C-@>  <Plug>(vimshell_switch)
  nnoremap !  q:VimShellExecute<Space>
  nnoremap <leader>i  q:VimShellInteractive<Space>
  nnoremap <leader>t  q:VimShellTerminal<Space>

  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/vimshell.rc.vim'

  call neobundle#untap()
endif "}}}

if neobundle#tap('unite.vim') "{{{
  " The prefix key.
  nnoremap    [unite]   <Nop>
  xnoremap    [unite]   <Nop>
  nmap    <space> [unite]
  xmap    <space> [unite]

  " Quick sources
  nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=sources source<CR>
  " Quick bookmarks
  nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=bookmarks bookmark<CR>
  " Quick mark search
  nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=marks mark<CR>
  " Quick file search
  nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async file/new<CR>
  " Quick grep
  nnoremap <silent><expr> [unite]g
        \ ":\<C-u>Unite grep -buffer-name=grep%".tabpagenr()." -auto-preview -no-split -no-empty\<CR>"
  " Quick help
  nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<CR>
  " Quick buffer
  nnoremap <silent> [unite]i :<C-u>Unite -buffer-name=buffer buffer<CR>
  " Previous changes navigation
  nnoremap <silent> [unite]k
        \ :<C-u>Unite change jump<CR>
  " Location List
  nnoremap <silent> [unite]l :<C-u>Unite -buffer-name=location_list location_list<CR>
  " Quick outline
  nnoremap <silent> [unite]o
        \ :<C-u>Unite outline -start-insert -resume<CR>
  " Quick sessions (projects)
  nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=sessions session<CR>
  " Quick registers
  xnoremap <silent> [unite]r
        \ d:<C-u>Unite -buffer-name=register register history/yank<CR>
  " Quick window switch
  nnoremap <silent> [unite]w  :<C-u>Unite window<CR>
  " Quick yank history
  nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<CR>
  " General Fuzzy search
  nnoremap <silent> [unite]<Space>
        \ :<C-u>Unite -buffer-name=files -multi-line -unique -silent
        \ jump_point file_point buffer_tab:- file_mru
        \ file_rec/git file file_rec/async<CR>
  " Quick commands
  nnoremap <silent> [unite]; :<C-u>Unite -buffer-name=history history/command command<CR>

  " <C-t>: Tab pages
  nnoremap <silent><expr> <C-t>
        \ ":\<C-u>Unite -auto-resize -select=".(tabpagenr()-1)." tab\<CR>"

  " t: tags-and-searches "{{{
  " The prefix key.
  nnoremap    [Tag]   <Nop>
  nmap    t [Tag]
  " Jump.
  " nnoremap [Tag]t  g<C-]>
  nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "g\<C-]>" :
        \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag tag/include\<CR>"
  nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
  "}}}

  " Execute help.
  nnoremap <silent> <C-h>  :<C-u>Unite -buffer-name=help help<CR>

  " Execute help by cursor keyword.
  nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord help<CR>

  " Search.
  nnoremap <silent><expr> /
        \ ":\<C-u>Unite -buffer-name=search%".bufnr('%')." -start-insert line:forward:wrap\<CR>"
  nnoremap <expr> g/  <SID>smart_search_expr('g/',
        \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>")
  nnoremap <silent><expr> ?
        \ ":\<C-u>Unite -buffer-name=search%".bufnr('%')." -start-insert line:backward\<CR>"
  nnoremap <silent><expr> *
        \ ":\<C-u>UniteWithCursorWord -buffer-name=search%".bufnr('%')." line:forward:wrap\<CR>"
  nnoremap [unite]/       /
  nnoremap [unite]?       ?
  cnoremap <expr><silent><C-g>        (getcmdtype() == '/') ?
        \ "\<ESC>:Unite -buffer-name=search line:forward:wrap -input=".getcmdline()."\<CR>" : "\<C-g>"

  function! s:smart_search_expr(expr1, expr2)
    return line('$') > 5000 ?  a:expr1 : a:expr2
  endfunction

  nnoremap <silent><expr> n
        \ ":\<C-u>UniteResume search%".bufnr('%')." -no-start-insert\<CR>"
  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/unite.rc.vim'

  call neobundle#untap()
endif "}}}

" camlcasemotion.vim"{{{
nmap <silent> W <Plug>CamelCaseMotion_w
xmap <silent> W <Plug>CamelCaseMotion_w
omap <silent> W <Plug>CamelCaseMotion_w
nmap <silent> B <Plug>CamelCaseMotion_b
xmap <silent> B <Plug>CamelCaseMotion_b
omap <silent> B <Plug>CamelCaseMotion_b
""}}}

if neobundle#tap('vim-smartchr') "{{{
  let g:neocomplete#enable_at_startup = 1
  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/smartchr.rc.vim'

  call neobundle#untap()
endif "}}}

" python.vim
let python_highlight_all = 1

if neobundle#tap('vimfiler.vim') "{{{
  "nmap    [Space]v   <Plug>(vimfiler_switch)
  nnoremap <silent>   <leader>v   :<C-u>VimFiler -find<CR>
  nnoremap    [Space]ff   :<C-u>VimFilerExplorer<CR>

  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugins/vimfiler.rc.vim'

  call neobundle#untap()
endif "}}}

" vim oprtaor surround"{{{
nmap <silent>ma <Plug>(operator-surround-append)
nmap <silent>md <Plug>(operator-surround-delete)
nmap <silent>mr <Plug>(operator-surround-replace)
"}}}

" Operator-replace.
nmap R <Plug>(operator-replace)
xmap R <Plug>(operator-replace)
xmap p <Plug>(operator-replace)

if neobundle#tap('accelerated-jk') "{{{
  nmap <silent>j <Plug>(accelerated_jk_gj)
  nmap gj j
  nmap <silent>k <Plug>(accelerated_jk_gk)
  nmap gk k
  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-smalls') "{{{
  nmap S <Plug>(smalls)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-vcs') "{{{
  nnoremap <silent> [Space]gs  :<C-u>Vcs status<CR>
  nnoremap <silent> [Space]gc  :<C-u>Vcs commit<CR>

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-airline') "{{{
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP'}
  call neobundle#untap()
endif "}}}

if neobundle#tap('nerdcommenter')
  let g:NERDSpaceDelims=1
endif

if neobundle#tap('syntastic')
    let g:syntastic_enable_balloons = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_enable_signs = 1
    let g:syntastic_auto_jump = 0
    let g:syntastic_enable_highlighting = 1
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_error_symbol='!'
    let g:syntastic_style_error_symbol='>'
    let g:syntastic_warning_symbol='.'
    let g:syntastic_style_warning_symbol='>'
    let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
    let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['python'],
                            \ 'passive_filetypes': [] }
    let g:syntastic_python_flake8_post_args='--ignore=E123,E124,E126,E128,E711,W404,F403'
    let g:syntastic_python_pylint_post_args='--disable=E1101,W0613,C0111'
    let g:syntastic_python_checkers=['pyflakes', 'flake8']
endif
