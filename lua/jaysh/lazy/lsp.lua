return {
    {
        "github/copilot.vim",
        event = 'VeryLazy',
        config = function()
            vim.keymap.set('n', "<leader>c",
                function()
                    if vim.b.copilot_enabled == true or vim.b.copilot_enabled == nil then
                        vim.cmd("Copilot disable")
                        vim.b.copilot_enabled = false
                        print("Copilot disabled")
                    elseif vim.b.copilot_enabled == false then
                        vim.cmd("Copilot enable")
                        vim.b.copilot_enabled = true
                        print("Copilot enabled")
                    end
                end,
                { noremap = false, silent = true, desc = "Toggle Copilot" }
            )
            local STATE_FILE = vim.fn.stdpath('data') .. "/copilot_error_month"
            local NOTIF_TITLE = 'Copilot Limit Gate'
            local function get_current_month()
                return os.date('%Y%m')
            end
            local function get_stored_month()
                local f = io.open(STATE_FILE, 'r')
                if f then
                    local stored_month = f:read("*a"):gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
                    f:close()
                    return stored_month
                end
                return "" -- return empty if file doesn't exist
            end
            local function set_stored_month(month)
                local f = io.open(STATE_FILE, 'w')
                if f then
                    f:write(month)
                    f:close()
                end
            end
            local function conditionally_enable_copilot()
                local current_month = get_current_month()
                local stored_month = get_stored_month()

                if current_month == stored_month then
                    vim.g.copilot_filetypes = { ['*'] = false }
                    vim.notify(
                        "Limit reached last month. Copilot is disabled until " ..
                        os.date("%B %Y", os.time() + 2592000) .. " to prevent popups.",
                        vim.log.levels.INFO,
                        { title = NOTIF_TITLE }
                    )
                    return
                end
                vim.notify('Copilot activated.', vim.log.levels.INFO, { title = NOTIF_TITLE })
            end

            vim.g.copilot_filetypes = { ['*'] = false }
            conditionally_enable_copilot()
            vim.api.nvim_create_user_command('MSSucks',
                function()
                    local current_month = get_current_month()
                    set_stored_month(current_month)
                    vim.g.copilot_filetypes = { ['*'] = false }
                end,
                {
                    desc = 'Manually record a Copilot limit error for the current month and disable it.'
                })
            vim.keymap.set('n', "<leader>mss", vim.cmd('MSSucks'),
                { desc = 'Keymap for MSSucks User Command' }
            )
        end,
    },
    -- {
    --     'neovim/nvim-lspconfig',
    --     -- dependencies = {
    --     --     '',
    --     --     '',
    --     --     '',
    --     -- },

    --     config = function()
    --         -- Diagnostics
    --         vim.diagnostic.config({
    --             -- virtual_lines = true,
    --             virtual_text = true,
    --         })
    --         -- autocommand, too detailed, just read it.
    --         vim.api.nvim_create_autocmd('LspAttach', {
    --             callback = function(ev)
    --                 local client = vim.lsp.get_client_by_id(ev.data.client_id)
    --                 if client:supports_method('textDocument/completion') then
    --                     vim.opt.completeopt = {
    --                         'menu', 'menuone', 'noinsert', 'fuzzy', 'popup'
    --                     }
    --                     vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    --                     vim.keymap.set('i', '<C-space>', function()
    --                         vim.lsp.completion.get()
    --                     end)
    --                 end
    --             end,
    --         })


    --         -- ccls for C/C++
    --         -- vim.lsp.config['ccls'] = {
    --         --     cmd = { 'ccls' },
    --         --     filetypes = { 'c', 'cpp', 'h' },
    --         -- }
    --         -- vim.lsp.enable('ccls')

    --         -- clangd for C++
    --         -- vim.lsp.config['clangd'] = {

    --         -- }
    --         -- vim.lsp.enable('clangd')


    --         -- Lua Language Server
    --         vim.lsp.config['lua_ls'] = {
    --             cmd = { 'lua-language-server' },
    --             filetypes = { 'lua' },
    --             root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    --             settings = {
    --                 Lua = {
    --                     runtime = {
    --                         version = 'LuaJIT',
    --                     },
    --                     diagnostics = {
    --                         globals = { 'vim' },
    --                     },
    --                 }
    --             }
    --         }
    --         vim.lsp.enable('lua_ls')
    --     end,
    -- },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- { "mason-org/mason.nvim", version = "^1.*" },
            { "mason-org/mason.nvim" },
            -- { "mason-org/mason-lspconfig.nvim", version = "^1.*" },
            { "mason-org/mason-lspconfig.nvim" },
            -- {
            --     "mfussenegger/nvim-dap",
            --     event = "VeryLazy",
            --     dependencies = {
            --         {
            --             "rcarriga/nvim-dap-ui",
            --             config = function()
            --                 local dap, dapui = require("dap"), require("dapui")
            --                 dap.listeners.before.attach.dapui_config = function()
            --                   dapui.open()
            --                 end
            --                 dap.listeners.before.launch.dapui_config = function()
            --                   dapui.open()
            --                 end
            --                 dap.listeners.before.event_terminated.dapui_config = function()
            --                   dapui.close()
            --                 end
            --                 dap.listeners.before.event_exited.dapui_config = function()
            --                   dapui.close()
            --                 end
            --             end
            --         },
            --         "nvim-neotest/nvim-nio",
            --         {
            --             "jay-babu/mason-nvim-dap.nvim",
            --             opts = {
            --                 handlers = {},
            --                 ensure_installed = {
            --                     'bash',
            --                     'codelldb',
            --                     'python',
            --                     'cppdbg',
            --                 },
            --             },
            --             dependencies = {
            --                 'mfussenegger/nvim-dap',
            --                 'mason-org/mason.nvim',
            --             },
            --         },
            --         "theHamsta/nvim-dap-virtual-text",
            --     },
            --     keys = {
            --         {
            --             '<leader>db',
            --             function() require('dap').toggle_breakpoint() end,
            --             desc = 'Toggle Breakpoint'
            --         },
            --         {
            --             '<leader>dc',
            --             function() require('dap').continue() end,
            --             desc = 'Continue'
            --         },
            --         {
            --             '<leader>dC',
            --             function() require('dap').run_to_cursor() end,
            --             desc = 'Run to Cursor'
            --         },
            --         {
            --             '<leader>dT',
            --             function() require('dap').terminate() end,
            --             desc = 'Terminate'
            --         },
            --     },
            -- },
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
            "hrsh7th/cmp-emoji",
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
                    vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.hover({ border = "rounded", width = 60 }) end, opts)
                end

                -- Signature help (shows function parameters)
                if client.server_capabilities.signatureHelpProvider then
                    vim.keymap.set("n", "K",
                        function() vim.lsp.buf.signature_help({ border = "rounded", width = 60 }) end, opts)
                    -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                end

                -- Navigation
                if client.server_capabilities.definitionProvider then
                    vim.keymap.set("n", "<leader>d", function() vim.lsp.buf.definition() end, opts)
                end

                if client.server_capabilities.implementationProvider then
                    vim.keymap.set("n", "<leader>i", function() vim.lsp.buf.implementation() end, opts)
                end

                if client.server_capabilities.referencesProvider then
                    vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references() end, opts)
                end

                -- Workspace
                if client.server_capabilities.workspaceSymbolProvider then
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                end

                -- Diagnostics
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float({ border = "rounded" }) end, opts)
                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true, buffer = bufnr })
                end, opts)
                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true, buffer = bufnr })
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

            -- Enable automatic signature help as you type
            vim.o.updatetime = 300
            local jayshGroup = vim.api.nvim_create_augroup('jayshGroup', {})
            vim.api.nvim_create_autocmd("CursorHoldI", {
                group = jayshGroup,
                callback = function()
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
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
                    { name = 'emoji',    priority = 249 },
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
                    'clangd',         -- C/C++
                    'lua_ls',         -- Lua
                    'pyright',        -- Python
                    'vtsls',          -- JS/TS
                    'bashls',         -- Shell Scripts
                    -- 'ltex-ls-plus',   -- LaTeX
                    'marksman',       -- Markdown
                    -- 'markdown-oxide', -- Markdown
                },
                handlers = {
                    function(server_name)
                        vim.lsp.config[server_name] = {
                            on_attach = on_attach,
                            capabilities = capabilities,
                        }
                    end,
                }
            })
            vim.diagnostic.config({
                -- virtual_lines = true,
                virtual_text = true,
            })
            vim.lsp.config['lua_ls'] = {
                cmd = { 'lua-language-server' },
                filetypes = { 'lua' },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            -- vim.lsp.config['pyright'] = {
            --     cmd = { 'pyright' },
            --     filetypes = { 'py' },
            --     on_attach = on_attach,
            --     capabilities = capabilities,
            -- }
            vim.lsp.config['clangd'] = {
                cmd = {
                    'clangd',
                    '--background-index',
                },
                filetypes = { 'c', 'cpp', 'h', 'objc', 'objcpp' },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['ltex-ls-plus'] = {
                cmd = { 'ltex_plus' },
                filetypes = { 'tex', 'md' },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['marksman'] = {
                cmd = { 'marksman' },
                filetypes = { 'md' },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['markdown-oxide'] = {
                cmd = { 'markdown-oxide' },
                filetypes = { 'md' },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['vtsls'] = {
                cmd = { 'vtsls',
                        '--stdio',
                },
                filetypes = {
                        'javascript',
                        'typescript',
                        'javascriptreact',
                        'typescriptreact',
                        'js',
                        'jsx',
                        'ts',
                        'tsx',
                        'vue',
                        'json', -- Vtsls often handles package.json/tsconfig.json
                },
                on_attach = on_attach,
                capabilities = capabilities,
                root_markers =  { '.git' }
            }
            vim.lsp.config['css-lsp'] = {
                cmd = {'vscode-css-language-server', },
                filetypes = {
                    'css',
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['html-lsp'] = {
                cmd  = { 'vscode-html-language-server' },
                filetypes = {
                    'html',
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['intelephense'] = {
                cmd = { 'intelephense' },
                filetypes = {
                    'php',
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.config['bashls'] = {
                cmd = { 'bash-language-server' },
                filetypes = {
                    'sh',
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            -- Optional: Any language-specific configurations
            -- vim.lsp.config.lua_ls.setup({
            --    settings = {
            --        Lua = {
            --            diagnostics = {
            --                globals = { "vim" }
            --            }
            --        }
            --    }
            -- })
        end
    },
}
