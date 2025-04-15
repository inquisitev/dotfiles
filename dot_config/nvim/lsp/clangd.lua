return {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp', 'h', 'hpp' },
  on_attach = function(client, bufnr)
    -- Create a mapping for switching between header and source
    vim.keymap.set('n', '<leader>sh', function()
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
  end
}
