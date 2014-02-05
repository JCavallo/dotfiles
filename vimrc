"===============================================================================
" My vimrc
"
" Mostly inspired by Terry Ma's :
" https://github.com/terryma/dotfiles/blob/master/.vimrc
"
"===============================================================================

" Disable vi-compatibility
set nocompatible

"===============================================================================
" NeoBundle
"===============================================================================

if has ('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Vimproc to be able to manage tasks asynchronously
NeoBundle 'Shougo/vimproc', { 'build': {
      \   'windows': 'make -f make_mingw32.mak',
      \   'cygwin': 'make -f make_cygwin.mak',
      \   'mac': 'make -f make_mac.mak',
      \   'unix': 'make -f make_unix.mak',
      \ } }

" Fuzzy search
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-session'
NeoBundle 'thinca/vim-unite-history'

" Advanced Search
" NeoBundle 'mileszs/ack.vim'
NeoBundle 'rking/ag.vim'

" Code completion
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neocomplcache'
" NeoBundle 'Valloric/YouCompleteMe'

" Snippets
" NeoBundle 'Shougo/neosnippet-snippets'
" NeoBundle 'Shougo/neosnippet'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'skeept/Ultisnips-neocomplete-unite'

" Comments
NeoBundle 'scrooloose/nerdcommenter'

" File browsing
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/vimfiler'

" Syntax checker
NeoBundle 'scrooloose/syntastic'

" Shell
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/vimshell'

" Motions
NeoBundle 'Lokaltog/vim-easymotion'

" Text Objects
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'terryma/vim-expand-region'

" Tags
NeoBundle 'majutsushi/tagbar'

" Status line
NeoBundle 'bling/vim-airline' " So much faster than Powerline! :)

" Color themems
" NeoBundle 'altercation/vim-colors-solarized'
" NeoBundle 'tomasr/molokai'
" NeoBundle 'Lokaltog/vim-distinguished'
" NeoBundle 'chriskempson/base16-vim'
" NeoBundle 'tpope/vim-vividchalk'
" NeoBundle 'chriskempson/tomorrow-theme', {'rtp': 'vim'}
" NeoBundle 'rainux/vim-desert-warm-256'
" NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'JCavallo/flashy-vim'

" Misc
NeoBundle 'kana/vim-submode'
NeoBundle 'kana/vim-scratch'
NeoBundle 'vim-scripts/BufOnly.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'terryma/vim-smooth-scroll'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'nathanaelkane/vim-indent-guides'

" Tryton Specific
NeoBundle 'JCavallo/tryton-vim'

" Load indent files to automatically do language-dependent indenting
filetype indent on

" Load ftplugin
filetype plugin on

syntax enable

NeoBundleCheck

"===============================================================================
" Local Settings
"===============================================================================

try
  source ~/.vimrc.local
catch
endtry

"===============================================================================
" General Settings
"===============================================================================

" Clear existing autocmd
augroup MyAutoCmd
  autocmd!
augroup END

syntax on

" Solid line for vsplit separator
set fcs=vert:│

" Turn on the mouse
set mouse=a

" Give one virtual space at end of line
set virtualedit=onemore

" Turn on line number
set number
set relativenumber

" Always splits to the right and below
set splitright
set splitbelow

" 256bit terminal
set t_Co=256

" Colorscheme
colorscheme flashy_vim

" Sets how many lines of history vim has to remember
set history=10000

" Set to auto read when a file is changed from the outside
set autoread

" Never write a file without me requesting it
set noautowrite
set noautoread

" Display unprintable chars
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
set showbreak=↪

" Highlight trailing whitepsaces. Don't do it for unite windows or readonly
" files
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup MyAutoCmd
  autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
  autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=10

" How many lines to scroll at a time, make scrolling appears faster
set scrolljump=3

" Min width of the number column to the left
set numberwidth=1

" Fold erything at start
set foldmethod=syntax
set foldlevelstart=1

" Autocomplete setting
set completeopt=menu,longest
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**
set wildignore+=.hg,*.orig,*.rej

" Allow changing buffer without saving it first
set hidden

" Set backspace config
set backspace=eol,start,indent

" Case insensitive search
set ignorecase
set smartcase

" Make search act like search in modern browsers
set incsearch

" Highlight searches by default
set hlsearch

" Show matching brackets
set showmatch

" Show incomplete commands
set showcmd

" Turn off sound
set vb
set t_vb=

" Set encoding to utf8
set encoding=utf-8
set fileencoding=utf8

" Limit to 80 char
set colorcolumn=80  " 80 char limit

" Lower the delay of escaping out of other modes
set timeout timeoutlen=1000 ttimeoutlen=0

" Fix meta-keys which generate <Esc>A .. <Esc>z
if !has('gui_running')
  let c='a'
  while c <= 'z'
    exec "set <M-".c.">=\e".c
    exec "imap \e".c." <M-".c.">"
    let c = nr2char(1+char2nr(c))
  endw
  " Map these two on its own to enable Alt-Shift-J and Alt-Shift-K. If I map the
  " whole spectrum of A-Z, it screws up mouse scrolling somehow. Mouse events
  " must be interpreted as some form of escape sequence that interferes.
  exec 'set <M-J>=J'
  exec 'set <M-K>=K'
endif

" Reload vimrc when edited
autocmd MyAutoCmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc
      \ so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif

" English as default language
try
  lang en_us
catch
endtry

" Set up persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

" backup and swap file directories
set backupdir=~/.vim/backup,~/tmp
set directory=~/.vim/swap

" Tab settings
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab

" Text display settings
set linebreak
set textwidth=79
set autoindent
set nowrap
set whichwrap+=h,l,<,>,[,]

" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" Spelling highlights. Use underline in term to prevent cursorline highlights
" from interfering
if !has("gui_running")
  hi clear SpellBad
  hi SpellBad cterm=underline ctermfg=red
  hi clear SpellCap
  hi SpellCap cterm=underline ctermfg=blue
  hi clear SpellLocal
  hi SpellLocal cterm=underline ctermfg=blue
  hi clear SpellRare
  hi SpellRare cterm=underline ctermfg=blue
endif

" Use a low updatetime. This is used by CursorHold
set updatetime=1000

" What is a word ???
set iskeyword+=-

" Improve cursor appearance
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Always show the statusline
set laststatus=2

"===============================================================================
" Function Key Mappings
"===============================================================================

" <F1>: Help
nmap <F1> [unite]h

" <F2>: Open Vimfiler

" <F3>: Gundo
nnoremap <F3> :<C-u>GundoToggle<CR>

" <F4>: Save session
nnoremap <F4> :<C-u>UniteSessionSave

" <F5>: Toggle paste mode
nnoremap <F5> :set paste!<cr>

" <F6>: Toggle NerdTree
nnoremap <F6> :NERDTreeToggle<cr>

" <F9>: VimShell
nnoremap <F9> :VimShell -split<cr>
inoremap <F9> <Esc>:VimShellCurrentDir -split -toggle<cr>

" <F7>/<Shift-F7>: Add / Remove vimpdb breakpoint

"===============================================================================
" Leader Key Mappings
"===============================================================================

" Map leader and localleader key to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

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

" <Leader>n: NERDTreeFind
nnoremap <silent> <Leader>n :NERDTreeFind<cr> :wincmd p<cr>

" <Leader>o: only
nnoremap <Leader>o :only<cr>

" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

" open/close the quickfix window
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

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

" Bash like keys for the command line.
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Ctrl-[hl]: Move left/right by word
cnoremap <c-h> <s-left>
cnoremap <c-l> <s-right>

" Ctrl-Space: Show history
cnoremap <c-Space> <c-f>

cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-f> <left>
cnoremap <c-g> <right>

" Ctrl-v: Paste
cnoremap <c-v> <c-r>"

" w!!: Writes using sudo
cnoremap w!! w !sudo tee % >/dev/null

" _ : Quick horizontal splits
nnoremap _ :sp<cr>

" | : Quick vertical splits
nnoremap <bar> :vsp<cr>

"===============================================================================
" Normal Mode Shift Key Mappings
"===============================================================================

" H: Go to beginning of line.
nnoremap H ^

" K: expand-region
map K <Plug>(expand_region_expand)

" J: shrink-region
map J <Plug>(expand_region_shrink)

" L: Go to end of line. Repeated invocation goes to next line
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

" Ctrl-b: Go (b)ack. Go to previously buffer
nnoremap <c-b> <c-^>

" Ctrl-d: Scroll half a screen down smoothly
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 5, 1)<CR>

