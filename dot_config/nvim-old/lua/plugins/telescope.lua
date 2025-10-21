return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash", "c", "cpp", "html", "javascript", "json", "lua",
        "markdown", "python", "typescript", "vim", "yaml"
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
    end,
  },
}
