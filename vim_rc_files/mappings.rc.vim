"===============================================================================
" Function Key Mappings
"===============================================================================

" <F1>: Help
nmap <F1> [denite]h

" <F3>: Gundo
nnoremap <F3> :<C-u>MundoToggle<CR>

" <F4>: Toggle distraction free
nnoremap <silent><F4> :Goyo <bar> :silent !tmux set status <bar>
    \ :call <SID>ToggleDeoplete() <CR>

function! s:ToggleDeoplete()  " {{{
    if dein#tap('deoplete.nvim')
        if !dein#is_sourced('deoplete.nvim')
            call dein#source('deoplete.nvim')
        endif
    endif
    if deoplete#is_enabled()
        call deoplete#disable()
    endif
endfunction  " }}}

" <F5>: Toggle paste mode
nnoremap <F5> :set paste!<cr>

" <F7>/<Shift-F7>: Add / Remove vimpdb breakpoint

" <F10> : Handy shortcut to check cursor coloring
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
    \ '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"===============================================================================
" Leader Key Mappings
"===============================================================================

" <Leader>a*: Ag searching mappings

" <Leader>c*: NERDCommenter mappings
" <Leader>cd: Switch to the directory of the open buffer
nnoremap <Leader>cd :cd %:p:h<cr>:pwd<cr>

" <Leader>dd: Close current buffer
nnoremap <Leader>dd :bdelete<cr>

" <Leader>dg: Diff gets in 4way merge
nnoremap <Leader>dgl :<C-u>diffget LOCAL<CR>
nnoremap <Leader>dgr :<C-u>diffget REMOTE<CR>
nnoremap <Leader>dgb :<C-u>diffget BASE<CR>

" <Leader>e: New file in current buffer folder
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" <Leader>f : Vim filer
nnoremap <leader>f :<C-u>VimFilerExplorer<CR>

" <Leader>la : Add logging, lA to add above
nnoremap <Leader>la :<C-u>call <SID>AddLogging(0)<CR>
nnoremap <Leader>lA :<C-u>call <SID>AddLogging(-1)<CR>

function! s:AddLogging(delta)  " {{{
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    let cur_pos = getpos('.')
    let [head_num, head_col] = searchpos(
        \ '^import logging as tmp_logging;import pprint as tmp_pprint  # PYPRINT', 'nb')
    if head_num == 0 && head_col == 0
        call setpos('.', [0, 0, 1, 0])
        call search('^[^#]')
        call append(getpos('.')[2] + 1,
            \ 'import logging as tmp_logging;import pprint as tmp_pprint  # PYPRINT')
        call append(getpos('.')[2] + 2,
            \ 'def _print(*x):  # PYPRINT')
        call append(getpos('.')[2] + 3,
            \ "    for _line in tmp_pprint.pformat(x, indent=1, width=130).split('\\n'):  # PYPRINT")
        call append(getpos('.')[2] + 4,
            \ "        tmp_logging.getLogger('root').critical(_line)  # PYPRINT")
        let cur_pos[1] += 4
        call setpos('.', cur_pos)
    endif
    let cur_pos[2] = 1
    call setpos('.', cur_pos)
    call search('[^ ]')
    let indent = getpos('.')[2] - 1
    call append(cur_pos[1] + a:delta,
        \ "_print()  # PYPRINT")
    let cur_pos[1] += 1 + a:delta
    let cur_pos[2] = 8 + indent
    call setpos('.', cur_pos)
    execute(':normal I' . repeat(' ', indent))
    call setpos('.', cur_pos)
    startinsert
endfunction  " }}}

" <Leader>lr : Remove logging
nnoremap <Leader>lr :<C-u>call <SID>RemoveLogging()<CR>

function! s:RemoveLogging()  " {{{
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    execute('g/# PYPRINT/d')
endfunction  " }}}

" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

" <Leader>pa : Add pudb (pa -> after, pA -> before)
nnoremap <Leader>pa :<C-u>call <SID>AddPudb(0)<CR>
nnoremap <Leader>pA :<C-u>call <SID>AddPudb(-1)<CR>

