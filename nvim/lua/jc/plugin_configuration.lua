local M = {}

function M.completion()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-PageUp>'] = cmp.mapping.scroll_docs(-4),
      ['<C-PageDown>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<C-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }
  })
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

function M.flit()
  require('flit').setup()
end

function M.floaterm()
  vim.g.floaterm_width = 0.8
  vim.g.floaterm_height = 0.8
  vim.g.floaterm_keymap_new = '<F7>'
  vim.g.floaterm_keymap_toggle = '<F12>'
end

function M.gitsigns()
  require'gitsigns'.setup{
    current_line_blame = true
  }
  vim.cmd[[highlight GitSignsCurrentLineBlame guifg=#666677 cterm=italic gui=italic]]
end

function M.indent_lines()
  require('indent_blankline').setup({
    show_current_context = true,
    show_current_context_start = true,
    show_trailing_blankline_indent = false,
  })
end

function M.leap()
  require('leap').add_default_mappings()
end

function M.localvimrc()
  vim.g.localvimrc_persistent = 1
end

function M.lualine()
  require('lualine').setup {
    options = {
      theme = 'auto',
      icons_enabled = true,
      section_separators = { left='', right='' },
      component_separators = { left='', right='' },
      padding = 1,
      disabled_filetypes = {},
      globalstatus = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch'},
      lualine_c = { {'filename', file_status = true} },
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {
        {'diagnostics',
          sources = { 'nvim_diagnostic' },
          color_error = '#FF0000',
          color_warn = '#FFC600',
          color_info = '#00AAFF',
        },
        'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = { {'filename', path = 1} },
      lualine_c = {},
      lualine_x = {'location'},
      lualine_y = {'filetype'},
      lualine_z = {}
    },
    tabline = {
      lualine_a = { {'filename', file_status = true, path = 2} },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    extensions = {}
  }
end

function M.neorg()
  require('neorg').setup({
    load = {
      ["core.defaults"] = {},
      ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
      ["core.concealer"] = {},
      ["core.export"] = {},
      ["core.keybinds"] = {
        -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
        config = {
          default_keybinds = true,
          neorg_leader = "<Leader><Leader>",
        },
      },
      ["core.integrations.telescope"] = {},
      ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
      ["core.qol.toc"] = {},
      ["core.qol.todo_items"] = {},
      ["core.looking-glass"] = {},
      ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
      ["core.journal"] = {
        config = {
          strategy = "flat",
          workspace = "Notes",
        },
      },
      -- ["core.dirman"] = {
      --   config = {
      --     workspaces = {
      --       Notes = "~/Nextcloud/Notes",
      --       Work = "~/Nextcloud/Work",
      --     }
      --   }
      -- },
    }
  })
end

function M.noice()
  require('noice').setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    mini = {
      win_options = {
        winblend = 0
      }
    },
    views = {
      mini = {
        winhighlight = {},
      },
    },
  })
end

function M.notify()
  require('notify').setup({
    background_colour = '#000000',
  })
end

function M.onedark()
  if vim.g.my_colorscheme == "onedark" then
    require('onedark').setup({
      dark_float = true,
      highlight_linenumber = true,
      --transparent = true,
      overrides = function()
        return {
          Folded = {fg = "#888888", bg = "#333333"},
        }
      end
    })
  end
end

function M.setup_lsp()
  require('neodev').setup({})

  local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      '[W]orkspace [L]ist Folders')
    nmap('<leader>xx', vim.lsp.buf.format())

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end

  local servers = {
    -- clangd = {},
    -- gopls = {},
    pylsp = {
      pylsp = {
        plugins = {
          pyls_mpypy = {enabled = true},
          flake8 = { enabled = true },
        }
      }
    },
    rust_analyzer = {},
    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Setup mason so it can manage external tooling
  require('mason').setup()

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }

  local lspconfig = require("lspconfig")
  local configs = require'lspconfig.configs'
  if not configs.tryton_analyzer then
    configs.tryton_analyzer = {
      default_config = {
        cmd = { vim.fn.expand('~/Personal/projects/coog/tryton-analyzer/launcher') },
        filetypes = {'python.trpy', 'xml.trxml'},
        root_dir = lspconfig.util.root_pattern(".git"),
        settings = {},
      };
    }
  end
  lspconfig.tryton_analyzer.setup{}
end

function M.setup_dap()
  -- local function configure()
  --   local dap_install = require "dap-install"
  --   dap_install.setup {
  --     installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
  --   }
  --
  --   local dap_breakpoint = {
  --     error = {
  --       text = "🟥",
  --       texthl = "LspDiagnosticsSignError",
  --       linehl = "",
  --       numhl = "",
  --     },
  --     rejected = {
  --       text = "",
  --       texthl = "LspDiagnosticsSignHint",
  --       linehl = "",
  --       numhl = "",
  --     },
  --     stopped = {
  --       text = "⭐️",
  --       texthl = "LspDiagnosticsSignInformation",
  --       linehl = "DiagnosticUnderlineInfo",
  --       numhl = "LspDiagnosticsSignInformation",
  --     },
  --   }
  --
  --   vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
  --   vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  --   vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
  -- end
  --
  -- local function configure_exts()
  --   require("nvim-dap-virtual-text").setup {
  --     commented = true,
  --   }
  --
  --   local dap, dapui = require "dap", require "dapui"
  --   dapui.setup {} -- use default
  --   dap.listeners.after.event_initialized["dapui_config"] = function()
  --     dapui.open()
  --   end
  --   dap.listeners.before.event_terminated["dapui_config"] = function()
  --     dapui.close()
  --   end
  --   dap.listeners.before.event_exited["dapui_config"] = function()
  --     dapui.close()
  --   end
  -- end
  --
  -- local function configure_debuggers()
  --   --require("config.dap.lua").setup()
  --   --require("config.dap.python").setup()
  --   require("dap-python").setup("python", {})
  --   table.insert(require('dap').configurations.python, {
  --     justMyCode = true
  --   })
  --   --require("config.dap.rust").setup()
  -- end
  --
  -- local function configure_mappings()
  --   local whichkey = require "which-key"
  --   local keymap = {
  --     d = {
  --       name = "Debug",
  --       R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
  --       E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
  --       C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
  --       U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
  --       b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
  --       c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  --       d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
  --       e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
  --       f = { "<cmd>Telescope dap frames<cr>", "Frames" },
  --       g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
  --       h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
  --       S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
  --       i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
  --       o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
  --       p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
  --       q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
  --       r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
  --       s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
  --       t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
  --       x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
  --       u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  --     },
  --   }
  --
  --   whichkey.register(keymap, {
  --     mode = "n",
  --     prefix = "<leader>",
  --     buffer = nil,
  --     silent = true,
  --     noremap = true,
  --     nowait = false,
  --   })
  --
  --   local keymap_v = {
  --     name = "Debug",
  --     e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
  --   }
  --
  --   whichkey.register(keymap_v, {
  --     mode = "v",
  --     prefix = "<leader>",
  --     buffer = nil,
  --     silent = true,
  --     noremap = true,
  --     nowait = false,
  --   })
  -- end
  --
  -- configure() -- Configuration
  -- configure_exts() -- Extensions
  -- configure_debuggers() -- Debugger
  -- configure_mappings() -- Mappings
end

function M.spooky()
  require('leap-spooky').setup({
    paste_on_remote_yank = false,
  })
end

function M.startify()
  vim.g.startify_change_to_dir = 0
  vim.g.startify_change_to_vcs_root = 1
end

function M.suda()
  vim.g.suda_smart_edit = 1
end

function M.telescope()
  local actions = require('telescope.actions')
  require('telescope').setup{
    defaults = {
      layout_strategy = 'flex',
      prompt_prefix = '❯ ',
      selection_caret = '❯ ',
      winblend = 10,
      color_devicons = true,
      use_less = true,
      sorting_strategy = "ascending",
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      mappings = {
        n = {
          ["q"] = actions.close,
          ["<M-a>"] = actions.smart_add_to_qflist,
          ["<M-q>"] = actions.smart_send_to_qflist
        },
        i = {
          ["<M-a>"] = actions.smart_add_to_qflist,
          ["<M-q>"] = actions.smart_send_to_qflist
        }
      },
      extensions = {
        fzf_native = {
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        fzf_writer = {
          use_highlighter = false,
          minimum_grep_characters = 3,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    }
  }
  -- require('telescope').load_extension('fzf')
  -- require('telescope').load_extension('dap')
  require("telescope").load_extension("notify")
  require("telescope").load_extension("ui-select")
  require("telescope").load_extension("floaterm")
end

function M.tender()
  vim.g.tender_italic = 1
  vim.g.tender_bold = 1
end

function M.tmux_navigator()
  vim.g.tmux_navigator_no_mappings = 1
end

function M.tokyonight()
  require('tokyonight').setup({
    style = "storm",
    transparent = true,
  })
  vim.cmd("colorscheme tokyonight")
end

function M.treesitter()
  require('nvim-treesitter.configs').setup {
    ensure_installed = 'all',
    highlight = {
      enable = true, -- false will disable the whole extension
    },
    autotag = {  -- Auto close tags
      enable = true,
      filetypes = {'html', 'xml'},
    },
    incremental_selection = {
      enable = true,
      keymaps = { -- mappings for incremental selection (visual mappings)
        init_selection = '<M-w>',    -- maps in normal mode to init the node/scope selection
        node_incremental = '<M-w>',  -- increment to the upper named parent
        scope_incremental = '<M-e>', -- increment to the upper scope (as defined in locals.scm)
        node_decremental = '<M-C-w>',  -- decrement to the previous node
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@conditional.outer',
          ['ic'] = '@conditional.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
        },
      },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']{'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']}'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[{'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[}'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
    playground = {
      enable = true
    },
  }
  -- nvim ufo for folding now...
  -- vim.o.foldmethod = 'expr'
  -- vim.cmd[[set foldexpr=nvim_treesitter#foldexpr()]]
end

function M.trouble()
  require('trouble').setup {
    position = 'right',
    auto_close = true,
    auto_preview = false,
    auto_fold = false,
  }
end

function M.ufo()
  local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    if curWidth < targetWidth then
        suffix = (' '):rep(targetWidth - curWidth) .. suffix
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
  end
  require('ufo').setup({
    fold_virt_text_handler = handler,
    provider_selector = function(bufnr, filetype, buftype)
      if filetype == 'python' or filetype == 'lua' then
        return { 'treesitter', 'indent' }
      end
      return { 'lsp', 'indent' }
    end
  })
  vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
  vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
end

return M
