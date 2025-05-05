local wezterm = require("wezterm")
local config = {}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.color_scheme = "darkmoss (base16)"

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
   options = {
      icons_enabled = true,
      theme = "Catppuccin Mocha",
      color_overrides = {},
      section_separators = {
         left = wezterm.nerdfonts.pl_left_hard_divider,
         right = wezterm.nerdfonts.pl_right_hard_divider,
      },
      component_separators = {
         left = wezterm.nerdfonts.pl_left_soft_divider,
         right = wezterm.nerdfonts.pl_right_soft_divider,
      },
      tab_separators = {
         left = wezterm.nerdfonts.pl_left_hard_divider,
         right = wezterm.nerdfonts.pl_right_hard_divider,
      },
   },
   sections = {
      tab_active = {
         "index",
         { "parent", padding = 0 },
         "/",
         { "cwd", padding = { left = 0, right = 1 } },
         { "zoomed", padding = 0 },
      },
      tab_inactive = { "index", { "process", padding = { left = 0, right = 1 } } },
      tabline_a = { { "datetime", style = "%A, %B %d, %Y %I:%M %p" } },
      tabline_x = { "ram", "cpu" },
      tabline_y = { "battery" },
      tabline_z = { "hostname" },
   },
   extensions = {},
})

config.tab_bar_at_bottom = true
config.window_padding = {
   left = 0,
   right = 0,
   top = 0,
   bottom = 0,
}
return config
