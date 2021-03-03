local nvim_lsp = require('lspconfig')

-- pip install python-language-server[all]
nvim_lsp.pyls.setup({
    enable = true,
    pyls = {
        plugins = {
            pyls_mypy = {enabled = true}
            }
        },
    filetypes = {
        "python",
        "python.trpy",
    },
})

-- https://github.com/juliosueiras/terraform-lsp
nvim_lsp.terraformls.setup({
    cmd = { "terraform-lsp" },
    root_dir = nvim_lsp.util.root_pattern(".terraform", ".git"),
})

-- yarn global add vim-language-server
nvim_lsp.vimls.setup({})

-- yarn global add typescript-language-server typescript
nvim_lsp.tsserver.setup({
    cmd = {"typescript-language-server", "--stdio"},
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    },
    root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
})

-- LspInstall sumneko
-- nvim_lsp.sumneko_lua.setup({})

-- yarn global add bash-language-server
nvim_lsp.bashls.setup({})

-- https://github.com/prominic/groovy-language-server#build
nvim_lsp.groovyls.setup({
    cmd = { "java", "-jar", "~/bin/groovy-language-server-all.jar" },
    filetypes = { "groovy", "Jenkinsfile" },
    })

-- yarn global add yaml-language-server
nvim_lsp.yamlls.setup({
    filetypes = { "yaml", "yaml.tmpl" },
    })

nvim_lsp.rust_analyzer.setup({
    cmd = {"rust-analyzer"},
    filetypes = {"rust"},
    })

-- Shamelessly copy-pasted from https://www.reddit.com/r/neovim/comments/jt9tqm/new_builtin_lsp_diagnostics_module/gcae1in/
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, method, params, client_id, bufnr, config)
    local uri = params.uri

    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = true,
            signs = sign_decider,
            update_in_insert = false,
        }
    )(err, method, params, client_id, bufnr, config)

    bufnr = bufnr or vim.uri_to_bufnr(uri)

    if bufnr == vim.api.nvim_get_current_buf() then
        vim.lsp.diagnostic.set_loclist { open_loclist = false }
    end
end
