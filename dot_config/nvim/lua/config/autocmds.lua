vim.api.nvim_create_autocmd("ColorScheme", {
   callback = function()
      local color = "#0cedbd"

      vim.api.nvim_set_hl(0, "WinSeparator", { fg = color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLine", { fg = color, bg = "black" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { fg = color, bg = "NONE" })

      -- Custom highlight overrides
      vim.api.nvim_set_hl(0, "@string", { fg = "#2DFF10" })
      vim.api.nvim_set_hl(0, "@string.escape", { fg = "#8bff6a" })
      vim.api.nvim_set_hl(0, "String", { fg = "#2DFF10" })
   end,
})

