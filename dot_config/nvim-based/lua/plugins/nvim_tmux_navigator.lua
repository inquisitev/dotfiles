{
    "alexghergh/nvim-tmux-navigation",
    config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })
    end,
  },


vim.pack.add({ "alexghergh/nvim-tmux-navigation" }, {
   build = ":TSUpdate", -- ensures parsers are kept up to date
   config = function()
      local nvim_tmux_nav = require("nvim-tmux-navigation")

      nvim_tmux_nav.setup({
        disable_when_zoomed = true, -- defaults to false
      })
    end
})