" Ctrl-f: EasyMotion

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

" Ctrl-n: Next cursor in MultiCursor mode

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

" Ctrl-u: Scroll half a screen up smoothly
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 5, 1)<CR>

" Ctrl-v: Paste (works with system clipboard due to clipboard setting earlier)
nnoremap <c-v> p

" Ctrl-x: Cycle through the splits. I don't ever use enough splits to justify
" wasting 4 very easy to hit keys for them.
nnoremap <c-x> <c-w>w

" Ctrl-Space: Quick scratch buffer
nmap <C-@> <Plug>(scratch-open)
nmap <C-Space> <C-@>

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

" Ctrl-d: Unindent shiftwidth

" Ctrl-e: Go to end of line
inoremap <c-e> <esc>A

" Ctrl-f: Move cursor left
inoremap <c-f> <Left>

" Ctrl-g: Move cursor right
" Surround.vim maps these things that I don't use
augroup MyAutoCmd
  autocmd VimEnter * silent! iunmap <C-G>s
  autocmd VimEnter * silent! iunmap <C-G>S
  autocmd BufEnter * silent! iunmap <buffer> <C-G>g
augroup END
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

" Ctrl-f: Find with MultipleCursors
vnoremap <c-f> :MultipleCursorsFind 

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
imap j <esc><m-j>a

