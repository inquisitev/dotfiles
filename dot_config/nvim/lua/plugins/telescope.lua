return {
   "nvim-telescope/telescope.nvim",
   config = function()
         require("telescope").load_extension("yank_history")

         require "configs.telescope.multigrep".setup()
   end
}
