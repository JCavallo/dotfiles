-- vim:tabstop=2:shiftwidth=2:softtabstop=2
local M = {}

function M.tender()
  vim.g.tender_italic = 1
  vim.g.tender_bold = 1
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

function M.startify()
  vim.g.startify_change_to_dir = 0
  vim.g.startify_change_to_vcs_root = 1
end

function M.indent_lines()
  require('indent_blankline').setup({
    show_current_context = true,
    show_current_context_start = true,
  })
end

function M.suda()
  vim.g.suda_smart_edit = 1
end

function M.localvimrc()
  vim.g.localvimrc_persistent = 1
end

function M.tmux_navigator()
  vim.g.tmux_navigator_no_mappings = 1
end

function M.gitsigns()
  require'gitsigns'.setup{
    current_line_blame = true
  }
  vim.cmd[[highlight GitSignsCurrentLineBlame guifg=#666677 cterm=italic gui=italic]]
end

function M.treesitter()
  require('nvim-treesitter.configs').setup {
    ensure_installed = 'all',

    highlight = {
      enable = 'enabled', -- false will disable the whole extension
    },

    autotag = {  -- Auto close tags
      filetypes = {'html', 'javascript', 'javascriptreact', 'typescriptreact',
        'xml'},
      enable = true,
    },

    incremental_selection = {
      enable = 'enabled',
      keymaps = { -- mappings for incremental selection (visual mappings)
        init_selection = '<M-w>',    -- maps in normal mode to init the node/scope selection
        node_incremental = '<M-w>',  -- increment to the upper named parent
        scope_incremental = '<M-e>', -- increment to the upper scope (as defined in locals.scm)
        node_decremental = '<M-C-w>',  -- decrement to the previous node
      },
    },

    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gnd', -- mapping to go to definition of symbol under cursor
        list_definitions = 'gnD', -- mapping to list all definitions in current file
      },
    },

    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',

          ['ac'] = '@conditional.outer',
          ['ic'] = '@conditional.inner',

          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
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

function M.onedark()
  if vim.g.my_colorscheme == "onedark" then
    require('onedark').setup({
      dark_float = true,
      highlight_linenumber = true,
      --transparent = true,
      overrides = function(c)
        return {
          Folded = {fg = "#888888", bg = "#333333"},
        }
      end
    })
  end
end

function M.completion()
  local cmp = require 'cmp'
  local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(
        function(fallback)
          cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        end,
        { "i", "s", "c" }
      ),
      ["<S-Tab>"] = cmp.mapping(
        function(fallback)
          cmp_ultisnips_mappings.jump_backwards(fallback)
        end,
        { "i", "s", "c" }
      ),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      -- { name = 'buffer' },
      -- For luasnip user.
      -- { name = 'luasnip' },
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

function M.setup_lsp()
  -- Custom initialization function
  local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
  end

  -- Custom attach function
  local custom_attach = function(client)
    require('lsp-status').on_attach(client)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

    if client.server_capabilities.documentHighlightProvider then
      vim.cmd [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]]
    end
  end

  -- Custom capabilities
  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities,
      require('lsp-status').capabilities)
  updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
  updated_capabilities = require("cmp_nvim_lsp").update_capabilities(
    updated_capabilities)
  updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false
  updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
  updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  updated_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  local lsp_installer = require("nvim-lsp-installer").setup({
    automatic_installation = true,
  })
  local lspconfig = require("lspconfig")
  lspconfig.util.default_config = vim.tbl_extend(
    "force",
    lspconfig.util.default_config,
    {
      on_init = custom_init,
      on_attach = custom_attach,
      capabilities = updated_capabilities,
    }
  )

  lspconfig.sumneko_lua.setup({
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          -- Do not send telemetry data containing a randomized but unique identifier
          enable = false,
        }
      }
    }
  })
  lspconfig.pylsp.setup({
    pylsp = {
      plugins = {
        pyls_mpypy = {enabled = true},
        flake8 = { enabled = true },
      }
    }
  })
  lspconfig.ansiblels.setup({})
  lspconfig.bashls.setup({})
  lspconfig.dockerls.setup({})
  lspconfig.eslint.setup({})
  lspconfig.rust_analyzer.setup({})
  lspconfig.terraformls.setup({})
  lspconfig.tsserver.setup({})
  lspconfig.vimls.setup({})
  lspconfig.yamlls.setup({})
  lspconfig.clangd.setup({})

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
      signs = {
        severity_limit = "Error",
      },
      underline = {
        severity_limit = "Warning",
      },
      virtual_text = true,
    })

  --vim.fn.sign_define("LspDiagnosticsSignError", { text = "🞮", numhl = "LspDiagnosticsDefaultError" })
  --vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "🞮▲", numhl = "LspDiagnosticsDefaultWarning" })
  --vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "⁈", numhl = "LspDiagnosticsDefaultInformation" })
  --vim.fn.sign_define("LspDiagnosticsSignHint", { text = "⯁", numhl = "LspDiagnosticsDefaultHint" })

  vim.cmd[[hi LspDiagnosticsError guifg=#FF0000 guibg=NONE guisp=NONE gui=NONE cterm=bold]]
  vim.cmd[[hi LspDiagnosticsWarning guifg=#FFC600 guibg=NONE guisp=NONE gui=NONE cterm=bold]]
  vim.cmd[[hi LspDiagnosticsInformation guifg=#00AAFF guibg=NONE guisp=NONE gui=NONE cterm=NONE]]
  vim.cmd[[hi LspDiagnosticsHint guifg=#00AAFF guibg=NONE guisp=NONE gui=NONE cterm=NONE]]

  vim.cmd[[autocmd CursorHold * lua vim.diagnostic.open_float()]]
  vim.cmd[[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]
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
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('dap')
  require("telescope").load_extension("notify")
  require("telescope").load_extension("ui-select")
  require("telescope").load_extension("floaterm")
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

function M.trouble()
  require('trouble').setup {
    position = 'right',
    auto_close = true,
    auto_preview = false,
    auto_fold = false,
  }
end

function M.floaterm()
  vim.g.floaterm_width = 0.8
  vim.g.floaterm_height = 0.8
  vim.g.floaterm_keymap_new = '<F7>'
  vim.g.floaterm_keymap_toggle = '<F12>'
end

function M.lexima()
  vim.g.lexima_no_default_rules = true
  vim.cmd[[call lexima#set_default_rules()]]

  -- https://github.com/cohama/lexima.vim/issues/129
  vim.cmd[[call lexima#add_rule({'char': '"', 'at': '\%#"', 'leave': 1, 'priority': 3})]]
  vim.cmd[[call lexima#add_rule({'char': '"', 'at': '[({[''`]\%#\<\@!\|\>\@<!\%#[)}\]''`]', 'input_after': '"', 'priority': 2})]]
  vim.cmd[[call lexima#add_rule({'char': '"', 'at': '\%#\S\|\S\%#', 'priority': 1})]]
  vim.cmd[[call lexima#add_rule({'char': "'", 'at': '\%#''', 'leave': 1, 'priority': 3})]]
  vim.cmd[[call lexima#add_rule({'char': "'", 'at': '[({["`]\%#\<\@!\|\>\@<!\%#[)}\]"`]', 'input_after': "'", 'priority': 2})]]
  vim.cmd[[call lexima#add_rule({'char': "'", 'at': '\%#\S\|\S\%#', 'priority': 1})]]
  vim.cmd[[call lexima#add_rule({'char': '`', 'at': '\%#`', 'leave': 1, 'priority': 3})]]
  vim.cmd[[call lexima#add_rule({'char': '`', 'at': '[({["'']\%#\<\@!\|\>\@<!\%#[)}\]"'']', 'input_after': '`', 'priority': 2})]]
  vim.cmd[[call lexima#add_rule({'char': '`', 'at': '\%#\S\|\S\%#', 'priority': 1})]]
end

function M.neorg()
  require('neorg').setup({
    load = {
      ["core.defaults"] = {},
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            work = "~/Personal/neorg/work",
            home = "~/Personal/neorg/perso",
          },
          autochdir = true,
          default_workspace = "home",
        }
      },
      ["core.norg.qol.toc"] = {},
      ["core.norg.journal"] = {},
      ["core.norg.completion"] = {
        config = {
          engine = 'nvim-cmp',
        },
      },
      ["core.integrations.nvim-cmp"] = {},
      ["core.norg.concealer"] = {},
      ["core.gtd.base"] = {
        config = {
          workspace = "home",
        }
      },
      ["core.integrations.telescope"] = {}
    }
  })
end

function M.telekasten()
  require('telekasten').setup({
    home = vim.fn.expand("$HOME/zettelkasten"),
    calendar_opts = {
      weeknm = 2,
    },
    command_palette_theme = 'dropdown',
    template_new_note = vim.fn.expand("$HOME/zettelkasten/templates/default.md"),
  })
end

function M.leap()
  require('leap').set_default_keymaps()
end

function M.setup_dap()
  -- cf https://alpha2phi.medium.com/neovim-for-beginners-debugging-using-dap-44626a767f57

  local function configure()
    local dap_install = require "dap-install"
    dap_install.setup {
      installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
    }

    local dap_breakpoint = {
      error = {
        text = "🟥",
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
      },
      rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
      },
      stopped = {
        text = "⭐️",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
      },
    }

    vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
    vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
    vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
  end

  local function configure_exts()
    require("nvim-dap-virtual-text").setup {
      commented = true,
    }

    local dap, dapui = require "dap", require "dapui"
    dapui.setup {} -- use default
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end

  local function configure_debuggers()
    --require("config.dap.lua").setup()
    --require("config.dap.python").setup()
    require("dap-python").setup("python", {})
    table.insert(require('dap').configurations.python, {
      justMyCode = true
    })
    --require("config.dap.rust").setup()
  end

  local function configure_mappings()
    local whichkey = require "which-key"
    local keymap = {
      d = {
        name = "Debug",
        R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
        E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
        C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
        U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
        b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
        d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
        e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
        f = { "<cmd>Telescope dap frames<cr>", "Frames" },
        g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
        h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
        S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
        p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
        q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
        s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
        t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
        x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
        u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
      },
    }

    whichkey.register(keymap, {
      mode = "n",
      prefix = "<leader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = false,
    })

    local keymap_v = {
      name = "Debug",
      e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
    }

    whichkey.register(keymap_v, {
      mode = "v",
      prefix = "<leader>",
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = false,
    })
  end

  configure() -- Configuration
  configure_exts() -- Extensions
  configure_debuggers() -- Debugger
  configure_mappings() -- Mappings
end

return M
