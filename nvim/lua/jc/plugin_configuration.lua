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
      theme = 'auto',
      icons_enabled = true,
      section_separators = { left='', right='' },
      component_separators = { left='', right='' },
      padding = 1,
      disabled_filetypes = {}
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
    ensure_installed = 'maintained',

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
      { name = 'buffer' },
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

function M.lsp()
  local lspconfig = require('lspconfig')
  local lspconfig_util = require('lspconfig.util')

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

  -- lua for vim configuration lsp, LspInstall sumneko_lua
  local sumneko_server = vim.fn.stdpath('data')..'/lspinstall/lua/sumneko-lua-language-server'
  local sumneko_main = vim.fn.stdpath('data')..'/lspinstall/lua/sumneko-lua/extension/server/main.lua'
  require('nlua.lsp.nvim').setup(lspconfig, {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,

    cmd = {sumneko_server, '-E', sumneko_main},

    root_dir = function(fname)
      if string.find(vim.fn.fnamemodify(fname, ":p"), "nvim/") then
        return vim.fn.expand(vim.fn.stdpath('config'))
      end

      return lspconfig_util.find_git_ancestor(fname)
        or lspconfig_util.path.dirname(fname)
    end,
  })

  -- pip install python-language-server[all]
  lspconfig.pylsp.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    enable = true,
    pyls = {
      plugins = { pyls_mpypy = {enabled = true} }
    },
    filetypes = { 'python', 'python.trpy' },
  })

  -- https://github.com/hashicorp/terraform-ls
  lspconfig.terraformls.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    cmd = { "terraform-ls" },
    filetypes = { "tf", "terraform" },
    root_dir = lspconfig_util.root_pattern(".terraform", ".git"),
  })

  -- yarn global add vscode-langservers-extracted
  lspconfig.cssls.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
  })

  -- LspInstall vim
  lspconfig.vimls.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
  })

  -- LspInstall typescript
  lspconfig.tsserver.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    cmd = {'typescript-language-server', '--stdio'},
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    },
    root_dir = lspconfig_util.root_pattern(
      "package.json", "tsconfig.json", "jsconfig.json", ".git"),
  })

  -- yarn global add vscode-html-languageserver-bin
  lspconfig.html.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
  })

  -- yarn global add bash-language-server
  lspconfig.bashls.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
  })

  -- LspInstall yaml
  lspconfig.yamlls.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    filetypes = { "yaml", "yaml.tmpl" },
  })

  -- LspInstall rust
  lspconfig.rust_analyzer.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    cmd = {"rust-analyzer"},
    filetypes = {"rust"},
  })

  -- https://download.jboss.org/jbosstools/vscode/stable/lemminx-binary/
  lspconfig.lemminx.setup({
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    cmd = { "lemminx-linux" }
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        prefix = "🞮",
        spacing = 4,
      }
    }
  )

  vim.fn.sign_define("LspDiagnosticsSignError", { text = "🞮", numhl = "LspDiagnosticsDefaultError" })
  vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "🞮▲", numhl = "LspDiagnosticsDefaultWarning" })
  vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "⁈", numhl = "LspDiagnosticsDefaultInformation" })
  vim.fn.sign_define("LspDiagnosticsSignHint", { text = "⯁", numhl = "LspDiagnosticsDefaultHint" })

  vim.cmd[[hi LspDiagnosticsError guifg=#FF0000 guibg=NONE guisp=NONE gui=NONE cterm=bold]]
  vim.cmd[[hi LspDiagnosticsWarning guifg=#FFC600 guibg=NONE guisp=NONE gui=NONE cterm=bold]]
  vim.cmd[[hi LspDiagnosticsInformation guifg=#00AAFF guibg=NONE guisp=NONE gui=NONE cterm=NONE]]
  vim.cmd[[hi LspDiagnosticsHint guifg=#00AAFF guibg=NONE guisp=NONE gui=NONE cterm=NONE]]

  vim.cmd[[autocmd CursorHold * lua vim.diagnostic.show()]]
  vim.cmd[[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]]

end

function M.lspinstall()
  local function setup_servers()
    require'lspinstall'.setup()
    local servers = require'lspinstall'.installed_servers()
    for _, server in pairs(servers) do
      require'lspconfig'[server].setup{}
    end
  end

  setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require'lspinstall'.post_install_hook = function ()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end 
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
      },
    }
  }
  require('telescope').load_extension('fzf')
end

function M.trouble()
  require('trouble').setup {
    position = 'right',
    auto_close = true,
    auto_preview = false,
    auto_fold = false,
  }
end

function M.lexima()
  vim.g.lexima_no_default_rules = true
  vim.cmd[[call lexima#set_default_rules()]]
end

return M
