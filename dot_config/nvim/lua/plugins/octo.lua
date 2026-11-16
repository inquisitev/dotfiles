-- Octo: GitHub PRs and issues inside nvim (review, comment, approve, merge).
-- Uses the `gh` CLI from mise and its login (`gh auth login`).
-- Keymaps in config/octo_keymaps.lua (<leader>g...).
vim.pack.add({
   "https://github.com/nvim-lua/plenary.nvim",
   "https://github.com/nvim-telescope/telescope.nvim",
   "https://github.com/nvim-tree/nvim-web-devicons",
   "https://github.com/pwntester/octo.nvim",
})

require("octo").setup({
   picker = "telescope",
   enable_builtin = true, -- bare :Octo opens a picker of all commands
   default_merge_method = "squash",
   suppress_missing_scope = { projects_v2 = true },
})

-- `:Octo pr edit 12` style buffers get markdown highlighting
vim.treesitter.language.register("markdown", "octo")
