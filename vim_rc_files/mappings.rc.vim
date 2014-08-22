"===============================================================================
" Function Key Mappings
"===============================================================================

" <F1>: Help
nmap <F1> [unite]h

" <F2>: Open Vimfiler

" <F3>: Gundo
nnoremap <F3> :<C-u>GundoToggle<CR>

" <F5>: Toggle paste mode
nnoremap <F5> :set paste!<cr>

" <F7>/<Shift-F7>: Add / Remove vimpdb breakpoint

"===============================================================================
" Leader Key Mappings
"===============================================================================

" <Leader>a*: Ag searching mappings

" <Leader>c*: NERDCommenter mappings
" <Leader>cd: Switch to the directory of the open buffer
nnoremap <Leader>cd :cd %:p:h<cr>:pwd<cr>

" <Leader>d: Close current buffer
nnoremap <Leader>d :bdelete<cr>

" <Leader>e: Fast editing of the .vimrc
nnoremap <Leader>e :e! ~/.vimrc<cr>

" Return to previously shown buffer
nnoremap <Leader>m :e#<CR>

" <Leader>o: only
nnoremap <Leader>o :only<cr>

" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

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

" <Leader>w: Write current buffer
nnoremap <Leader>w :w<cr>

" <Leader>,: Switch to previous split
nnoremap <Leader>, <C-w>p

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

" Ctrl-[hl]: Move left/right by word
cnoremap <c-h> <s-left>
cnoremap <c-l> <s-right>

" <C-k>, K: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ?
      \ '' : getcmdline()[:getcmdpos()-2]<CR>

" Ctrl-Space: Show history
cnoremap <c-@> <c-f>

cnoremap <c-n> <down>
cnoremap <c-p> <up>
cnoremap <c-f> <left>
cnoremap <c-g> <right>

" Unite completion
cmap <C-o> <Plug>(unite_cmdmatch_complete)

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

autocmd MyAutoCmd CmdwinEnter * call s:init_cmdwin()
autocmd MyAutoCmd CmdwinLeave * let g:neocomplcache_enable_auto_select = 1

function! s:init_cmdwin()
  let g:neocomplcache_enable_auto_select = 0
  let b:neocomplcache_sources_list = ['vim_complete']

  nnoremap <buffer><silent> q :<C-u>quit<CR>
  nnoremap <buffer><silent> <TAB> :<C-u>quit<CR>
  inoremap <buffer><expr><CR> neocomplete#close_popup()."\<CR>"
  inoremap <buffer><expr><C-h> col('.') == 1 ?
        \ "\<ESC>:quit\<CR>" : neocomplete#cancel_popup()."\<C-h>"
  inoremap <buffer><expr><BS> col('.') == 1 ?
        \ "\<ESC>:quit\<CR>" : neocomplete#cancel_popup()."\<C-h>"

  " Completion.
  inoremap <buffer><expr><TAB>  pumvisible() ?
        \ "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>\<C-p>"

  " Remove history lines.
  silent execute printf("1,%ddelete _", min([&history - 20, line("$") - 20]))
  call cursor(line('$'), 0)

  startinsert!
endfunction

"===============================================================================
" Normal Mode Shift Key Mappings
"===============================================================================

" H: Go to beginning of line.
nnoremap H ^

" K: expand-region
map K <Plug>(expand_region_expand)

" J: shrink-region
map J <Plug>(expand_region_shrink)

" L: Go to end of line.
nnoremap L g_

" Q: Closes the window
nnoremap Q :q<cr>

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

" Ctrl-h: Move word back.
noremap <c-h> b

" Ctrl-j: Scroll + move down through the file
noremap <c-j> 3<c-e>3j

" Ctrl-k: Scroll + move up through the file
noremap <c-k> 3<c-y>3k

" Ctrl-l: Move word forward.
noremap <c-l> w

" Ctrl-p: Join lines
noremap <c-p> J

" Ctrl-sa: (S)elect (a)ll
nnoremap <c-s><c-a> :keepjumps normal ggVG<CR>
" Ctrl-ss: (S)earch word under cur(s)or in current directory
nnoremap <c-s><c-s> :Unite grep:.::<C-r><C-w><CR>
" Ctrl-sd: (S)earch word in current (d)irectory (prompt for word)
nnoremap <c-s><c-d> :Unite grep:.<CR>
" Ctrl-sf: Quickly (s)earch in (f)ile
nnoremap <c-s><c-f> [unite]l
" Ctrl-sr: Easier (s)earch and (r)eplace
nnoremap <c-s><c-r> :%s/<c-r><c-w>//gc<left><left><left>
" Ctrl-sw: Quickly surround word
nnoremap <c-s><c-w> viw

