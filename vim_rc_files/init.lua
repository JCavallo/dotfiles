local nvim_lsp = require('lspconfig')

nvim_lsp.pyls.setup({
    enable = true,
    filetypes = {
        "python",
        "python.trpy",
    },
})

nvim_lsp.vimls.setup({})

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
})

nvim_lsp.sumneko_lua.setup({})

nvim_lsp.bashls.setup({})

nvim_lsp.yamlls.setup({})

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
