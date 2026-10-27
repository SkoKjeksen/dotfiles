local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_wayland = false
config.color_scheme = 'Gruvbox dark, medium (base16)'
config.initial_cols = 220
config.initial_rows = 50
config.font_size = 14
config.window_decorations = "NONE"

config.window_background_opacity = 0.95

config.leader = {key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  
  --Split
  { key = "-", mods = "LEADER", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "|", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  --navigation
  { key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "CTRL|ALT", action = wezterm.action.ActivateTabRelative(1)},
  { key = "h", mods = "CTRL|ALT", action = wezterm.action.ActivateTabRelative(-1)},
  --resizing
  { key = "l", mods = "ALT", action = wezterm.action.AdjustPaneSize { "Right", 5} },
  { key = "h", mods = "ALT", action = wezterm.action.AdjustPaneSize { "Left", 5} },
  { key = "j", mods = "ALT", action = wezterm.action.AdjustPaneSize { "Down", 5} },
  { key = "k", mods = "ALT", action = wezterm.action.AdjustPaneSize { "Up", 5} },
  --closing
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = "w", mods = "CTRL" , action = wezterm.action.CloseCurrentTab { confirm = true } },

  {key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain")},
}

return config
