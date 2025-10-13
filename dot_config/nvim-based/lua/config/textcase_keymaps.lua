local map = vim.keymap.set

map(
   { "n", "x" },
   "gau",
   "<cmd>lua require('textcase').current_word('to_upper_case')<CR>",
   { desc = "TextCase to_upper_case" }
)
map(
   { "n", "x" },
   "gal",
   "<cmd>lua require('textcase').current_word('to_lower_case')<CR>",
   { desc = "TextCase to_lower_case" }
)
map(
   { "n", "x" },
   "gas",
   "<cmd>lua require('textcase').current_word('to_snake_case')<CR>",
   { desc = "TextCase to_snake_case" }
)
map(
   { "n", "x" },
   "gad",
   "<cmd>lua require('textcase').current_word('to_dash_case')<CR>",
   { desc = "TextCase to_dash_case" }
)
map(
   { "n", "x" },
   "gan",
   "<cmd>lua require('textcase').current_word('to_constant_case')<CR>",
   { desc = "TextCase to_constant_case" }
)
map(
   { "n", "x" },
   "ga.",
   "<cmd>lua require('textcase').current_word('to_dot_case')<CR>",
   { desc = "TextCase to_dot_case" }
)
map(
   { "n", "x" },
   "ga,",
   "<cmd>lua require('textcase').current_word('to_comma_case')<CR>",
   { desc = "TextCase to_comma_case" }
)
map(
   { "n", "x" },
   "gaa",
   "<cmd>lua require('textcase').current_word('to_phrase_case')<CR>",
   { desc = "TextCase to_phrase_case" }
)
map(
   { "n", "x" },
   "gac",
   "<cmd>lua require('textcase').current_word('to_camel_case')<CR>",
   { desc = "TextCase to_camel_case" }
)
map(
   { "n", "x" },
   "gap",
   "<cmd>lua require('textcase').current_word('to_pascal_case')<CR>",
   { desc = "TextCase to_pascal_case" }
)
map(
   { "n", "x" },
   "gat",
   "<cmd>lua require('textcase').current_word('to_title_case')<CR>",
   { desc = "TextCase to_title_case" }
)
map(
   { "n", "x" },
   "gaf",
   "<cmd>lua require('textcase').current_word('to_path_case')<CR>",
   { desc = "TextCase to_path_case" }
)

-- lsp_rename
map(
   { "n", "x" },
   "gaU",
   "<cmd>lua require('textcase').lsp_rename('to_upper_case')<CR>",
   { desc = "TextCase LSP to_upper_case" }
)
map(
   { "n", "x" },
   "gaL",
   "<cmd>lua require('textcase').lsp_rename('to_lower_case')<CR>",
   { desc = "TextCase LSP to_lower_case" }
)
map(
   { "n", "x" },
   "gaS",
   "<cmd>lua require('textcase').lsp_rename('to_snake_case')<CR>",
   { desc = "TextCase LSP to_snake_case" }
)
map(
   { "n", "x" },
   "gaD",
   "<cmd>lua require('textcase').lsp_rename('to_dash_case')<CR>",
   { desc = "TextCase LSP to_dash_case" }
)
map(
   { "n", "x" },
   "gaN",
   "<cmd>lua require('textcase').lsp_rename('to_constant_case')<CR>",
   { desc = "TextCase LSP to_constant_case" }
)
map(
   { "n", "x" },
   "ga.",
   "<cmd>lua require('textcase').lsp_rename('to_dot_case')<CR>",
   { desc = "TextCase LSP to_dot_case" }
)
map(
   { "n", "x" },
   "ga,",
   "<cmd>lua require('textcase').lsp_rename('to_comma_case')<CR>",
   { desc = "TextCase LSP to_comma_case" }
)
map(
   { "n", "x" },
   "gaA",
   "<cmd>lua require('textcase').lsp_rename('to_phrase_case')<CR>",
   { desc = "TextCase LSP to_phrase_case" }
)
map(
   { "n", "x" },
   "gaC",
   "<cmd>lua require('textcase').lsp_rename('to_camel_case')<CR>",
   { desc = "TextCase LSP to_camel_case" }
)
map(
   { "n", "x" },
   "gaP",
   "<cmd>lua require('textcase').lsp_rename('to_pascal_case')<CR>",
   { desc = "TextCase LSP to_pascal_case" }
)
map(
   { "n", "x" },
   "gaT",
   "<cmd>lua require('textcase').lsp_rename('to_title_case')<CR>",
   { desc = "TextCase LSP to_title_case" }
)
map(
   { "n", "x" },
   "gaF",
   "<cmd>lua require('textcase').lsp_rename('to_path_case')<CR>",
   { desc = "TextCase LSP to_path_case" }
)

-- operator
map(
   { "n", "x" },
   "geu",
   "<cmd>lua require('textcase').operator('to_upper_case')<CR>",
   { desc = "TextCase operator to_upper_case" }
)
map(
   { "n", "x" },
   "gel",
   "<cmd>lua require('textcase').operator('to_lower_case')<CR>",
   { desc = "TextCase operator to_lower_case" }
)
map(
   { "n", "x" },
   "ges",
   "<cmd>lua require('textcase').operator('to_snake_case')<CR>",
   { desc = "TextCase operator to_snake_case" }
)
map(
   { "n", "x" },
   "ged",
   "<cmd>lua require('textcase').operator('to_dash_case')<CR>",
   { desc = "TextCase operator to_dash_case" }
)
map(
   { "n", "x" },
   "gen",
   "<cmd>lua require('textcase').operator('to_constant_case')<CR>",
   { desc = "TextCase operator to_constant_case" }
)
map(
   { "n", "x" },
   "ge.",
   "<cmd>lua require('textcase').operator('to_dot_case')<CR>",
   { desc = "TextCase operator to_dot_case" }
)
map(
   { "n", "x" },
   "ge,",
   "<cmd>lua require('textcase').operator('to_comma_case')<CR>",
   { desc = "TextCase operator to_comma_case" }
)
map(
   { "n", "x" },
   "gea",
   "<cmd>lua require('textcase').operator('to_phrase_case')<CR>",
   { desc = "TextCase operator to_phrase_case" }
)
map(
   { "n", "x" },
   "gec",
   "<cmd>lua require('textcase').operator('to_camel_case')<CR>",
   { desc = "TextCase operator to_camel_case" }
)
map(
   { "n", "x" },
   "gep",
   "<cmd>lua require('textcase').operator('to_pascal_case')<CR>",
   { desc = "TextCase operator to_pascal_case" }
)
map(
   { "n", "x" },
   "get",
   "<cmd>lua require('textcase').operator('to_title_case')<CR>",
   { desc = "TextCase operator to_title_case" }
)
map(
   { "n", "x" },
   "gef",
   "<cmd>lua require('textcase').operator('to_path_case')<CR>",
   { desc = "TextCase operator to_path_case" }
)
