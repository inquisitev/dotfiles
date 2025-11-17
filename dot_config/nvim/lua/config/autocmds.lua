vim.api.nvim_create_autocmd("ColorScheme", {
   callback = function()
      local color = "#0cedbd"

      vim.api.nvim_set_hl(0, "WinSeparator", { fg = color, bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLine", { fg = color, bg = "black" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { fg = color, bg = "NONE" })
   end,
})

