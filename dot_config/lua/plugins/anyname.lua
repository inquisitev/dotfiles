
  
  local plugins = {

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            setup = {
                rust_analyzer = function()
                return true 
                end,
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
    },
    {
        'numToStr/Navigator.nvim',
    }
  
  }
  
  return plugins
  