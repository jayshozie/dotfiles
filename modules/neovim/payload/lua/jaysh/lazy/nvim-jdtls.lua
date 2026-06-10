return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      if client.server_capabilities.hoverProvider then
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover({ border = "rounded", width = 60 })
        end, opts)
      end

      if client.server_capabilities.definitionProvider then
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      end

      if client.server_capabilities.implementationProvider then
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
      end

      if client.server_capabilities.referencesProvider then
        vim.keymap.set("n", "gr", function()
          local entry_maker = function(entry)
            local filename_full = entry.filename or ""
            local line_text = entry.text or ""
            local lnum = entry.lnum or 0
            local filename_short = vim.fn.fnamemodify(filename_full, ":t")
            local trimmed_line_text = line_text:gsub("^%s+", "")
            entry.display = string.format(
              "%s:%d: %s",
              filename_short,
              lnum,
              trimmed_line_text
            )
            entry.ordinal =
              string.format("%s:%d: %s", filename_full, lnum, line_text)
            return entry
          end

          require("telescope.builtin").lsp_references({
            theme = "dropdown",
            entry_maker = entry_maker,
            layout_config = {
              width = 0.7,
              height = 0.35,
            },
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

      vim.keymap.set("n", "<leader>th", function()
        local is_enabled = vim.diagnostic.is_enabled({ bufnr = 0 })
        vim.diagnostic.enable(not is_enabled, { bufnr = 0 })
        print("Diagnostics " .. (is_enabled and "Hiding" or "Showing"))
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
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local home = os.getenv("HOME")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name
        local e = "org.eclipse.jdt.core.formatter"

        local config = {
          cmd = {
            "jdtls",
            "-data",
            workspace_dir,
          },
          root_dir = require("jdtls.setup").find_root({
            ".git",
            "build.gradle",
            "pom.xml",
          }),
          settings = {
            java = {
              import = {
                gradle = {
                  enabled = false,
                },
                maven = {
                  enabled = true,
                },
              },
              project = {
                importOnFirstTimeStartup = "none",
              },
              jdt = {
                ls = {
                  androidSupport = {
                    enabled = true,
                  },
                },
              },
              format = {
                enable = true,
                settings = {
                  -- ["org.eclipse.jdt.core.formatter.tabulation.char"] = "space",
                  -- ["org.eclipse.jdt.core.formatter.tabulation.size"] = "4",
                  -- ["org.eclipse.jdt.core.formatter.indentation.size"] = "4",
                  -- ["org.eclipse.jdt.core.formatter.lineSplit"] = "80",
                  -- ["org.eclipse.jdt.core.formatter.alignment_for_expressions_in_array_initializer"] = "16",
                  -- ["org.eclipse.jdt.core.formatter.alignment_for_arguments_in_method_invocation"] = "16",
                  -- ["org.eclipse.jdt.core.formatter.alignment_for_parameters_in_method_declaration"] = "16",
                  -- ["org.eclipse.jdt.core.formatter.alignment_for_assignment"] = "16",
                  -- ["org.eclipse.jdt.core.formatter.alignment_for_binary_expression"] = "16",
                  -- ["org.eclipse.jdt.core.formatter.alignment_for_conditional_expression"] = "16",
                  -- ["org.eclipse.jdt.core.formatter.join_wrapped_lines"] = "true",
                  -- ["org.eclipse.jdt.core.formatter.join_lines_in_comments"] = "true",
                },
              },
            },
          },
          on_attach = on_attach,
        }
        require("jdtls").start_or_attach(config)
      end,
    })
  end,
}