" Ctrl-t*: Tab operations (When was the last time I used tabs?)
nnoremap <c-t><c-n> :tabnew<cr>
nnoremap <c-t><c-w> :tabclose<cr>
nnoremap <c-t><c-j> :tabprev<cr>
nnoremap <c-t><c-h> :tabprev<cr>
nnoremap <c-t><c-k> :tabnext<cr>
nnoremap <c-t><c-l> :tabnext<cr>

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

" Ctrl-g: Move cursor right
inoremap <c-g> <Right>

" Ctrl-h: Move word left
inoremap <c-h> <c-o>b

" Ctrl-i: Tab

" Ctrl-j: Move cursor up
inoremap <expr> <c-j> pumvisible() ? "\<C-e>\<Down>" : "\<Down>"

" Ctrl-k: Move cursor up
inoremap <expr> <c-k> pumvisible() ? "\<C-e>\<Up>" : "\<Up>"

" Ctrl-l: Move word right
inoremap <c-l> <c-o>w

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

" Alt-h: Go to previous buffer
nnoremap <silent> h :bprevious<CR>

" Alt-j: Move current line down
nnoremap <silent> j mz:m+<cr>`z==

" Alt-k: Move current line up
nnoremap <silent> k mz:m-2<cr>`z==

" Alt-l: Go to next buffer
nnoremap <silent> l :bnext<CR>

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

" Alt-j: Move current line down
imap <m-j> <esc><m-j>a

" Alt-k: Move current line down
imap <m-k> <esc><m-k>a

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

" Space is also the leader key for Unite actions
" Space-=: Resize windows
nnoremap <space>= <c-w>=

"===============================================================================
" Normal Mode Key Mappings
"===============================================================================

" a: Insert after cursor
" b: Move word backward
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
" gb sends back to before gtoping
nnoremap gb 'g:delmark g<cr>
" mark current position before going top
nnoremap gt mggg
" gp to visually select pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" h: Left
" i: Insert before cursor
" j: Down
" k: Up
" l: Right
" M: Marks. Free m for other commands
nnoremap M m
" n: Unite resume
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
" /" Search
" Up Down Left Right resize splits
nnoremap <up> <c-w>+
nnoremap <down> <c-w>-
nnoremap <left> <c-w><
nnoremap <right> <c-w>>

" Indent
nnoremap > >>
nnoremap < <<

" *: Highlight cursor location
nnoremap <silent> <*> :call CursorPing()<CR>

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap [Window] <Nop>
nmap     s [Window]
nnoremap <silent> [Window]p  :<C-u>call <SID>split_nicely()<CR>
nnoremap <silent> [Window]v  :<C-u>vsplit<CR>
nnoremap <silent> [Window]h  :<C-u>split<CR>
nnoremap <silent> [Window]c  :<C-u>call <sid>smart_close()<CR>
nnoremap <silent> -  :<C-u>call <SID>smart_close()<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>

" A .vimrc snippet that allows you to move around windows beyond tabs
nnoremap <silent> <tab> :call <SID>NextWindow()<CR>
nnoremap <silent> <S-tab> :call <SID>PreviousWindowOrTab()<CR>

" Jump to a line and the line of before and after of the same indent.
" Useful for Python.
nnoremap <silent> g{ :<C-u>call search('^' .
      \ matchstr(getline(line('.') + 1), '\(\s*\)') .'\S', 'b')<CR>^
nnoremap <silent> g} :<C-u>call search('^' .
      \ matchstr(getline(line('.')), '\(\s*\)') .'\S')<CR>^

" e: Quickfix
" The prefix key.
nnoremap [Quickfix] <Nop>
nmap     e [Quickfix]
nnoremap <silent> [Quickfix]<Space>
      \ :<C-u>call <SID>toggle_quickfix_window()<CR>

function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction

function! s:smart_close()
  if winnr('$') != 1
    close
  else
    call s:alternate_buffer()
  endif
endfunction

function! s:NextWindow()
  if winnr('$') == 1
    silent! normal! ``z.
  else
    wincmd w
  endif
endfunction

function! s:NextWindowOrTab()
  if tabpagenr('$') == 1 && winnr('$') == 1
    call s:split_nicely()
  elseif winnr() < winnr("$")
    wincmd w
  else
    tabnext
    1wincmd w
  endif
endfunction

function! s:PreviousWindowOrTab()
  if winnr() > 1
    wincmd W
  else
    tabprevious
    execute winnr("$") . "wincmd w"
  endif
endfunction

" Split nicely.
command! SplitNicely call s:split_nicely()
function! s:split_nicely()
  " Split nicely.
  if winwidth(0) > 2 * &winwidth
    vsplit
  else
    split
  endif
  wincmd p
endfunction

function! s:alternate_buffer()
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
endfunction

function! s:buflisted(bufnr)
  return exists('t:unite_buffer_dictionary') ?
        \ has_key(t:unite_buffer_dictionary, a:bufnr) && buflisted(a:bufnr) :
        \ buflisted(a:bufnr)
endfunction

"===============================================================================
" Visual Mode Key Mappings
"===============================================================================

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