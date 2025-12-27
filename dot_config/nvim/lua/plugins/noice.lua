vim.pack.add({
   "https://github.com/folke/noice.nvim",
   "https://github.com/MunifTanjim/nui.nvim",
   "https://github.com/rcarriga/nvim-notify",
})

require("noice").setup({
   lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
         ["vim.lsp.util.stylize_markdown"] = true,
         ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
   },
   routes = {view = "notify",filter = { event = "msg_showmode" },},
   views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      },
    },
})