function! s:AddPudb(delta)  " {{{
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    let cur_pos = getpos('.')
    let [head_num, head_col] = searchpos(
        \ '^from pudb.remote import set_trace as tmp_set_trace  # PYPUDB', 'nb')
    if head_num == 0 && head_col == 0
        call setpos('.', [0, 0, 1, 0])
        call search('^[^#]')
        call append(getpos('.')[2] + 1,
            \ 'from pudb.remote import set_trace as tmp_set_trace  # PYPUDB')
        call append(getpos('.')[2] + 2,
            \ 'def _pudb_trace():  # PYPUDB')
        call append(getpos('.')[2] + 3,
            \ "    tmp_set_trace(term_size=(200, " . winheight(0) . "), port=6899)  # PYPUDB")
        let cur_pos[1] += 3
        call setpos('.', cur_pos)
    endif
    let cur_pos[2] = 1
    call setpos('.', cur_pos)
    call search('[^ ]')
    let indent = getpos('.')[2] - 1
    call append(cur_pos[1] + a:delta,
        \ "_pudb_trace()  # PYPUDB")
    let cur_pos[1] += 1 + a:delta
    call setpos('.', cur_pos)
    execute(':normal I' . repeat(' ', indent))
    call setpos('.', cur_pos)
endfunction  " }}}

" <Leafer>pr : Remove pudb
nnoremap <Leader>pr :<C-u>call <SID>RemovePudb()<CR>

function! s:RemovePudb()  " {{{
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    execute('g/# PYPUDB/d')
endfunction  " }}}

" Return to previously shown buffer
nnoremap <Leader>m :e#<CR>

" <Leader>o: only
nnoremap <Leader>o :only<cr>

" open/close the quickfix window
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>:lclose<CR>

" <Leader>s: Spell checking shortcuts
nnoremap <Leader>ss :setlocal spell!<cr>
nnoremap <Leader>sj ]s
nnoremap <Leader>sk [s
nnoremap <Leader>sa zg]s
nnoremap <Leader>sd 1z=
nnoremap <Leader>sf z=

" <Leader>v: Fast editing of the .vimrc
nnoremap <Leader>v :e! ~/.vimrc<cr>

" <Leader>w: Write current buffer
nnoremap <Leader>w :w<cr>

" <Leader>, : Easy motion
nmap <Leader>, <Plug>(easymotion-prefix)

"===============================================================================
" Command-line Mode Key Mappings
"===============================================================================

" jk / kj  exits command mode
cnoremap jk <Esc>
cnoremap kj <Esc>

" Bash like keys for the command line.
cnoremap <c-a> <home>
cnoremap <C-d> <Del>
cnoremap <c-e> <end>

" Ctrl-[bw]: Move left/right by word
cnoremap <c-b> <s-left>
cnoremap <c-w> <s-right>

" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>

" Ctrl-Space: Show history
cnoremap <c-@> <c-f>

cnoremap <c-n> <down>
cnoremap <c-p> <up>
cnoremap <c-f> <left>
cnoremap <c-g> <right>

" Ctrl-v: Paste
cnoremap <c-v> <c-r>"

" w!!: Writes using sudo
cnoremap w!! w !sudo tee % >/dev/null

" Auto escape / and ? in search command.
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

" Command line buffer.
nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:
nnoremap <SID>(command-line-norange) q:<C-u>

nmap ;;  <SID>(command-line-enter)
xmap ;;  <SID>(command-line-enter)

"===============================================================================
" Normal Mode Shift Key Mappings
"===============================================================================

" H: Go to beginning of line.
nnoremap H ^

" K: expand-region
map K <Plug>(expand_region_expand)
map <C-K> <Plug>(expand_region_shrink)

" L: Go to end of line.
nnoremap L g_

" U: Redos since 'u' undos
nnoremap U :redo<cr>

" +/-: Increment number
nnoremap + <c-a>
nnoremap - <c-x>

"===============================================================================
" Normal Mode Ctrl Key Mappings
"===============================================================================

" Smart <C-f>, <C-b>.
nnoremap <silent> <C-f> <C-f>
nnoremap <silent> <C-b> <C-b>

" Ctrl-j: Easy motion up
nmap <c-j> <Plug>(easymotion-overwin-line)

" Ctrl-k: Denite jump
nnoremap <silent> <C-k> :<C-u>Denite change jump<CR>

" Ctrl-n: Fast jump to next result
nnoremap <C-n> :<C-u>Denite -resume -select=+1 -immediately -cursor-wrap line<CR>

" Ctrl-p: Fast jump to previous result
nnoremap <C-p> :<C-u>Denite -resume -select=-1 -immediately -cursor-wrap line<CR>

