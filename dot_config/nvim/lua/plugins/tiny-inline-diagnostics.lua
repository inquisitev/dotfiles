vim.pack.add({ { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" } })
require("tiny-inline-diagnostic").setup({
   signs = {
      left = "",
      right = "",
      diag = "●",
      arrow = "    ",
      up_arrow = "    ",
      vertical = " │",
      vertical_end = " └",
   },
   blend = {
      factor = 0.22,
   },
    -- Customize highlight groups for colors
    -- Use Neovim highlight group names or hex colors like "#RRGGBB"
    hi = {
        error = "DiagnosticError",     -- Highlight for error diagnostics
        warn = "DiagnosticWarn",       -- Highlight for warning diagnostics
        info = "DiagnosticInfo",       -- Highlight for info diagnostics
        hint = "DiagnosticHint",       -- Highlight for hint diagnostics
        arrow = "NonText",             -- Highlight for the arrow pointing to diagnostic
        mixing_color = "Normal",       -- Color to blend background with (or "None")
    },
})
