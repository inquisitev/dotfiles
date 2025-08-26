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
        "uncrustify", -- C/C++/Java/C#
      },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        cpp = { "uncrustify", "clang-format" },
        c = { "clang-format", "uncrustify" },
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
        uncrustify = {
          command = "uncrustify",
          args = function()
            local cfg_path = vim.fn.findfile("uncrustify.cfg", ".;")
            if cfg_path == "" then
              local current_dir = vim.fn.getcwd()
              local home_dir = vim.fn.expand("$HOME")
              local one_level_cfg = vim.fn.expand(home_dir .. "/" .. vim.fn.fnamemodify(current_dir, ":h:t") .. "/" .. "uncrustify/uncrustify.cfg")
              print("test: " .. one_level_cfg)
              if vim.fn.filereadable(one_level_cfg) == 1 then
                cfg_path = one_level_cfg
              else
                cfg_path = vim.fn.expand("$HOME/.config/uncrustify/uncrustify.cfg")
              end

              print("Uncrustify config path:", cfg_path)
            end
            return { "-c", cfg_path, "--replace", "$FILENAME" }
          end,
          temp_file = false,
          stdin = false,
        },
        cmake_custom_formatter = {
          command = "cmake-format",
          args = function()
            return {"-c", vim.fn.expand("$HOME") .. "/.local/share/chezmoi/dot_config/cmake_format/config.py", "-i", "$FILENAME"}
          end,
          temp_file = false,
          stdin = false,
        }
      }

      vim.api.nvim_create_autocmd("User", {
       pattern = "ConformPost",
        callback = function()
          print("Formatting finished!")
        end,
      })

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