" Ctrl-sa: (S)elect (a)ll
nnoremap <c-s><c-a> :keepjumps normal ggVG<CR>
" Ctrl-sr: Easier (s)earch and (r)eplace
nnoremap <c-s><c-r> :%s/<c-r><c-w>//gc<left><left><left>
" Ctrl-sw: Quickly surround word
nnoremap <c-s><c-w> viw

" Ctrl-v: Paste (works with system clipboard due to clipboard setting earlier)
nnoremap <c-v> p

" Ctrl-x: Cycle through the splits. I don't ever use enough splits to justify
" wasting 4 very easy to hit keys for them.
nnoremap <c-x> <c-w>w

"===============================================================================
" Insert Mode Normal Mappings
"===============================================================================

" Use jk or kj to exit insert mode
inoremap jk <ESC>l
inoremap kj <ESC>l

" Smart ','
" inoremap <expr> , smartchr#one_of(', ', ',')

" Smart '='
" inoremap <expr> =
"     \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"     \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
"     \ : smartchr#one_of(' = ', '=', ' == ')
" autocmd MyAutoCmd FileType javascript inoremap <buffer> <expr> = smartchr#one_of(' = ', ' === ', '=')
" autocmd MyAutoCmd FileType xml inoremap <buffer> <expr> = smartchr#one_of('=', ' = ', ' == ')

" Smart '.'
" autocmd MyAutoCmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
" autocmd MyAutoCmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')
" autocmd MyAutoCmd FileType javascript inoremap <buffer> <expr> . smartchr#loop('.', ' => ')
" autocmd MyAutoCmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop(' . ', '->', '.')

" Smart '-'
" autocmd MyAutoCmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')

" Smart '+'
" autocmd MyAutoCmd FileType python inoremap <buffer> <expr> + smartchr#one_of(' + ', ' += ', '+')

" Smart ':'
" autocmd MyAutoCmd FileType javascript inoremap <buffer> <expr> : smartchr#loop(': ', ':')
" autocmd MyAutoCmd FileType python inoremap <buffer> <expr> : smartchr#loop(':', ': ')

" SMart '<>'
" inoremap <expr> < smartchr#one_of('<', ' <= ', ' < ')
" inoremap <expr> > smartchr#one_of('>', ' >= ', ' > ')

" Smart '!'
" inoremap <expr> ! smartchr#loop('!', ' != ')
" autocmd MyAutoCmd FileType javascript inoremap <buffer> <expr> ! smartchr#loop('!', ' !== ')

"===============================================================================
" Insert Mode Ctrl Key Mappings
"===============================================================================

" Ctrl-a: Go to begin of line
inoremap <c-a> <esc>I

" Ctrl-c: Inserts line below
inoremap <c-c> <c-o>o

" Ctrl-e: Go to end of line
inoremap <c-e> <esc>A

" Ctrl-f: Move cursor left
inoremap <c-f> <Left>

" Ctrl-j: Move cursor up
inoremap <expr> <c-j> pumvisible() ? "\<C-e>\<Down>" : "\<Down>"

" Ctrl-k: Move cursor up
inoremap <expr> <c-k> pumvisible() ? "\<C-e>\<Up>" : "\<Up>"

" Ctrl-n: Auto complete next

" Ctrl-o: Execute one normal mode command

" Ctrl-p: Auto complete previous

" Ctrl-r: Insert register

" Ctrl-s: Save
inoremap <c-s> <esc>:w<CR>

" Ctrl-u: Undo
inoremap <c-u> <c-o>u

" Ctrl-v: Paste. For some reason, <c-o> is not creating an undo point in the
" mapping
inoremap <c-v> <c-g>u<c-o>gP

" Ctrl-w: Delete previous word, create undo point
inoremap <c-w> <c-g>u<c-w>

" Ctrl-backspace: Delete til beginning of line, create undo point
inoremap <c-bs> <c-g>u<c-u>

"===============================================================================
" Visual Mode Ctrl Key Mappings
"===============================================================================

