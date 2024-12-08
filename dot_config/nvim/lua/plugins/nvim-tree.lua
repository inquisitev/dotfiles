return {
   {
      "nvim-treesitter/nvim-treesitter",
      config = function()
         require("nvim-tree").setup({
           filters = {
            -- dot_files = false,
            git_ignored = false
           },
         })
      end
   }
}
