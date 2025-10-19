vim.pack.add({ "nvim-treesitter/nvim-treesitter" }, {
   build = ":TSUpdate", -- ensures parsers are kept up to date
   config = function()
      require("nvim-treesitter.configs").setup({
         ensure_installed = { "lua", "python", "cpp", "c", "javascript", "qmljs" }, -- or "all"
         highlight = {
            enable = true,
         },
         indent = {
            enable = true,
         },
      })
   end,
})
