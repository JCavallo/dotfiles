-- Vimscript functions that need converting
vim.cmd([[
function! JCAddLogging(delta)
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    let cur_pos = getpos('.')
    let [head_num, head_col] = searchpos('^import logging as tmp_logging;import pprint as tmp_pprint  # NVAUTOLOG', 'nb')
    if head_num == 0 && head_col == 0
        call setpos('.', [0, 0, 1, 0])
        call search('^[^#]')
        call append(getpos('.')[2] + 1, 'import logging as tmp_logging;import pprint as tmp_pprint  # NVAUTOLOG')
        call append(getpos('.')[2] + 2, 'def _print(*x):  # NVAUTOLOG')
        call append(getpos('.')[2] + 3, "    for _line in tmp_pprint.pformat(x, indent=1, width=130).split('\\n'):  # NVAUTOLOG")
        call append(getpos('.')[2] + 4, "        tmp_logging.getLogger('root').critical(_line)  # NVAUTOLOG")
        let cur_pos[1] += 4
        call setpos('.', cur_pos)
    endif
    let cur_pos[2] = 1
    call setpos('.', cur_pos)
    execute(':normal ^')
    let indent = getpos('.')[2] - 1
    call append(cur_pos[1] + a:delta, "_print()  # NVAUTOLOG")
    let cur_pos[1] += 1 + a:delta
    let cur_pos[2] = 8 + indent
    call setpos('.', cur_pos)
    execute(':normal I' . repeat(' ', indent))
    call setpos('.', cur_pos)
    startinsert
endfunction

function! JCRemoveLogging()
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    execute('g/# NVAUTOLOG/d')
endfunction

function! JCAddBreakpointV2(delta)
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    let cur_pos = getpos('.')
    let [head_num, head_col] = searchpos('^.*# NVDEBUGGER # NOQA', 'nb')
    if head_num == 0 && head_col == 0
        call setpos('.', [0, 0, 1, 0])
        call search('^[^#]')
        let command = 'exec("""import sys\nif "debugpy" not in sys.modules:\n    import debugpy\n    debugpy.listen(5678)\n    import pynvim\n    pynvim.attach("socket", path="' .. v:servername .. '").command("' .. "lua require('dap').run({host = '127.0.0.1', port = 5678, type = 'python', request = 'attach'})" .. '")\n    debugpy.wait_for_client()\n    import os;os.system(''jcnotify "debugger started"'')""")  # NVDEBUGGER # NOQA'
        call append(getpos('.')[2] + 1, command)
        let cur_pos[1] += 1
        call setpos('.', cur_pos)
    endif
    execute(":lua require('dap').set_breakpoint()")
endfunction

function! JCAddBreakpoint(delta)
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    let cur_pos = getpos('.')
    let [head_num, head_col] = searchpos('^from pudb.remote import set_trace as tmp_set_trace  # NVDEBUGGER', 'nb')
    if head_num == 0 && head_col == 0
        call setpos('.', [0, 0, 1, 0])
        call search('^[^#]')
        call append(getpos('.')[2] + 1, 'from pudb.remote import set_trace as tmp_set_trace  # NVDEBUGGER')
        call append(getpos('.')[2] + 2, 'def _pudb_trace():  # NVDEBUGGER')
        call append(getpos('.')[2] + 3, "    import os;os.system('jcnotify \"debugger started\"')  # NVDEBUGGER")
        call append(getpos('.')[2] + 4, "    tmp_set_trace(term_size=(200, " . winheight(0) . "), port=6899)  # NVDEBUGGER")
        let cur_pos[1] += 4
        call setpos('.', cur_pos)
    endif
    let cur_pos[2] = 1
    call setpos('.', cur_pos)
    execute(':normal ^')
    let indent = getpos('.')[2] - 1
    call append(cur_pos[1] + a:delta, "_pudb_trace()  # NVDEBUGGER")
    let cur_pos[1] += 1 + a:delta
    call setpos('.', cur_pos)
    execute(':normal I' . repeat(' ', indent))
    call setpos('.', cur_pos)
endfunction

function! JCRemoveBreakpoint()
    if &filetype != 'python' && &filetype != 'python.trpy'
        return
    endif
    execute('g/# NVDEBUGGER/d')
    execute(":lua require('dap').clear_breakpoints()")
endfunction

function! JCSmartClose()
    if winnr('$') != 1
        close
    else
        execute(':Startify')
    endif
endfunction

function! JCSmartWipeout()
    if winnr('$') != 1
        execute(':Bwipeout')
    else
        execute(':Bwipeout')
        execute(':Startify')
    endif
endfunction

function! JCSplitNicely()
    if winwidth(0) > 2 * &winwidth
        vsplit
    else
        split
    endif
    wincmd p
endfunction

function! JCCreateFolderIfNecessary(dir, force)
    if !isdirectory(a:dir) && &l:buftype == '' && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction
]])
