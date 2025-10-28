-- File: lua/plugins/snacks-telescope.lua
return {
  {
    "folke/snacks.nvim",
    opts = {
       terminal = { enabled = false},
      picker = {
        -- global default for Snacks pickers
        hidden = true,
        sources = {
          files = {
            hidden = true, -- only for file picker
          },
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      -- merge into existing defaults
      local telescope = require("telescope")
      telescope.setup({
        defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
          file_ignore_patterns = {}, -- optional: clear ignores
        }),
        pickers = {
          find_files = {
            hidden = true, -- show dotfiles
          },
          live_grep = {
            additional_args = function(_)
              return { "--hidden" }
            end,
          },
        },
      })
    end,
  },
}
