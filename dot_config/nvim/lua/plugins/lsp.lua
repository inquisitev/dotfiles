return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        anakin_language_server = {},
        clang = {},
        rust_analyzer = {},
      },
    },
  },
}
