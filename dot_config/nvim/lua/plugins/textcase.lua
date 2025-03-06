return {
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      {"gau","<cmd>lua require('textcase').current_word('to_upper_case')<CR>", mode = {"n", "x"}, desc="TextCase to_upper_case"},
      {"gal","<cmd>lua require('textcase').current_word('to_lower_case')<CR>", mode = {"n", "x"}, desc="TextCase to_lower_case"},
      {"gas","<cmd>lua require('textcase').current_word('to_snake_case')<CR>", mode = {"n", "x"}, desc="TextCase to_snake_case"},
      {"gad","<cmd>lua require('textcase').current_word('to_dash_case')<CR>", mode = {"n", "x"}, desc="TextCase to_dash_case"},
      {"gan","<cmd>lua require('textcase').current_word('to_constant_case')<CR>", mode = {"n", "x"}, desc="TextCase to_constant_case"},
      {"gad","<cmd>lua require('textcase').current_word('to_dot_case')<CR>", mode = {"n", "x"}, desc="TextCase to_dot_case"},
      {"ga,","<cmd>lua require('textcase').current_word('to_comma_case')<CR>", mode = {"n", "x"}, desc="TextCase to_comma_case"},
      {"gaa","<cmd>lua require('textcase').current_word('to_phrase_case')<CR>", mode = {"n", "x"}, desc="TextCase to_phrase_case"},
      {"gac","<cmd>lua require('textcase').current_word('to_camel_case')<CR>", mode = {"n", "x"}, desc="TextCase to_camel_case"},
      {"gap","<cmd>lua require('textcase').current_word('to_pascal_case')<CR>", mode = {"n", "x"}, desc="TextCase to_pascal_case"},
      {"gat","<cmd>lua require('textcase').current_word('to_title_case')<CR>", mode = {"n", "x"}, desc="TextCase to_title_case"},
      {"gaf","<cmd>lua require('textcase').current_word('to_path_case')<CR>", mode = {"n", "x"}, desc="TextCase to_path_case"},
      {"gaU","<cmd>lua require('textcase').lsp_rename('to_upper_case')<CR>", mode = {"n", "x"}, desc="TextCase to_upper_case"},
      {"gaL","<cmd>lua require('textcase').lsp_rename('to_lower_case')<CR>", mode = {"n", "x"}, desc="TextCase to_lower_case"},
      {"gaS","<cmd>lua require('textcase').lsp_rename('to_snake_case')<CR>", mode = {"n", "x"}, desc="TextCase to_snake_case"},
      {"gaD","<cmd>lua require('textcase').lsp_rename('to_dash_case')<CR>", mode = {"n", "x"}, desc="TextCase to_dash_case"},
      {"gaN","<cmd>lua require('textcase').lsp_rename('to_constant_case')<CR>", mode = {"n", "x"}, desc="TextCase to_constant_case"},
      {"gaD","<cmd>lua require('textcase').lsp_rename('to_dot_case')<CR>", mode = {"n", "x"}, desc="TextCase to_dot_case"},
      {"ga,","<cmd>lua require('textcase').lsp_rename('to_comma_case')<CR>", mode = {"n", "x"}, desc="TextCase to_comma_case"},
      {"gaA","<cmd>lua require('textcase').lsp_rename('to_phrase_case')<CR>", mode = {"n", "x"}, desc="TextCase to_phrase_case"},
      {"gaC","<cmd>lua require('textcase').lsp_rename('to_camel_case')<CR>", mode = {"n", "x"}, desc="TextCase to_camel_case"},
      {"gaP","<cmd>lua require('textcase').lsp_rename('to_pascal_case')<CR>", mode = {"n", "x"}, desc="TextCase to_pascal_case"},
      {"gaT","<cmd>lua require('textcase').lsp_rename('to_title_case')<CR>", mode = {"n", "x"}, desc="TextCase to_title_case"},
      {"gaF","<cmd>lua require('textcase').lsp_rename('to_path_case')<CR>", mode = {"n", "x"}, desc="TextCase to_path_case"},
      {"geu","<cmd>lua require('textcase').operator('to_upper_case')<CR>", mode = {"n", "x"}, desc="TextCase to_upper_case"},
      {"gel","<cmd>lua require('textcase').operator('to_lower_case')<CR>", mode = {"n", "x"}, desc="TextCase to_lower_case"},
      {"ges","<cmd>lua require('textcase').operator('to_snake_case')<CR>", mode = {"n", "x"}, desc="TextCase to_snake_case"},
      {"ged","<cmd>lua require('textcase').operator('to_dash_case')<CR>", mode = {"n", "x"}, desc="TextCase to_dash_case"},
      {"gen","<cmd>lua require('textcase').operator('to_constant_case')<CR>", mode = {"n", "x"}, desc="TextCase to_constant_case"},
      {"ged","<cmd>lua require('textcase').operator('to_dot_case')<CR>", mode = {"n", "x"}, desc="TextCase to_dot_case"},
      {"ge,","<cmd>lua require('textcase').operator('to_comma_case')<CR>", mode = {"n", "x"}, desc="TextCase to_comma_case"},
      {"gea","<cmd>lua require('textcase').operator('to_phrase_case')<CR>", mode = {"n", "x"}, desc="TextCase to_phrase_case"},
      {"gec","<cmd>lua require('textcase').operator('to_camel_case')<CR>", mode = {"n", "x"}, desc="TextCase to_camel_case"},
      {"gep","<cmd>lua require('textcase').operator('to_pascal_case')<CR>", mode = {"n", "x"}, desc="TextCase to_pascal_case"},
      {"get","<cmd>lua require('textcase').operator('to_title_case')<CR>", mode = {"n", "x"}, desc="TextCase to_title_case"},
      {"gef","<cmd>lua require('textcase').operator('to_path_case')<CR>", mode = {"n", "x"}, desc="TextCase to_path_case"},
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  }
}
