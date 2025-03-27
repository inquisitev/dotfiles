-- Create this file at ~/.config/nvim/lua/plugins/jdtls.lua

return {
  {
    "nvim-java/nvim-java",
    event = "VeryLazy",
    config = function()
      require("java").setup()
      require('lspconfig').jdtls.setup({})
    end,
  }
}


