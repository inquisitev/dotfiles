return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        -- Formatters
        "clang-format", -- C/C++
        "black", -- Python
        "isort", -- Python imports
        "rustfmt", -- Rust
        "google-java-format", -- Java
        "cmake-format", -- CMake
        "sqlfluff", -- SQL
        "shfmt", -- Bash/Shell
        "taplo", -- TOML
        "prettier", -- JSON, INI, and more
      },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Add formatters for your languages
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        cpp = { "clang-format" },
        c = { "clang-format" },
        qml = { "qmlformat" },
        python = { "black", "isort" }, -- or { "ruff_format", "ruff_organize_imports" }
        rust = { "rustfmt" },
        java = { "google-java-format" }, -- or "clang-format"
        cmake = { "cmake_format" },
        sql = { "sqlfluff" }, -- or "sql_formatter"
        bash = { "shfmt" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        toml = { "taplo" },
        ini = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
      })

      -- Custom qmlformat if needed
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
}
