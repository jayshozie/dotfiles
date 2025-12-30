return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-emoji",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
        },

        config = function()
            vim.lsp.set_log_level("warn")

            ---------------------------------------------------------
            -- GENERAL DIAGNOSTICS
            ---------------------------------------------------------
            vim.diagnostic.config({
                virtual_text = true,
            })

            ---------------------------------------------------------
            -- ON_ATTACH (your original keymaps preserved)
            ---------------------------------------------------------
            local on_attach = function(client, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }

                if client.server_capabilities.hoverProvider then
                    vim.keymap.set("n", "<C-k>",
                        function() vim.lsp.buf.hover({ border = "rounded", width = 60 }) end, opts)
                end

                if client.server_capabilities.signatureHelpProvider then
                    vim.keymap.set("n", "K",
                        function() vim.lsp.buf.signature_help({ border = "rounded", width = 60 }) end, opts)
                end

                if client.server_capabilities.definitionProvider then
                    vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, opts)
                end

                if client.server_capabilities.implementationProvider then
                    vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
                end

                if client.server_capabilities.referencesProvider then
                    vim.keymap.set("n", "<leader>r", function()
                        local telescope = require('telescope.builtin')

                        -- Custom function to make the results cleaner and shorter
                        -- by removing the spaces after the last colonsn and
                        -- before the actual line itself, without using vim.uri_to_fname
                        -- because that doesn't work.
                        local entry_maker = function(entry)
                            -- 1. Get the properties that Telescope has reliably prepared
                            local filename_full = entry.filename or ""
                            local line_text = entry.text or ""
                            local lnum = entry.lnum or 0

                            -- 2. Clean up the filename (just the base name) and line number
                            local filename_short = vim.fn.fnamemodify(filename_full, ':t')

                            -- 3. Remove leading whitespace from the line of code for better display
                            local trimmed_line_text = line_text:gsub("^%s+", "")

                            -- 4. Create the formatted display string
                            -- Use short filename, line number, and the trimmed code text
                            entry.display = string.format("%s:%d: %s", filename_short, lnum, trimmed_line_text)

                            -- You can optionally set 'ordinal' for fuzzy finding on the full path
                            entry.ordinal = string.format("%s:%d: %s", filename_full, lnum, line_text)

                            -- Return the modified entry object
                            return entry
                        end

                        telescope.lsp_references({
                            -- 1. Use the 'dropdown' theme for a better small-window experience
                            theme = "dropdown",

                            -- 2. Pass the custom entry maker
                            entry_maker = entry_maker,

                            -- 3. Adjust the size to be compact
                            layout_config = {
                                width = 0.7,
                                height = 0.35,
                            },

                            -- 4. Disable the preview window so you only see the list
                            preview_cutoff = 1000,
                        })
                    end, opts)
                end

                if client.server_capabilities.workspaceSymbolProvider then
                    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                end

                vim.keymap.set("n", "<leader>vd", function()
                    vim.diagnostic.open_float({ border = "rounded" })
                end, opts)

                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true, buffer = bufnr })
                end, opts)

                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true, buffer = bufnr })
                end, opts)

                if client.server_capabilities.codeActionProvider then
                    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                end

                if client.server_capabilities.renameProvider then
                    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                end

                if client.server_capabilities.documentFormattingProvider then
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                end
            end

            ---------------------------------------------------------
            -- AUTO SIGNATURE HELP (CursorHoldI)
            ---------------------------------------------------------
            vim.o.updatetime = 300
            local group = vim.api.nvim_create_augroup("jayshSignature", {})
            vim.api.nvim_create_autocmd("CursorHoldI", {
                group = group,
                callback = function()
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    for _, c in ipairs(clients) do
                        if c.server_capabilities.signatureHelpProvider then
                            vim.lsp.buf.signature_help()
                            break
                        end
                    end
                end
            })

            ---------------------------------------------------------
            -- CMP CONFIG
            ---------------------------------------------------------
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750 },
                    { name = "buffer",   priority = 500 },
                    { name = "path",     priority = 250 },
                    { name = "emoji",    priority = 249 },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
                experimental = {
                    ghost_text = false,
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }
                }
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })

            ---------------------------------------------------------
            -- LSP SERVERS (without Mason)
            -- using ONLY vim.lsp.config + vim.lsp.enable
            ---------------------------------------------------------

            -----------------------
            -- Lua LS (Lua)
            -----------------------
            vim.lsp.config.lua_ls = {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                    },
                },
            }
            vim.lsp.enable("lua_ls")

            -----------------------
            -- clangd (C/C++, ObjC, ObjC++)
            -----------------------
            vim.lsp.config.clangd = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--log=error",
                },
                filetypes = { "c", "cpp", "objc", "objcpp", "h" },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.enable("clangd")

            -----------------------
            -- vtsls (TS/JS)
            -----------------------
            vim.lsp.config.vtsls = {
                cmd = { "vtsls", "--stdio" },
                filetypes = {
                    "javascript", "typescript",
                    "javascriptreact", "typescriptreact",
                    "js", "jsx", "ts", "tsx",
                    "vue",
                    "json",
                },
                root_markers = { ".git" },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.enable("vtsls")

            -----------------------
            -- Bash LS (Bash)
            -----------------------
            vim.lsp.config.bashls = {
                cmd = { "bash-language-server", "start" },
                filetypes = { "sh", "bash" },
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    bashIde = {
                        shellcheckpath = "",
                    },
                },
            }
            vim.lsp.enable("bashls")

            -----------------------
            -- Marksman (Markdown)
            -----------------------
            vim.lsp.config.marksman = {
                cmd = { "marksman", "server" },
                filetypes = { "markdown", "md" },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            vim.lsp.enable("marksman")

            -----------------------
            -- ltex-plus (LaTeX)
            -----------------------
            vim.lsp.config["ltex-ls-plus"] = {
                cmd = { "ltex-ls" },
                filetypes = { "tex", "markdown", "md" },
                on_attach = on_attach,
                capabilities = capabilities,
            }
            if vim.fn.executable("ltex-ls") == 1 then
                vim.lsp.enable("ltex-ls-plus")
            end

            -----------------------
            -- markdown-oxide (Markdown)
            -----------------------
            vim.lsp.config["markdown-oxide"] = {
                cmd = { "markdown-oxide" },
                filetypes = { "md" },
                on_attach = on_attach,
                capabilities = capabilities,
                root_markers = { ".git" },
            }
            vim.lsp.enable("markdown-oxide")

            -----------------------
            -- Pyright (Python)
            -----------------------
            vim.lsp.config["pyright"] = {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "py", "python" },
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        }
                    }
                }
            }
            if vim.fn.executable("pyright-langserver") == 1 then
                vim.lsp.enable("pyright")
            end
        end,
    }
}
