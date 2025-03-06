return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
    },
    -- See Commands section for default commands if you want to lazy load on them
    lazy=false,
   config = function()
      require("CopilotChat").setup {
      }

      vim.opt.completeopt = "menuone,noselect"
      vim.cmd('Copilot disable')
      vim.keymap.set("n", "<leader>co", "<cmd>:CopilotChatOpen<CR>", { desc = "Open copilot chat" })
      vim.keymap.set("n", "<leader>cc", "<cmd>:CopilotChatClose<CR>", { desc = "Close copilot chat" })
      vim.keymap.set("n", "<leader>ce", "<cmd>:Copilot enable<CR>", { desc = "enable copilot" })
      vim.keymap.set("n", "<leader>cd", "<cmd>:Copilot disable<CR>", { desc = "disble copilot" })
              
   end

  },
}
