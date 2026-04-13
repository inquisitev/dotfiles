local M = {};
function M.colorscheme()
   vim.cmd("highlight clear")
   vim.api.nvim_set_hl(0, "@function", { fg = "#61afef" })
   vim.api.nvim_set_hl(0, "@variable", { fg = "#E4B96D" })
   vim.api.nvim_set_hl(0, "@comment", { fg = "#20532A", italic = true })
   vim.api.nvim_set_hl(0, "@boolean", { fg = "#FFD229"  })
   vim.api.nvim_set_hl(0, "@Identifier", { fg = "#E5BA6D"  })
   vim.api.nvim_set_hl(0, "@string", { fg = "#2DFF10"  })
   vim.api.nvim_set_hl(0, "@string", { fg = "#2DFF10"  })
-- #B98356
   vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { fg = "#FFD229", italic = true })

   vim.api.nvim_set_hl(0, "@keyword", { fg = "#c678dd", italic = true })
   vim.api.nvim_set_hl(0, "cInclude", { fg = "#c680dd", italic = true })
   vim.api.nvim_set_hl(0, "cIncluded", { fg = "#FFD229", italic = true })
   vim.api.nvim_set_hl(0, "cConditional", { fg = "#FFD229", italic = true })
   vim.api.nvim_set_hl(0, "@type", { fg = "#c680dd", italic = true })
   vim.api.nvim_set_hl(0, "cStatement", { fg = "#c680dd", italic = true })



   vim.api.nvim_set_hl(0, "@lsp.type.operator", { fg = "#c678dd" })
   vim.api.nvim_set_hl(0, "@lsp.type.property", { fg = "#E4B96D" })
   vim.api.nvim_set_hl(0, "@lsp.type.macro", { fg = "#c678dd" })
   vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = "#c678dd" })
   vim.api.nvim_set_hl(0, "@Statement", { fg = "#c678dd" })

end
return M;

