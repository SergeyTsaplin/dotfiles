-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha (Gogh)"
config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font Mono", "Monaco" })
config.hide_tab_bar_if_only_one_tab = true

config.initial_cols = 120
config.initial_rows = 28

config.keys = {
	{
		key = "\\",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "CMD",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "W",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "P",
		mods = "CMD",
		action = wezterm.action.ActivateCommandPalette,
	},
}

-- and finally, return the configuration to wezterm
return config
