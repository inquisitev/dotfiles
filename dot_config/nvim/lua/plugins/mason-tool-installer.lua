return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = "VeryLazy",
    config = function()
      require('mason-tool-installer').setup {
        ensure_installed = {
          { 
             'bash-language-server', auto_update = true },
             'lua-language-server',
             'clangd',
             'anakin-language-server',
             'rust-analyzer',
             'docker-compose-language-server',
             'dockerfile-language-server',
             'groovy-language-server'
        },

        auto_update = false,
        run_on_start = true,
        integrations = {
          ['mason-lspconfig'] = true,
          ['mason-null-ls'] = true,
          ['mason-nvim-dap'] = true,
        },
      }
    end
  }
}
