vim.pack.add({
   "https://github.com/nvim-lua/plenary.nvim",
   "https://github.com/nvim-treesitter/nvim-treesitter",
   {
      src = "https://github.com/olimorris/codecompanion.nvim",
      version = vim.version.range("19.22.0"),
   },
})

require("codecompanion").setup({
   interactions = {
      chat = {
         adapter = "copilot_acp",
      },
      cli = {
         agent = "copilot_cli",
         agents = {
            copilot_cli = {
               cmd = "copilot",
               args = {},
               description = "GitHub Copilot CLI",
               provider = "terminal",
            },
            codex_cli = {
               cmd = "codex",
               args = {},
               description = "OpenAI Codex CLI",
               provider = "terminal",
            },
         },
      },
      code_review = {
         enabled = true,
      },
   },
})
