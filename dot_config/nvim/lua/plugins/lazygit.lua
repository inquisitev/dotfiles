return {
   {
     "kdheepak/lazygit.nvim",
     cmd = {
       "LazyGit",
       "LazyGitConfig",
       "LazyGitCurrentFile",
       "LazyGitFilter",
       "LazyGitFilterCurrentFile",
     },
     -- optional for floating window border decoration
     dependencies = {
       "nvim-lua/plenary.nvim",
     },
     -- setting the keybinding for LazyGit with 'keys' is recommended in
     -- order to load the plugin when the command is run for the first time
     keys = {
       { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
       { "<leader>tf", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
       { "<leader>tc", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
       { "<leader>ty", "<cmd>Telescope yank_history<cr>", desc = "Telescope yank_history" }
     }
   }
}