" Alt-k: Move current line down
imap k <esc><m-k>a

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
" Space-[jk] scrolls the page
call submode#enter_with('scroll', 'n', '', '<space>j', ':call smooth_scroll#down(&scroll/2, 5, 1)<CR>')
call submode#enter_with('scroll', 'n', '', '<space>k', ':call smooth_scroll#up(&scroll/2, 5, 1)<CR>')
call submode#map('scroll', 'n', '', 'j', ':call smooth_scroll#down(&scroll/2, 5, 1)<CR>')
call submode#map('scroll', 'n', '', 'k', ':call smooth_scroll#up(&scroll/2, 5, 1)<CR>')

" Don't leave submode automatically
let g:submode_timeout = 0

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
" e: Move to end of word
" f: Find. Also support repeating with .
nnoremap <Plug>OriginalSemicolon ;
nnoremap <silent> f :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>f
nnoremap <silent> t :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>t
nnoremap <silent> F :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>F
nnoremap <silent> T :<C-u>call repeat#set("\<lt>Plug>OriginalSemicolon")<CR>T
" g: Many functions
" gp to visually select pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" h: Left
" i: Insert before cursor
" j: Down
" k: Up
" l: Right
" m: Marks
" n: Next, keep search matches in the middle of the window
nnoremap n nzzzv
" o: Insert line below cursor
" p: Paste
nnoremap p gp
" q: Record macros
" r: Replace single character
" s: Substitute
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

" Enter: Highlight cursor location
nnoremap <silent> <cr> :call CursorPing()<CR>

" Tab: Go to matching element
nnoremap <Tab> %

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

" Tab: Indent
xmap <Tab> >

" shift-tab: unindent
xmap <s-tab> <

"===============================================================================
" Autocommands
"===============================================================================

function! CursorPing()
    set cursorline cursorcolumn
    redraw
    sleep 200m
    set nocursorline nocursorcolumn
endfunction

