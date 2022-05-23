-- vim:tabstop=2:shiftwidth=2:softtabstop=2
local M = {}

function M.neuron()
  require'neuron'.setup{
    neuron_dir = "~/notes"
  }
end

function M.goyo()
  vim.cmd[[autocmd! User GoyoEnter Limelight]]
  vim.cmd[[autocmd! User GoyoLeave Limelight!]]
end

function M.tender()
  vim.g.tender_italic = 1
  vim.g.tender_bold = 1
end

function M.easy_motion()
  vim.g.EasyMotion_keys = 'lkjhqsdfgoiuzerpaytbvcxwmn,'
  vim.g.EasyMotion_startofline = 0
  vim.g.EasyMotion_show_prompt = 0
  vim.g.EasyMotion_verbose = 0
end

function M.lualine()
  require('lualine').setup {
    options = {
      theme = 'onedark',
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
      lualine_y = { require'nvim-treesitter'.statusline(80) },
      lualine_z = { 'encoding', 'fileformat', 'filetype' },
    },
    extensions = {}
  }
end

function M.startify()
  vim.g.startify_change_to_dir = 0
  vim.g.startify_change_to_vcs_root = 1
end

function M.indentLine()
  vim.g.indentLine_char = '▏'
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
          ["<M-s><M-p>"] = "@parameter.inner",
          ["<M-s>f"] = "@function.outer",
        },
        swap_previous = {
          ["<M-s><M-P>"] = "@parameter.inner",
          ["<M-s>F"] = "@function.outer",
        },
      },
    },

    playground = {
      enable = true
    },
  }
  vim.o.foldmethod = 'expr'
  vim.cmd[[set foldexpr=nvim_treesitter#foldexpr()]]
end

function M.onedark()
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
  local lsp_installer = require("nvim-lsp-installer")

  -- Custom initialization function
  local custom_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
  end

  -- Custom attach function
  local custom_attach = function(client)
    require('lsp-status').on_attach(client)
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  end

  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  updated_capabilities = require('cmp_nvim_lsp').update_capabilities(
    updated_capabilities)
  updated_capabilities.textDocument.codeLens = {
    dynamicRegistration = false,
  }
  updated_capabilities = vim.tbl_deep_extend('keep',
    updated_capabilities, require'lsp-status'.capabilities)
  updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
  updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }

  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_init = custom_init,
      on_attach = custom_attach,
      capabilities = updated_capabilities,
    }

    if server.name == "pylsp" then
      opts.pylsp = {
        plugins = {
          pyls_mpypy = {enabled = true},
          flake8 = { enabled = true },
        }
      }
    end

    -- This setup() function will take the provided server configuration and decorate it with the necessary properties
    -- before passing it onwards to lspconfig.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
  end)

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

function M.trouble()
  require('trouble').setup {
    position = 'right',
    auto_close = true,
    auto_preview = false,
    auto_fold = false,
  }
end

function M.floaterm()
  vim.g.floaterm_keymap_new = '<F7>'
  vim.g.floaterm_keymap_toggle = '<F12>'
end

function M.lexima()
  vim.g.lexima_no_default_rules = true
  vim.cmd[[call lexima#set_default_rules()]]
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
