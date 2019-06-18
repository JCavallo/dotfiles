" dein configurations.

let g:dein#install_progress_type = 'echo'
let g:dein#enable_notification = 1
let g:dein#install_log_filename = '/tmp/dein.log'

let s:path = expand($CACHE . '/dein')
if !dein#load_state(s:path)
    if dein#check_install()
        call dein#install()
    endif
    finish
endif

let s:dein_toml = '$VIM_FOLDER/rc/dein.toml'
let s:dein_lazy_toml = '$VIM_FOLDER/rc/dein_lazy.toml'
let s:dein_ft_toml = '$VIM_FOLDER/rc/dein_ft.toml'

call dein#begin(s:path, [
        \ expand('<sfile>'), s:dein_toml, s:dein_lazy_toml, s:dein_ft_toml
        \ ])

call dein#load_toml(s:dein_toml, {'lazy': 0})
call dein#load_toml(s:dein_lazy_toml, {'lazy' : 1})
call dein#load_toml(s:dein_ft_toml)

call dein#end()
call dein#save_state()

if dein#check_install()
    call dein#install()
endif

finish
