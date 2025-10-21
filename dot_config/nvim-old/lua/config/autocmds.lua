-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
--
vim.api.nvim_create_autocmd("User", {
  pattern = "ConformDone",
  callback = function()
    -- vim.fn.system({ "find", '.', "-name", "*.unc-backup", "-mmin", "+2", "-delete" })
    vim.fn.system({ "find", '.', "-name", "*.unc-backup", "-delete" })
  end,
})


vim.api.nvim_create_autocmd("LspAttach", {
   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
   callback = function(ev)
      -- Buffer-local mappings for LSP functions
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover Documentation" })

      vim.keymap.set("n", "gs", function()
         -- Get current buffer number
         local current_bufnr = vim.api.nvim_get_current_buf()

         -- Request clangd to switch between header and source
         vim.lsp.buf_request(
            current_bufnr,
            "textDocument/switchSourceHeader",
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
               vim.cmd("edit " .. vim.uri_to_fname(result))
            end
         )
      end, { buffer = bufnr, desc = "Switch header/source" })

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
      vim.keymap.set("n", "gd", function()
         vim.lsp.buf.definition({ reuse_win = true })
      end, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      -- vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
      vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
      vim.keymap.set("n", "<space>wl", function()
         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
      vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
   end,
})
