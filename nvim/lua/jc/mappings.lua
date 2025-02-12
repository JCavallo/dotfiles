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

-- Clean up space
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

---------------------------
-- Function Key Mappings --
---------------------------

map('<F6>', '<cmd>Telescope help_tags<CR>')
map('<F4>', '<cmd>MundoToggle<CR>')
map('<F5>', '<cmd>set paste!<CR>')

-- Fun shortcut to check color group under cursor
map('<F9>', '<cmd>echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .'
  .. '"> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"'
  .. '. synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>')

--------------------------
-- Normal Mode Mappings --
--------------------------
-- Do not overwrite the yank register when "c-ing"
map('c', '"_c')
map('C', '"_C')

-- Select last inserted text
map('gV', '`[v`]')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ThePrimeAgen remaps for centering when jumping around
map('n', 'nzzzv')
map('N', 'Nzzzv')

-- use Q to record macros
map('Q', 'q')

-- So q is available for smart closing
map('q', '<cmd>call JCSmartClose()<CR>')

map('zh', '[z')
map('zl', ']z')

-------------------------------
-- Normal Mode Ctrl Mappings --
-------------------------------
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
map('<A-Left>', '<cmd>TmuxNavigateLeft<CR>')
map('<A-Down>', '<cmd>TmuxNavigateDown<CR>')
map('<A-Up>', '<cmd>TmuxNavigateUp<CR>')
map('<A-Right>', '<cmd>TmuxNavigateRight<CR>')

--------------------------
-- Insert Mode Mappings --
--------------------------

-- Another exit way
imap('<C-c>', '<Esc>')

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
imap('<A-h>', '<cmd>TmuxNavigateLeft<CR>')
imap('<A-j>', '<cmd>TmuxNavigateDown<CR>')
imap('<A-k>', '<cmd>TmuxNavigateUp<CR>')
imap('<A-l>', '<cmd>TmuxNavigateRight<CR>')

----------------------
-- Harpoon Mappings --
----------------------

map('<C-F1>', ':lua require("harpoon.ui").nav_file(1)<CR>')
map('<C-F2>', ':lua require("harpoon.ui").nav_file(2)<CR>')
map('<C-F3>', ':lua require("harpoon.ui").nav_file(3)<CR>')
map('<C-F4>', ':lua require("harpoon.ui").nav_file(4)<CR>')
map('<space>hn', ':lua require("harpoon.ui").nav_next()<CR>')
map('<space>hp', ':lua require("harpoon.ui").nav_prev()<CR>')
map('<space>ha', ':lua require("harpoon.mark").add_file()<CR>')
map('<space>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>')

------------------------
-- Telescope Mappings --
------------------------
TelescopeMapArgs = TelescopeMapArgs or {}
local map_tele = function(key, f, options, buffer, no_prefix)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local mode = "n"
  local rhs = string.format(
    "<cmd>lua require('jc.telescope')['%s'](TelescopeMapArgs['%s'])<CR>",
    f, map_key)

  local mapping
  if no_prefix then
    mapping = key
  else
    mapping = '<space>' .. key
  end
  local map_options = { noremap = true, silent = true }
  if not buffer then
    vim.api.nvim_set_keymap(mode, mapping, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, mapping, rhs, map_options)
  end
end

map_tele('i', "buffers")                              -- Opened buffers
map_tele('q', "quickfix")                             -- Quickfix
map_tele('n', "resume")                               -- Resume

map_tele('ld', "lsp_definitions")                     -- Goto definitions
map_tele('li', "lsp_implementations")                 -- Goto implementations
map_tele('lo', "diagnostics", {
  bufnr = 0,
  layout_strategy = "vertical",
  layout_config = { width = 0.90 },
})            -- Diagnostics
map_tele('ls', "lsp_document_symbols", {
  symbols = { "method", "class", "field", "function" },
})                -- Symbols
map_tele('lr', "lsp_references")                      -- References to current symbol
map_tele('lta', "force_refresh_treesitter")                         -- All symbols
map_tele('<F1>', "force_refresh_treesitter",
  { symbols = { 'type' } },
  false, true)
map_tele('ltf', "force_refresh_treesitter",
  { symbols = { 'function' } })
map_tele('<F2>', "treesitter_siblings",
  { parent = 'class_definition',
    targets = {
      block = {
        function_definition = { "identifier" },
        decorated_definition = {
          function_definition = { "identifier" }
        }
      }
    }
  },
  false, true)
map_tele('<F3>', "treesitter_siblings",
  { parent = 'class_definition',
    targets = {
      block = {
        expression_statement = { assignment = { "identifier" }}
      }
    }
  },
  false, true)

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

map_tele('sdtm', "tryton_model_directory_grep")
map_tele('sdtcm', "tryton_model_directory_grep", { current = true })
map_tele('sdtf', "tryton_field_directory_grep")
map_tele('smtm', "tryton_model_module_grep")
map_tele('smtcm', "tryton_model_module_grep", { current = true })
map_tele('smtf', "tryton_field_module_grep")
map_tele('sgtm', "tryton_model_git_grep")
map_tele('sgtcm', "tryton_model_git_grep", { current = true })
map_tele('sgtf', "tryton_field_git_grep")
map_tele('sptm', "tryton_model_project_grep")
map_tele('sptcm', "tryton_model_project_grep", { current = true })
map_tele('<F8>', "tryton_model_project_grep", { current = true }, false, true)
map_tele('sptf', "tryton_field_project_grep")

map_tele('sgw', "live_git_grep")                      -- Live search in git project
map_tele('sdw', "live_directory_grep")                -- Live search in directory
map_tele('scw', "live_buffer_grep")                   -- Live search in current buffer
map_tele('spw', "live_project_grep")                  -- Live search in whole folder
map_tele('smw', "live_tryton_module_grep")            -- Live search in current tryton module

map_tele('/', "buffer_grep")                          -- Search alternative
map_tele(':', "command_history")                      -- Command history

-------------------
-- Octo Mappings --
-------------------

map('<space>oa', ':Octo actions<CR>')
map('<space>opl', ':Octo pr list<CR>')
map('<space>opc', ':Octo pr changes<CR>')
map('<space>opb', ':Octo pr browser<CR>')
map('<space>orr', ':Octo review start<CR>')
map('<space>ors', ':Octo review submit<CR>')

-------------------------
-- Telekasten Mappings --
-------------------------

map('<space>kl', ':Telekasten panel<CR>')
map('<space>kt', ':Telekasten goto_today<CR>')
map('<space>ks', ':Telekasten search_notes<CR>')
map('<space>kn', ':Telekasten new_note<CR>')

---------------------
-- Leader Mappings --
---------------------

-- Delete current buffer
map('<Leader>bd', '<cmd>call JCSmartWipeout()<CR>')

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
map('<Leader>pd', '<cmd>call JCAddBreakpointV2(0)<CR>')
map('<Leader>pD', '<cmd>call JCAddBreakpointV2(-1)<CR>')
map('<Leader>pr', '<cmd>call JCRemoveBreakpoint()<CR>')

-- Previous buffer
map('<Leader>m', '<cmd>e#<CR>')

--------------------
--View Navigation --
--------------------
local function map_view(key, rhs) map('<C-w>' .. key, rhs) end

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

-------------------
-- Misc Mappings --
-------------------

remap('_', '<Plug>(operator-replace)')
--map('<up>', '<C-w>+')
--map('<down>', '<C-w>-')
--map('<left>', '<C-w><')
--map('<right>', '<C-w>>')
map('<', '<<')
map('>', '>>')
