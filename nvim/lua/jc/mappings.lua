-----------
-- Utils --
-----------

local function t(str)
  -- Necessary so that C-X sequences are properly sent
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function map_buf(lhs, rhs)
  vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {noremap = true, silent = true})
end

local function map(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = true})
end

local function remap(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = false, silent = true})
end

local function map_noisy(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, {noremap = true, silent = false})
end

local function imap(lhs, rhs)
  vim.api.nvim_set_keymap('i', lhs, rhs, {noremap = true, silent = true})
end

local function cmap(lhs, rhs)
  vim.api.nvim_set_keymap('c', lhs, rhs, {noremap = true, silent = true})
end

local function vmap(lhs, rhs)
  vim.api.nvim_set_keymap('x', lhs, rhs, {noremap = true, silent = true})
end

local function revmap(lhs, rhs)
  vim.api.nvim_set_keymap('x', lhs, rhs, {noremap = false, silent = true})
end

---------------------------
-- Function Key Mappings --
---------------------------

map('<F1>', '<cmd>Telescope help_tags<CR>')
map('<F3>', '<cmd>MundoToggle<CR>')
map('<F4>', '<cmd>Goyo<CR>')
map('<F5>', '<cmd>set paste!<CR>')
map('<F8>', '<cmd>call SideKickNoReload()<CR>')

-- Fun shortcut to check color group under cursor
map('<F10>', '<cmd>echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .'
  .. '"> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"'
  .. '. synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>')

--------------------------
-- Normal Mode Mappings --
--------------------------
remap('b', '<Plug>(easymotion-linebackward)')
map('B', 'b')

-- Do not overwrite the yank register when "c-ing"
map('c', '"_c')
map('C', '"_C')

-- Quick edit of top of file
map('gt', ':rightbelow 15split<CR>:set winfixheight<CR>gg')

-- Select last inserted text
map('gV', '`[v`]')

-- accelerated j / k
remap('j', '<Plug>(accelerated_jk_gj)')
remap('k', '<Plug>(accelerated_jk_gk)')

-- use Q to record macros
map('Q', 'q')

-- So q is available for smart closing
map('q', '<cmd>call JCSmartClose()<CR>')

remap('w', '<Plug>(easymotion-lineforward)')
map('W', 'w')

map('zh', '[z')
map('zl', ']z')
-------------------------------
-- Normal Mode Ctrl Mappings --
-------------------------------

-- Ctrl A / X for smart increment / decrement
remap('<C-a>', '<Plug>(dial-increment)')
remap('<C-x>', '<Plug>(dial-decrement)')

-- Ctrl+j for easymotion lines
remap('<C-j>', '<Plug>(easymotion-overwin-line)')

-- H / L to go to beginning / end of line
map('H', '^')
map('L', 'g_')
map('<C-h>', '^')
map('<C-l>', 'g_')

-- u / U => undo / redo
remap('u', '<Plug>(highlightedundo-undo)')
remap('U', '<Plug>(highlightedundo-redo)')

-- Make Y behave like C / D
map('Y', 'y$')

-------------------------------
-- Normal Mode Meta Mappings --
-------------------------------

-- Pane navigation
map('<A-h>', '<cmd>TmuxNavigateLeft<CR>')
map('<A-j>', '<cmd>TmuxNavigateDown<CR>')
map('<A-k>', '<cmd>TmuxNavigateUp<CR>')
map('<A-l>', '<cmd>TmuxNavigateRight<CR>')

--------------------------
-- Insert Mode Mappings --
--------------------------

-- kj / jk to exit insert mode
imap('jk', '<Esc>')
imap('kj', '<Esc>')

-- H / L to go to beginning / end of line
imap('<C-h>', '<Esc>I')
imap('<C-l>', '<Esc>A')

-- Ctrl + v => Paste (with undo support)
imap('<C-v>', '<C-g>u<C-o>gP')

-------------------------------
-- Insert Mode Meta Mappings --
-------------------------------

-- Pane navigation
imap('<A-h>', '<Esc><Plug>TmuxNavigateLeft')
imap('<A-j>', '<Esc><Plug>TmuxNavigateDown')
imap('<A-k>', '<Esc><Plug>TmuxNavigateUp')
imap('<A-l>', '<Esc><Plug>TmuxNavigateRight')

