vim.pack.add({
   "https://github.com/johmsalas/text-case.nvim",
})

require("textcase").setup({
   dependencies = { "nvim-telescope/telescope.nvim" },
   config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
   end,
   cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
   },
})
