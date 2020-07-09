" dein configurations.
let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
if $FORCE_VIM_CACHE != ''
    let s:vim_base_cache = $FORCE_VIM_CACHE
else
    let s:vim_base_cache = expand('$HOME') . (has('unix') ? '/.cache' : '\.cache')
endif
if !isdirectory(expand(s:vim_base_cache))
    call mkdir(expand(s:vim_base_cache), 'p')
endif

let s:dein_folder = expand(s:vim_base_cache . 'dein/')
let s:dein_path = expand(s:dein_folder . 'repos/github.com/Shougo/dein.vim')
if !isdirectory(s:dein_path)
  if executable('git') && confirm('Install dein.vim or Launch vim immediately', "&Yes\n&No", 1)
    execute '!git clone --depth=1 https://github.com/Shougo/dein.vim' s:dein_path
  endif
endif

let &runtimepath .= ',' . s:dein_path
let g:dein#install_max_processes = 20
let g:dein#install_process_timeout = 300
let g:dein#install_progress_type = 'echo'
let g:dein#enable_notification = 1
let g:dein#install_log_filename = '/tmp/dein.log'

let s:dein_toml = s:path . '/dein.toml'
let s:dein_lazy_toml = s:path . '/dein_lazy.toml'
let s:dein_ft_toml = s:path . '/dein_ft.toml'

if dein#load_state(s:dein_folder)
    call dein#begin(s:dein_folder)

    call dein#load_toml(s:dein_toml, {'lazy': 0})
    " call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
    call dein#load_toml(s:dein_ft_toml)

    " Finalize
    call dein#end()
    call dein#save_state()
endif

" Actually install everything
if dein#check_install() && confirm(
        \ 'Would you like to download missing plugins ?', "&Yes\n&No", 1)
    call dein#install()
    call dein#remote_plugins()
endif

if has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')
endif

finish