" q quits in certain page types. Don't map esc, that interferes with mouse input
autocmd MyAutoCmd FileType help,quickrun
      \ if (!&modifiable || &ft==#'quickrun') |
      \ nnoremap <silent> <buffer> q :q<cr>|
      \ nnoremap <silent> <buffer> <esc><esc> :q<cr>|
      \ endif
autocmd MyAutoCmd FileType qf nnoremap <silent> <buffer> q :q<CR>

" json = javascript syntax highlight
autocmd MyAutoCmd FileType json setlocal syntax=javascript

" Enable omni completion
augroup MyAutoCmd
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

"===============================================================================
" NERDTree
"===============================================================================

let NERDTreeShowBookmarks=1
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
" Close vim if the only window open is nerdtree
autocmd MyAutoCmd BufEnter *
      \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"===============================================================================
" NERDCommenter
"===============================================================================

" Always leave a space between the comment character and the comment
let NERDSpaceDelims=1

"===============================================================================
" Ag
"===============================================================================

nmap <leader>aa <Esc>:Ag 
nmap <leader>ac <Esc>:Ag "class 
nmap <leader>an <Esc>:Ag "__name__ = '
nmap <leader>ad <Esc>:Ag "def 
nmap <leader>ax <Esc>:Ag -G xml 
nmap <leader>afm <Esc>:Ag "^ *[a-zA-Z_]* = fields\.Many2One\([\n ]*'
nmap <leader>afo <Esc>:Ag "^ *[a-zA-Z_]* = fields\.One2Many\([\n ]*'
nmap <leader>agg <Esc>:Ag -G coopbusiness 
nmap <leader>agn <Esc>:Ag -G coopbusiness "__name__ = '
nmap <leader>agc <Esc>:Ag -G coopbusiness "class 
nmap <leader>agd <Esc>:Ag -G coopbusiness "def 
nmap <leader>agx <Esc>:Ag -G coopbusiness.*xml 
nmap <leader>agfm <Esc>:Ag -G coopbusiness "^ *[a-zA-Z_]* = (fields\.Function\()?[\n ]*fields\.Many2One\([\n ]*'
nmap <leader>agfo <Esc>:Ag -G coopbusiness "^ *[a-zA-Z_]* = (fields\.Function\()?[\n ]*fields\.One2Many\([\n ]*'

"===============================================================================
" Syntastic
"===============================================================================

let g:syntastic_enable_balloons = 0
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_jump = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_error_symbol='!'
let g:syntastic_style_error_symbol='>'
let g:syntastic_warning_symbol='.'
let g:syntastic_style_warning_symbol='>'
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['python'],
                           \ 'passive_filetypes': [] }
let g:syntastic_python_flake8_post_args='--ignore=E123,E124,E126,E128,E711,W404,F403'

"===============================================================================
" EasyMotion
"===============================================================================

" Tweak the colors
hi link EasyMotionTarget WarningMsg
hi link EasyMotionShade  Comment

let g:EasyMotion_do_mapping = 0
nnoremap <silent> <C-f>f :call EasyMotion#F(0, 0)<CR>
nnoremap <silent> <C-f><C-f> :call EasyMotion#F(0, 1)<CR>
nnoremap <silent> <C-f>t :call EasyMotion#T(0, 0)<CR>
nnoremap <silent> <C-f><C-t> :call EasyMotion#T(0, 1)<CR>
nnoremap <silent> <C-f> :call EasyMotion#F(0, 0)<CR>
nnoremap <silent> <C-t> :call EasyMotion#T(0, 0)<CR>

"===============================================================================
" Neocomplete
"===============================================================================

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()

" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif




" let g:acp_enableAtStartup=0
" let g:neocomplete#enable_at_startup = 1
" let g:neocomplcache_enable_at_startup = 0
" let g:neocomplcache_enable_smart_case = 1
" let g:neocomplcache_enable_camel_case_completion = 1
" let g:neocomplcache_enable_underbar_completion = 1
" let g:neocomplcache_min_syntax_length = 2
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_enable_auto_select = 1
" let g:snips_author = "Jean Cavallo"
" let g:neocomplcache_max_list=10

" " Enter always performs a literal enter
" imap <expr><cr> neocomplete#smart_close_popup() . "\<CR>"

"===============================================================================
" NeoSnippets
"===============================================================================

" " Plugin key-mappings.
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)

" " SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: "\<TAB>"

" " For snippet_complete marker.
" if has('conceal')
  " set conceallevel=2 concealcursor=i
" endif

" let g:neosnippet#enable_snipmate_compatibility=0
" let g:neosnippet#snippets_directory='~/.vim/bundle/tryton-vim/snippets'

"===============================================================================
" YCM
"===============================================================================

" let g:ycm_confirm_extra_conf = 0
" let g:EclimCompletionMethod = 'omnifunc'
" let g:ycm_filetype_blacklist = {
      " \ 'notes' : 1,
      " \ 'markdown' : 1,
      " \ 'text' : 1,
      " \ 'unite' : 1
      " \}

"===============================================================================
" UltiSnips
"===============================================================================

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"===============================================================================
" UltiSnips + YCM
"===============================================================================

" function! g:UltiSnips_Complete()
    " call UltiSnips_ExpandSnippet()
    " if g:ulti_expand_res == 0
        " if pumvisible()
            " return "\<C-n>"
        " else
            " call UltiSnips_JumpForwards()
            " if g:ulti_jump_forwards_res == 0
               " return "\<TAB>"
            " endif
        " endif
    " endif
    " return ""
" endfunction

" au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

"===============================================================================
" Indent Guides
"===============================================================================

let g:indent_guides_color_change_percent = 20
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=18
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=52

