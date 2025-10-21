return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "python",
        "groovy",
        "json",
        "rust",
        "cpp",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "clangd-format",
          "black",
          "isort",
          "google-java-format",
          "cmake-format",
          "sqlfluff",
          "shfmt",
          "taplo",
          "prettier",
          "bash-language-server",
          "lua-language-server",
          "vim-language-server",
          "clangd",
          "pyright",
          "python-lsp-server",
          "black",
          "isort",
          "rustfmt",
          "qmlfmt",
          "google-java-format",
          "clang-format",
          "tree-sitter-cli@v0.24.7"
        },

        auto_update = false,

        run_on_start = true,

        start_delay = 3000,
        debounce_hours = 5,
        integrations = {
          ["mason-lspconfig"] = true,
          ["mason-null-ls"] = true,
          ["mason-nvim-dap"] = true,
        },
      })
    end,
  },
}
