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
	local project_dir = wezterm.home_dir .. ".config/"

	local tab, build_pane, window = mux.spawn_window({
		workspace = "coding",
		cwd = project_dir,
		args = args,
	})

	local tab2, b2, w = window:spawn_tab({

		workspce = "coding0",
		cwd = project_dir,
		args = args,
	})

	local editor_pane = build_pane:split({
		direction = "Top",
		size = 0.9,
		cwd = project_dir,
	})
	local deploy_pane = build_pane:split({
		direction = "Right",
		size = 0.6,
		cwd = project_dir,
	})
	-- may as well kick off a build in that pane
	build_pane:send_text("cargo build\n")
	editor_pane:send_text("nvim .\n")

	-- We want to startup in the coding workspace
	mux.set_active_workspace("coding")
end)
config.color_scheme = "Catppuccin Mocha"

return config