"===============================================================================
" Vimfiler
"===============================================================================

" TODO Look into Vimfiler more
" Example at: https://github.com/hrsh7th/dotfiles/blob/master/vim/.vimrc
nnoremap <expr><F2> g:my_open_explorer_command()
function! g:my_open_explorer_command()
  return printf(":\<C-u>VimFilerBufferDir -buffer-name=%s -split -auto-cd -toggle -no-quit -winwidth=%s\<CR>",
        \ g:my_vimfiler_explorer_name,
        \ g:my_vimfiler_winwidth)
endfunction

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_marked_file_icon = '✓'
let g:my_vimfiler_explorer_name = 'explorer'
let g:my_vimfiler_winwidth = 30
let g:vimfiler_safe_mode_by_default = 0

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
  nmap     <buffer><expr><CR>  vimfiler#smart_cursor_map("\<PLUG>(vimfiler_expand_tree)", "e")
endfunction

"===============================================================================
" VimShell
"===============================================================================

let g:vimshell_prompt = "% "
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings()
  call vimshell#altercmd#define('g', 'git')
  inoremap <C-x> <Esc><C-w>w
  set wrap
endfunction

"===============================================================================
" QuickRun
"===============================================================================

let g:quickrun_config = {}
let g:quickrun_config['*'] = {
      \ 'runner/vimproc/updatetime' : 100,
      \ 'outputter' : 'buffer',
      \ 'runner' : 'vimproc',
      \ 'running_mark' : 'ﾊﾞﾝ（∩`･ω･）ﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾞﾝ',
      \ 'into' : 1,
      \ 'runmode' : 'async:remote:vimproc'
      \}
" QuickRun triggers markdown preview
let g:quickrun_config.markdown = {
      \ 'runner': 'vimscript',
      \ 'command': ':InstantMarkdownPreview',
      \ 'exec': '%C',
      \ 'outputter': 'null'
      \}

"===============================================================================
" ScratchBuffer
"===============================================================================

autocmd MyAutoCmd User PluginScratchInitializeAfter
\ call s:on_User_plugin_scratch_initialize_after()

function! s:on_User_plugin_scratch_initialize_after()
  map <buffer> <CR>  <Plug>(scratch-evaluate!)
endfunction
let g:scratch_show_command = 'hide buffer'

"===============================================================================
" Expand Region
"===============================================================================

let g:expand_region_use_select_mode = 1
"
" Extend the global dictionary
call expand_region#custom_text_objects({
      \ 'a]'  :1,
      \ 'ab'  :1,
      \ 'aB'  :1,
      \ 'ii'  :0,
      \ 'ai'  :0,
      \ })

"===============================================================================
" Airline
"===============================================================================

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_mode_map = {'n': 'NOR', 'i': 'INS', 'R': 'REP'}

"===============================================================================
" Unite
"===============================================================================

" Use the fuzzy matcher for everything
call unite#filters#matcher_default#use(['matcher_fuzzy'])

" Use the rank sorter for everything
call unite#filters#sorter_default#use(['sorter_rank'])

" Set up some custom ignores
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ '\.hg/',
      \ 'git5/.*/review/',
      \ 'tmp/',
      \ '\.orig',
      \ '\.pyc'
      \ ], '\|'))

" Map space to the prefix for Unite
nnoremap [unite] <Nop>
nmap <space> [unite]

" General fuzzy search
nnoremap <silent> [unite]<space> :<C-u>Unite
      \ -buffer-name=files buffer file_mru bookmark file_rec/async<CR>

" Quick registers
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>

" Quick buffer and mru
nnoremap <silent> [unite]u :<C-u>Unite -buffer-name=buffers buffer file_mru<CR>

" Quick yank history
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<CR>

" Quick outline
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outline -vertical outline<CR>

" Quick sessions (projects)
nnoremap <silent> [unite]p :<C-u>Unite -buffer-name=sessions session<CR>

" Quick sources
nnoremap <silent> [unite]a :<C-u>Unite -buffer-name=sources source<CR>

" Quick snippet
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=snippets ultisnips<CR>

" Quickly switch lcd
nnoremap <silent> [unite]d
      \ :<C-u>Unite -buffer-name=change-cwd -default-action=lcd directory_mru<CR>

" Quick file search
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async file/new<CR>

" Quick grep from cwd
nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=grep grep:.<CR>

" Quick help
nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<CR>

