return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                        "--query-driver=**",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
                pyright = {},
            },
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("UserQuickfixKeymaps", { clear = true }),
                pattern = "qf",
                callback = function(event)
                    vim.keymap.set("n", "q", "<cmd>close<cr>", {
                        buffer = event.buf,
                        silent = true,
                        desc = "Close quickfix window",
                    })
                    vim.keymap.set("n", "<CR>", "<CR><cmd>cclose<cr>", {
                        buffer = event.buf,
                        silent = true,
                        desc = "Jump to reference and close quickfix",
                    })
                end,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
                callback = function(event)
                    local function map(keys, action, description)
                        vim.keymap.set("n", keys, action, { buffer = event.buf, desc = description })
                    end

                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gr", vim.lsp.buf.references, "Find references")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("gI", vim.lsp.buf.implementation, "Go to implementation")
                    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
                    map("K", vim.lsp.buf.hover, "Hover documentation")
                end,
            })

            for server, config in pairs(opts.servers) do
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },
}
