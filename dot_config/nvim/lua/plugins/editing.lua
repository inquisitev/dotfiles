-- better yank/paste
return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })
    end,
  },
  { "kkharji/sqlite.lua" },
  {
    "gbprod/yanky.nvim",
    recommended = true,
    desc = "Better Yank/Paste",
    event = "LazyFile",
    opts = {
      highlight = { timer = 150 },
      ring = { storage = "sqlite" },
    },
    requires = { "kkharji/sqlite.lua" },
    keys = {
      {
        "<leader>ty",
        function()
          if LazyVim.pick.picker.name == "telescope" then
            require("telescope").extensions.yank_history.yank_history({})
          else
            vim.cmd([[YankyRingHistory]])
          end
        end,
        mode = { "n", "x" },
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
    -- stylua: ignore
  },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      { "U", "<cmd>lua require('undotree').toggle()<cr>", desc = "Open undotree" },
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      {
        "gau",
        "<cmd>lua require('textcase').current_word('to_upper_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_upper_case",
      },
      {
        "gal",
        "<cmd>lua require('textcase').current_word('to_lower_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_lower_case",
      },
      {
        "gas",
        "<cmd>lua require('textcase').current_word('to_snake_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_snake_case",
      },
      {
        "gad",
        "<cmd>lua require('textcase').current_word('to_dash_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_dash_case",
      },
      {
        "gan",
        "<cmd>lua require('textcase').current_word('to_constant_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_constant_case",
      },
      {
        "gad",
        "<cmd>lua require('textcase').current_word('to_dot_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_dot_case",
      },
      {
        "ga,",
        "<cmd>lua require('textcase').current_word('to_comma_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_comma_case",
      },
      {
        "gaa",
        "<cmd>lua require('textcase').current_word('to_phrase_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_phrase_case",
      },
      {
        "gac",
        "<cmd>lua require('textcase').current_word('to_camel_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_camel_case",
      },
      {
        "gap",
        "<cmd>lua require('textcase').current_word('to_pascal_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_pascal_case",
      },
      {
        "gat",
        "<cmd>lua require('textcase').current_word('to_title_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_title_case",
      },
      {
        "gaf",
        "<cmd>lua require('textcase').current_word('to_path_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_path_case",
      },
      {
        "gaU",
        "<cmd>lua require('textcase').lsp_rename('to_upper_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_upper_case",
      },
      {
        "gaL",
        "<cmd>lua require('textcase').lsp_rename('to_lower_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_lower_case",
      },
      {
        "gaS",
        "<cmd>lua require('textcase').lsp_rename('to_snake_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_snake_case",
      },
      {
        "gaD",
        "<cmd>lua require('textcase').lsp_rename('to_dash_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_dash_case",
      },
      {
        "gaN",
        "<cmd>lua require('textcase').lsp_rename('to_constant_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_constant_case",
      },
      {
        "gaD",
        "<cmd>lua require('textcase').lsp_rename('to_dot_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_dot_case",
      },
      {
        "ga,",
        "<cmd>lua require('textcase').lsp_rename('to_comma_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_comma_case",
      },
      {
        "gaA",
        "<cmd>lua require('textcase').lsp_rename('to_phrase_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_phrase_case",
      },
      {
        "gaC",
        "<cmd>lua require('textcase').lsp_rename('to_camel_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_camel_case",
      },
      {
        "gaP",
        "<cmd>lua require('textcase').lsp_rename('to_pascal_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_pascal_case",
      },
      {
        "gaT",
        "<cmd>lua require('textcase').lsp_rename('to_title_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_title_case",
      },
      {
        "gaF",
        "<cmd>lua require('textcase').lsp_rename('to_path_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_path_case",
      },
      {
        "geu",
        "<cmd>lua require('textcase').operator('to_upper_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_upper_case",
      },
      {
        "gel",
        "<cmd>lua require('textcase').operator('to_lower_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_lower_case",
      },
      {
        "ges",
        "<cmd>lua require('textcase').operator('to_snake_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_snake_case",
      },
      {
        "ged",
        "<cmd>lua require('textcase').operator('to_dash_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_dash_case",
      },
      {
        "gen",
        "<cmd>lua require('textcase').operator('to_constant_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_constant_case",
      },
      {
        "ged",
        "<cmd>lua require('textcase').operator('to_dot_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_dot_case",
      },
      {
        "ge,",
        "<cmd>lua require('textcase').operator('to_comma_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_comma_case",
      },
      {
        "gea",
        "<cmd>lua require('textcase').operator('to_phrase_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_phrase_case",
      },
      {
        "gec",
        "<cmd>lua require('textcase').operator('to_camel_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_camel_case",
      },
      {
        "gep",
        "<cmd>lua require('textcase').operator('to_pascal_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_pascal_case",
      },
      {
        "get",
        "<cmd>lua require('textcase').operator('to_title_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_title_case",
      },
      {
        "gef",
        "<cmd>lua require('textcase').operator('to_path_case')<CR>",
        mode = { "n", "x" },
        desc = "TextCase to_path_case",
      },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    lazy = false,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
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
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
}
