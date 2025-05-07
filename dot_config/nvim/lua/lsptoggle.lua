-- ~/.config/nvim/lua/lsp_toggle.lua

-- Module table
local M = {}

-- Global variable to track the state
vim.g.virtual_lines_enabled = false

-- Function to toggle diagnostic display
function M.toggle_virtual_diagnostics()
  vim.g.virtual_lines_enabled = not vim.g.virtual_lines_enabled

  if vim.g.virtual_lines_enabled then
    vim.diagnostic.config({
      virtual_lines = { current_line = true },
      virtual_text = false,
      float = {
        border = "rounded",
        source = "always",
      },
    })
    print("Virtual lines enabled")
  else
    vim.diagnostic.config({
      virtual_lines = false,
      virtual_text = false,
      float = {
        border = "rounded",
        source = "always",
      },
    })
    print("Virtual lines disabled")
  end
end

-- Setup function to be called from your main init.lua
function M.setup(opts)
  opts = opts or {}

  -- Key mapping (can be customized through opts)
  local keymap = opts.keymap or "<leader>vd"

  -- Create the keybinding
  vim.keymap.set("n", keymap, M.toggle_virtual_diagnostics, {
    desc = "Toggle virtual diagnostics",
  })

  -- Initial LSP setup
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      -- Initial config (default is off)
      vim.diagnostic.config({
        virtual_lines = false,
        virtual_text = false,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  })
end

return M
