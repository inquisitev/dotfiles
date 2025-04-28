return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Mappings
      local opts = { noremap = true, silent = true }

    
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        vim.keymap.set('n', '<leader>gs', function()
        -- Get current buffer number
        local current_bufnr = vim.api.nvim_get_current_buf()
        
        -- Request clangd to switch between header and source
        vim.lsp.buf_request(
          current_bufnr, 
          'textDocument/switchSourceHeader', 
          { uri = vim.uri_from_bufnr(current_bufnr) },
          function(err, result)
            if err then
              vim.notify("Error switching between source/header: " .. err.message, vim.log.levels.ERROR)
              return
            end
            if not result then
              vim.notify("Corresponding file not found", vim.log.levels.WARN)
              return
            end
            -- Open the result file
            vim.cmd('edit ' .. vim.uri_to_fname(result))
          end
        )
       end, { buffer = bufnr, desc = "Switch header/source" })

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end

      -- Add capabilities for nvim-cmp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup language servers (examples)
      local lspconfig = require('lspconfig')
      
      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      lspconfig.anakin_language_server.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
   
      lspconfig.clangd.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      
    end,
  },
}