" Ctrl-c: Copy (works with system clipboard due to clipboard setting)
vnoremap <c-c> y`]

" Ctrl-r: Easier search and replace
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Ctrl-s: Easier substitue
vnoremap <c-s> :s/\%V//g<left><left><left>

"===============================================================================
" Normal Mode Meta Key Mappings
"===============================================================================

" Alt-a: Select all
nnoremap a :keepjumps normal ggVG<CR>

" Alt-s: Go back in changelist.
nnoremap <m-s> <c-i>zzzv

" Alt-d: Delete previous word.
nnoremap <m-d> db

" Alt-hjkl : Pane navigation
nnoremap <silent> <A-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <A-j> :TmuxNavigateDown<CR>
nnoremap <silent> <A-k> :TmuxNavigateUp<CR>
nnoremap <silent> <A-l> :TmuxNavigateRight<CR>

" Alt-Shift-j: Duplicate line down
nnoremap <silent> J mzyyp`zj

" Alt-Shift-k: Duplicate line up
nnoremap <silent> K mzyyp`z

" Alt-o: Jump back in the changelist
nnoremap o g;

" Alt-i: Jump forward in the changelist
nnoremap i g,

"===============================================================================
" Insert Mode Meta Key Mappings
"===============================================================================

inoremap <A-h> <Esc><Plug>TmuxNavigateLeft
inoremap <A-j> <Esc><Plug>TmuxNavigateDown
inoremap <A-k> <Esc><Plug>TmuxNavigateUp
inoremap <A-l> <Esc><Plug>TmuxNavigateRight

"===============================================================================
" Visual Mode Meta Key Mappings
"===============================================================================

" Alt-j: Move selections down
vnoremap j :m'>+<cr>`<my`>mzgv`yo`z

" Alt-k: Move selections up
vnoremap k :m'<-2<cr>`>my`<mzgv`yo`z

"===============================================================================
" Space Key Mappings
"===============================================================================

" Space is also the leader key for Denite actions
" Space-=: Resize windows
nnoremap <space>= <c-w>=

"===============================================================================
" Normal Mode Key Mappings
"===============================================================================

" a: Insert after cursor
" b: Move word backward
nmap b <Plug>(easymotion-linebackward)
nnoremap B b
" c: Change into the blackhole register to not clobber the last yank
nnoremap c "_c
" d: Delete
" e: [Quickfix] key
" f: Find. Also support repeating with .
nnoremap <Plug>OriginalSemicolon ;
nnoremap <silent> f :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>f
nnoremap <silent> t :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>t
nnoremap <silent> F :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>F
nnoremap <silent> T :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>T
" g: Many functions
" Edit top of file in small window below
nnoremap gt :rightbelow 15split<CR>:set winfixheight<CR>gg
" gp to visually select pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" gV to visually select last inserted test
nnoremap gV `[v`]
" gh : Jump to help
nnoremap <silent> gh :<C-u>DeniteCursorWord help<CR>
" gn / gp Jump to a line and the line of before and after of the same indent.
nnoremap <silent> gn :<C-u>call search('^' .
      \ matchstr(getline(line('.')), '\(\s*\)') .'\S')<CR>^
nnoremap <silent> gp :<C-u>call search('^' .
      \ matchstr(getline(line('.')), '\(\s*\)') .'\S', 'bz')<CR>^

" h: Left
" i: Insert before cursor
" j: Accelerated Down
nmap <silent>j <Plug>(accelerated_jk_gj)
" k: Accelerated Up
nmap <silent>k <Plug>(accelerated_jk_gk)
" l: Right
" m: Set mark
" M: Jump to mark
nnoremap M '
" n: Unite resume
nnoremap n :<C-u>Denite -resume -select=+1 -cursor-wrap line<CR>
nnoremap N :<C-u>Denite -resume -select=-1 -cursor-wrap line<CR>
" o: Insert line below cursor
" p: Paste
nnoremap p gp
" Q: Record macros
nnoremap Q  q
" q: smart close
nnoremap <silent> q :<C-u>call <sid>smart_close()<CR>
" r: Replace single character
" s: [Window] See later
" t: Find till
" v: Visual mode
" u: Undo
" w: Move word forward
nmap w <Plug>(easymotion-lineforward)
nnoremap W w
" x: Delete char
" y: Yank
" z: Folds
nnoremap zl ]z
nnoremap zh [z
" [: Many functions
" ]: Many functions
" \: Toggle comment
nmap \ <Leader>c<space>
" ;: Repeat Backward
noremap ; ,
" ,: Leader
" .: Repeat last command

nmap _ <Plug>(operator-replace)

" Up Down Left Right resize splits
nnoremap <up> <c-w>+
nnoremap <down> <c-w>-
nnoremap <left> <c-w><
nnoremap <right> <c-w>>

" Indent
nnoremap > >>
nnoremap < <<

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap [Window] <Nop>
nmap     s [Window]
nnoremap <silent> [Window]e  :<C-u>Unite junkfile/new junkfile -start-insert<CR>
nnoremap <silent> [Window]p  :<C-u>call <SID>split_nicely()<CR>
nnoremap <silent> [Window]v  :<C-u>vsplit<CR>
nnoremap <silent> [Window]h  :<C-u>split<CR>
nnoremap <silent> [Window]c  :<C-u>call <sid>smart_close()<CR>
nnoremap <silent> -  :<C-u>call <SID>smart_close()<CR>
nnoremap <silent> [Window]o  <C-W>\| <C-W>_
nnoremap <silent> [Window]=  <C-W>=

" Space : Denite mappings {{{
nnoremap <silent> [denite] <Nop>
nmap <space> [denite]
nnoremap <silent> [denite]bmm :<C-u>Denite tryton:`tryton#tools#get_current_model()` -mode=normal<CR>
nnoremap <silent> [denite]bmf :<C-u>Denite tryton:`tryton#tools#get_current_model()`/fields -mode=insert<CR>
nnoremap <silent> [denite]bmv :<C-u>Denite tryton:`tryton#tools#get_current_model()`/views -mode=insert<CR>
nnoremap <silent> [denite]bfm :<C-u>Denite tryton:`tryton#tools#get_current_model()`/methods/`tryton#tools#get_current_method()`/mro -mode=normal<CR>
nnoremap <silent> [denite]bt :<C-u>Denite tryton<CR>
    \ -default-action=append register neoyank<CR>
nnoremap <silent> [denite]xm :<C-u>Denite yarm:assigned=me
    \ -buffer-name=Redmine\ -\ Mine -multi-line<CR>
nnoremap <silent> [denite]; :<C-u>Denite -buffer-name=history
    \ command_history<CR>
" }}}

function! s:smart_close()  " {{{
  if winnr('$') != 1
    close
  else
    call s:alternate_buffer()
  endif
endfunction  " }}}

" Split nicely.
command! SplitNicely call s:split_nicely()
function! s:split_nicely()  " {{{
  " Split nicely.
  if winwidth(0) > 2 * &winwidth
    vsplit
  else
    split
  endif
  wincmd p
endfunction  " }}}

function! s:alternate_buffer()  " {{{
  let listed_buffer_len = len(filter(range(1, bufnr('$')),
        \ 's:buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "unite"'))
  if listed_buffer_len <= 1
    enew
    return
  endif

  let cnt = 0
  let pos = 1
  let current = 0
  while pos <= bufnr('$')
    if s:buflisted(pos)
      if pos == bufnr('%')
        let current = cnt
      endif

      let cnt += 1
    endif

    let pos += 1
  endwhile

  if current > cnt / 2
    bprevious
  else
    bnext
  endif
endfunction  " }}}

function! s:buflisted(bufnr)  " {{{
  return exists('t:unite_buffer_dictionary') ?
        \ has_key(t:unite_buffer_dictionary, a:bufnr) && buflisted(a:bufnr) :
        \ buflisted(a:bufnr)
endfunction  " }}}

"===============================================================================
" Visual Mode Key Mappings
"===============================================================================

" Niceblocks
xnoremap I  <Plug>(niceblock-I)
xnoremap A  <Plug>(niceblock-A)

" y: Yank and go to end of selection
xnoremap y y`]

" p: Paste in visual mode should not replace the default register with the
" deleted text
xnoremap p "_dP

" d: Delete into the blackhole register to not clobber the last yank. To 'cut',
" use 'x' instead
xnoremap d "_d

" Indent
xnoremap <TAB>  >
xnoremap <S-TAB>  <
xnoremap > >gv
xnoremap < <gv

" \: Toggle comment
xmap \ <Leader>c<space>

" Enter: Highlight visual selections
xnoremap <silent> <CR> y:let @/ = @"<cr>:set hlsearch<cr>

" Backspace: Delete selected and go into insert mode
xnoremap <bs> c

" Space: QuickRun
xnoremap <space> :QuickRun<CR>

" <|>: Reselect visual block after indent
xnoremap < <gv
xnoremap > >gv

" .: repeats the last command on every line
xnoremap . :normal.<cr>

" @: repeats macro on every line
xnoremap @ :normal@

if has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
