vim.pack.add({
   "https://github.com/folke/noice.nvim",
   "https://github.com/MunifTanjim/nui.nvim",
   "https://github.com/rcarriga/nvim-notify",
})

require("notify").setup({
  max_width = 50,
  max_height = 3,
  render = "compact",
  stages = "static",
  top_down = false,
})

require("noice").setup({
   lsp = {
      override = {
         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
         ["vim.lsp.util.stylize_markdown"] = true,
         ["cmp.entry.get_documentation"] = true,
      },
   },
   routes = {
     { view = "notify", filter = { event = "msg_showmode" } },
     -- Dismiss old notifications so only latest shows
     {
       filter = { event = "notify" },
       opts = { replace = true },
     },
     {
       filter = { event = "msg_show", kind = "" },
       opts = { replace = true },
     },
   },
   views = {
      notify = {
        replace = true,
        merge = true,
      },
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
