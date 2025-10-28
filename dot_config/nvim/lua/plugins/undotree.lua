vim.pack.add({ "https://github.com/jiaoshijie/undotree" })

require("undotree").setup({
   dependencies = "nvim-lua/plenary.nvim",
   config = true,
})
