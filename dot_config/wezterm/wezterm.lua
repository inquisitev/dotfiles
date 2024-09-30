local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

local act = wezterm.action
config.keys = {
	{
		key = "-",
		mods = "SHIFT|CMD",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "=",
		mods = "SHIFT|CMD",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
}

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
		print(args)
	end

	-- Set a workspace for coding on a current project
	-- Top pane is for the editor, bottom pane is for the build tool

	local tab, code_pane, window = mux.spawn_window({
		workspace = "jdnative-ws",
		args = args,
	})

	local tab2, appsync_pane, w = window:spawn_tab({
		workspce = "g5-debugging",
		args = args,
	})
	local log_pane = appsync_pane:split({
		direction = "Right",
		size = 0.7,
	})
	-- may as well kick off a build in that pane
	appsync_pane:send_text("appsync \n")
	log_pane:send_text("ssh g5 \"journalctl -fu cfd-services | grep -Eiv \'OCD\'\" \n")
  code_pane.send_text("ssh jdnative")
	-- We want to startup in the coding workspace
	mux.set_active_workspace("jdnative-ws")
end)
config.color_scheme = "Catppuccin Mocha"

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
return config