------------------------
-- Telescope Mappings --
------------------------
TelescopeMapArgs = TelescopeMapArgs or {}
local map_tele = function(key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = "n"
  local rhs = string.format(
    "<cmd>lua require('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>",
    f, map_key)

  local map_options = { noremap = true, silent = true }

  if not buffer then
    vim.api.nvim_set_keymap(mode, '<space>' .. key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, '<space>' .. key, rhs, map_options)
  end
end

map_tele('i', "buffers")                              -- Opened buffers
map_tele('k', "jumplist")                             -- Last locations
map_tele('h', "help_tags")                            -- Help
map_tele('q', "quickfix")                             -- Quickfix

map_tele('la', "lsp_code_actions")                    -- Code actions
map_tele('ld', "lsp_definitions")                     -- Goto definitions
map_tele('lo', "lsp_document_diagnostics")            -- Diagnostics
map_tele('ls', "lsp_document_symbols")                -- Symbols
map('<space>lp', "<cmd>LspTrouble<CR>")               -- LspTrouble

map_tele('fo', "oldfiles")                            -- file history
map_tele('fd', "find_files")                          -- current directory
map_tele('fc', "files_current_buffer_directory")      -- current buffer directory
map_tele('fg', "buffer_git_files")                    -- current buffer repo
map_tele('fp', "buffer_project_files")                -- current buffer project
map_tele('fm', "buffer_tryton_module_files")           -- current buffer tryton module
map_tele('fad', "find_all_files")                     -- current directory
map_tele('fac', "all_files_current_buffer_directory") -- current buffer directory
map_tele('fap', "buffer_project_all_files")           -- current buffer project

map_tele('sgc', "git_search")                         -- Live search in git project
map_tele('sdc', "directory_search")                   -- Live search in directory
map_tele('scc', "buffer_search")                      -- Live search in current buffer
map_tele('spc', "project_search")                     -- Live search in whole folder
map_tele('smc', "tryton_module_search")               -- Live search in current tryton module

map_tele('sgw', "live_git_grep")                      -- Live search in git project
map_tele('sdw', "live_directory_grep")                -- Live search in directory
map_tele('scw', "live_buffer_grep")                   -- Live search in current buffer
map_tele('spw', "live_project_grep")                  -- Live search in whole folder
map_tele('smw', "live_tryton_module_grep")            -- Live search in current tryton module

map_tele('/', "buffer_grep")                          -- Search alternative
map_tele(':', "command_history")                      -- Command history

---------------------
-- Leader Mappings --
---------------------

-- Delete current buffer
map('<Leader>dd', '<cmd>call JCSmartWipeout()<CR>')

-- DiffGet shortcuts
map('<Leader>dgl', '<cmd>diffget LOCAL<CR>')
map('<Leader>dgr', '<cmd>diffget REMOTE<CR>')
map('<Leader>dgb', '<cmd>diffget BASE<CR>')

-- New file in current buffer folder
map_noisy('<Leader>e', ':e <C-r>=expand("%:p:h")."/"<CR>')

-- (Python) Logging tools
map('<Leader>la', '<cmd>call JCAddLogging(0)<CR>')
map('<Leader>lA', '<cmd>call JCAddLogging(-1)<CR>')
map('<Leader>lr', '<cmd>call JCRemoveLogging()<CR>')

-- Copy full path of current file to the clipboard
map('<Leader>p', ':let @+=expand("%:p")<CR>:echo "Copied current file '
  .. 'path \'".expand("%:p")."\' to the clipboard"<CR>"')

-- (Python) debugger
map('<Leader>pa', '<cmd>call JCAddBreakpoint(0)<CR>')
map('<Leader>pA', '<cmd>call JCAddBreakpoint(-1)<CR>')
map('<Leader>pr', '<cmd>call JCRemoveBreakpoint()<CR>')

-- Previous buffer
map('<Leader>m', '<cmd>e#<CR>')

-- EasyMotion prefix
remap('<Leader>,', '<Plug>(easymotion-prefix)')

--------------------
--View Navigation --
--------------------
local function map_view(key, rhs) map('s' .. key, rhs) end

map_view('', '<Nop>')
map_view('v', '<cmd>vsplit<CR>')
map_view('h', '<cmd>split<CR>')
map_view('o', '<cmd>only<CR>')    -- Close all other buffers
map_view(')', '<C-W>| <C-W>_')   -- Maximize current buffer without hiding others
map_view('=', '<C-w>=')
map_view('p', '<cmd>call JCSplitNicely()<CR>')

---------------------------
-- Command mode mappings --
---------------------------

-- Shortcut for sudo writing
cmap('w!!', 'w !sudo tee % >/dev/null')

--------------------------
-- Visual mode mappings --
--------------------------

-- p / d in visual should not end in the yank register, use "x" for cut
vmap('p', '"_dP')
vmap('d', '"_d')

-- Fix indentation behaviour in visual mode
vmap('>', '>gv')
vmap('<', '<gv')

-- Backspace deletes and enter insert mode
vmap('<bs>', 'c')

-- Repeat last command on each line
vmap('.', ':normal.<CR>')

-- Repeat last macro on each line
vmap('@', ':normal@')

-- Make sure copy copies everywhere
vmap('y', '"*y:let [@+,@"]=[@*,@*]<CR>')

-- Ctrl A / X for smart increment / decrement
revmap('<C-a>', '<Plug>(dial-increment)')
revmap('<C-x>', '<Plug>(dial-decrement)')

-------------------
-- Misc Mappings --
-------------------

remap('_', '<Plug>(operator-replace)')
map('<up>', '<C-w>+')
map('<down>', '<C-w>-')
map('<left>', '<C-w><')
map('<right>', '<C-w>>')
map('<', '<<')
map('>', '>>')
