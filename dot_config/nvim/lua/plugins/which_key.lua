vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
   triggers = {
      { "<auto>", mode = "nixsotc" },
      { "a", mode = { "n", "v" } },
   },
})
