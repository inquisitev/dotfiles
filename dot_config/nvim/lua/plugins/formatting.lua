return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        cpp = { "clang-format" },
        c = { "clang-format" },
        qml = { "qmlformat" },
        python = { "black", "isort" },
        rust = { "rustfmt" },
        java = { "google-java-format" },
        cmake = { "cmake_format" },
        sql = { "sqlfluff" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        toml = { "taplo" },
        ini = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
      })

      opts.formatters = {
        qmlformat = {
          command = "qmlformat",
          args = { "-i", "$FILENAME" },
          stdin = false,
        },
      }

      return opts
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      -- Optional: nothing needed if you're happy with default config
    end,
  },
}
