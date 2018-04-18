"---------------------------------------------------------------------------
" View:
"---------------------------------------------------------------------------

" Show line number.
set number

" RelativeNumber makes everything horrendously slow :'(
" set relativenumber
" set cursorline

" Show <TAB> and <CR>
set list
set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%

" Disable Mode displaying (airline is here)
set noshowmode

" Text display settings
set linebreak
set textwidth=79
set autoindent

" Limit to 80 char
set colorcolumn=80

" Do not wrap long line.
set nowrap
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Always display statusline.
set laststatus=2
" Height of command line.
set cmdheight=2
" Show command on statusline.
set showcmd

set showtabline=1

" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=>\
set breakat=\ \	;:,!?([{

" Do not display greetings message at the time of Vim start.
set shortmess=aTIc

" Disable bell.
set t_vb=
set novisualbell

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=10

" How many lines to scroll at a time, make scrolling appears faster
set scrolljump=3

" Min width of the number column to the left
set numberwidth=1

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag

" Disable menu
let g:did_install_default_menus = 1

if !&verbose
  " Enable spell check.
  set spelllang=en_us
endif

" Set popup menu max height.
set pumheight=20

" Report changes.
set report=0

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=10
" Equal window size.
set equalalways

" Adjust window size of preview and help.
set previewheight=8
set helpheight=12

" Don't redraw while macro executing.
set lazyredraw
set ttyfast

" When a line is long, do not omit it in @.
set display=lastline

" View setting.
set viewdir=$CACHE/vim_view viewoptions-=options viewoptions+=slash,unix

" For conceal.
set conceallevel=2 concealcursor=iv
