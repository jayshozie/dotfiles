return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "mason-org/mason.nvim",           version = "^1.*" },
        { "mason-org/mason-lspconfig.nvim", version = "^1.*" },
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        -- Add these dependencies for nvim-cmp
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "onsails/lspkind.nvim", -- Optional but recommended for nice icons
    },

    config = function()
        -- Set up Mason
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            },
            -- Mason configs go in here.
        })

        -- Configure LSP keymaps that apply when an LSP connects to a buffer
        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- Check client capabilities and set up keymaps accordingly
            -- Some keymaps may not be needed if the client doesn't support the capability

            -- Hover documentation (what you saw in the videos)
            if client.server_capabilities.hoverProvider then
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            end

            -- Signature help (shows function parameters)
            if client.server_capabilities.signatureHelpProvider then
                vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end

            -- Navigation
            if client.server_capabilities.definitionProvider then
                vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            end

            if client.server_capabilities.implementationProvider then
                vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
            end

            if client.server_capabilities.referencesProvider then
                vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
            end

            -- Workspace
            if client.server_capabilities.workspaceSymbolProvider then
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            end

            -- Diagnostics
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float({ border = "rounded" }) end, opts)
            vim.keymap.set("n", "[d", function()
                vim.diagnostic.goto_prev({ border = "rounded" })
            end, opts)
            vim.keymap.set("n", "]d", function()
                vim.diagnostic.goto_next({ border = "rounded" })
            end, opts)

            -- Code actions and refactoring
            if client.server_capabilities.codeActionProvider then
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            end

            if client.server_capabilities.renameProvider then
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            end

            -- Formatting
            if client.server_capabilities.documentFormattingProvider then
                vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
            end

            -- Log the capabilities to help with troubleshooting
            -- print(vim.inspect(client.server_capabilities))
        end

        -- Make hover and signature help look nicer with borders
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Set up custom handlers for the current buffer only
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client then
                    -- Update hover handler for this client/buffer
                    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
                        config = config or {}
                        config.border = "rounded"
                        config.width = 60
                        vim.lsp.handlers.hover(_, result, ctx, config)
                    end

                    -- Update signature help handler for this client/buffer
                    vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
                        config = config or {}
                        config.border = "rounded"
                        config.width = 60
                        vim.lsp.handlers.signature_help(_, result, ctx, config)
                    end
                end
            end
        })

        -- Enable automatic signature help as you type
        vim.o.updatetime = 300
        local jayshGroup = vim.api.nvim_create_augroup('jayshGroup', {})
        vim.api.nvim_create_autocmd("CursorHoldI", {
            group = jayshGroup,
            callback = function()
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                for _, client in ipairs(clients) do
                    if client.server_capabilities.signatureHelpProvider then
                        vim.lsp.buf.signature_help()
                        break
                    end
                end
            end
        })

        -- Set up nvim-cmp
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expandable() then
                        luasnip.expand()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp', priority = 1000 },
                { name = 'luasnip',  priority = 750 },
                { name = 'buffer',   priority = 500 },
                { name = 'path',     priority = 250 },
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    maxwidth = 50,
                    ellipsis_char = '...',
                }),
            },
            experimental = {
                ghost_text = false, -- Set to false to avoid conflict with Copilot
            },
        })

        -- Use buffer source for `/` and `?`
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'cmdline' }
            })
        })

        -- Get LSP capabilities for nvim-cmp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Set up mason-lspconfig with enhanced capabilities and on_attach
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "harper_ls",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            }
        })

        -- Optional: Any language-specific configurations
        -- require("lspconfig").lua_ls.setup({
        --     settings = {
        --         Lua = {
        --             diagnostics = {
        --                 globals = { "vim" }
        --             }
        --         }
        --     }
        -- })
    end
}
