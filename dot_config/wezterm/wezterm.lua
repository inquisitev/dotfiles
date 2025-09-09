local wezterm = require("wezterm")
local config = {}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.color_scheme = "Argonaut"
config.hide_tab_bar_if_only_one_tab = true


config.tab_bar_at_bottom = true
config.window_padding = {
   left = 0,
   right = 0,
   top = 0,
   bottom = 0,
}
return config