" Quick line using the word under cursor
nnoremap <silent> [unite]l :<C-u>UniteWithCursorWord -buffer-name=search_file line<CR>

" Quick MRU search
nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=mru file_mru<CR>

" Quick find
nnoremap <silent> [unite]n :<C-u>Unite -buffer-name=find find:.<CR>

" Quick commands
nnoremap <silent> [unite]c :<C-u>Unite -buffer-name=commands command<CR>

" Quick bookmarks
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=bookmarks bookmark<CR>

" Quick commands
nnoremap <silent> [unite]; :<C-u>Unite -buffer-name=history history/command command<CR>

" Custom Unite settings
autocmd MyAutoCmd FileType unite call s:unite_settings()
function! s:unite_settings()
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <c-j> <Plug>(unite_insert_leave)
  nmap <buffer> <c-j> <Plug>(unite_loop_cursor_down)
  imap <buffer> <c-k> <Plug>(unite_insert_leave)
  nmap <buffer> <c-k> <Plug>(unite_loop_cursor_up)
  imap <buffer> <c-a> <Plug>(unite_choose_action)
  imap <buffer> <Tab> <Plug>(unite_exit_insert)
  imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> qq <Plug>(unite_exit)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_word)
  imap <buffer> <C-u> <Plug>(unite_delete_backward_path)
  imap <buffer> <C-u> <Plug>(unite_delete_backward_path)
  imap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> <C-r> <Plug>(unite_redraw)
  imap <buffer> <C-r> <Plug>(unite_redraw)
  inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
  nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
  inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')

  let unite = unite#get_current_unite()
  if unite.buffer_name =~# '^search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif
  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
endfunction

" Start in insert mode
let g:unite_enable_start_insert = 1

" Enable history yank source
let g:unite_source_history_yank_enable = 1

" Open in bottom right
let g:unite_split_rule = "botright"

let g:unite_source_file_mru_limit = 1000
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_source_rec_max_cache_files = 10000
let g:unite_matcher_fuzzy_max_input_length = 50

" For ack.
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
  let g:unite_source_grep_recursive_opt = ''
endif

"===============================================================================
" Unite Sessions
"===============================================================================

" Save session automatically.
let g:unite_source_session_enable_auto_save = 1

"===============================================================================
" XML Special bindings
"===============================================================================

nnoremap <leader>xf :%w !xmllint --noout --relaxng $VIRTUAL_ENV/tryton-workspace/trytond/trytond/ir/ui/form.rng %:p
nnoremap <leader>xt :%w !xmllint --noout --relaxng $VIRTUAL_ENV/tryton-workspace/trytond/trytond/ir/ui/tree.rng %:p
nnoremap <leader>xg :%w !xmllint --noout --relaxng $VIRTUAL_ENV/tryton-workspace/trytond/trytond/ir/ui/graph.rng %:p
nnoremap <leader>xx :silent 1,$!xmllint --format --recover - 2>/dev/null<CR>
au BufWrite xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null<CR>"
let g:xml_syntax_folding=1
au FileType xml set shiftwidth=2
au FileType xml setlocal foldmethod=syntax
au FileType xml setlocal foldlevel=2

"===============================================================================
" My functions
"===============================================================================

" Fold on one line
fu! CustomFoldText()
    "get first non-blank line
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif

    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = " " . foldSize . " lines "
    let foldLevelStr = repeat("+--", v:foldlevel)
    let lineCount = line("$")
    let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
    let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf

set foldtext:CustomFoldText()

" Use F7/Shift-F7 to add/remove a breakpoint (pdb.set_trace)
" Totally cool.
python << EOF
import vim
def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
       '%(space)svimpdb.set_trace()  %(mark)s Breakpoint %(mark)s' %
         {'space':strWhite, 'mark': '# #######'}, nLine - 1)

    for strLine in vim.current.buffer:
        if strLine == 'import vimpdb':
            break
    else:
        vim.current.buffer.append( 'import vimpdb', 0)
        vim.command( 'normal j1')

vim.command( 'map <f7> :py SetBreakpoint()<cr>')

def RemoveBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == 'import vimpdb' or strLine.lstrip()[:18] == 'vimpdb.set_trace()':
            nLines.append( nLine)
        nLine += 1

    nLines.reverse(t)

    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( 'normal %dG' % nCurrentLine)

vim.command( 'map <s-f7> :py RemoveBreakpoints()<cr>')
EOF
