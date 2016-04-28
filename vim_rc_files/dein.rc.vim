" dein configurations.

let g:dein#install_progress_type = 'echo'
let g:dein#install_message_type = 'echo'
let g:dein#enable_notification = 1
let g:dein#notification_icon = expand($VIM_FOLDER . '/rc/signs/warn.png')

let s:path = expand($CACHE . '/dein')
" if !dein#load_state(s:path)
"     finish
" endif

call dein#begin(s:path, [expand('<sfile>')]
    \ + split(glob(expand($VIM_FOLDER) . '/rc/*.toml'), '\n'))

call dein#load_toml(expand($VIM_FOLDER) . '/rc/dein.toml', {'lazy': 0})
call dein#load_toml(expand($VIM_FOLDER) . '/rc/deinlazy.toml', {'lazy' : 1})
call dein#load_toml(expand($VIM_FOLDER) . '/rc/deineo.toml', {})
call dein#load_toml(expand($VIM_FOLDER) . '/rc/deinft.toml')

call dein#end()
" call dein#save_state()

if !has('vim_starting') && dein#check_install()
    " Installation check.
    call dein#install()
endif
