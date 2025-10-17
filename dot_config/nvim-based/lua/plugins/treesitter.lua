vim.pack.add({ "nvim-treesitter/nvim-treesitter" }, {
   build = ":TSUpdate", -- ensures parsers are kept up to date
   config = function()
      require("nvim-treesitter.configs").setup({
         ensure_installed = { "lua", "python", "cpp", "c", "javascript", "qmljs" }, -- or "all"
         highlight = {
            enable = true, -- false will disable the whole extension
            additional_vim_regex_highlighting = false,
         },
         indent = {
            enable = true,
         },
      })
   end,
})
