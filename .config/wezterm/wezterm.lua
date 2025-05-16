-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Mocha (Gogh)"
config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font Mono", "Monaco" })

config.initial_cols = 120
config.initial_rows = 28

config.keys = {
  {
    key = '\\',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'CMD',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
}

-- and finally, return the configuration to wezterm
return config
