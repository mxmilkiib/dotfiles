-- WezTerm configuration
-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder()

-- Appearance / fonts
config.font = wezterm.font('Hack Nerd Font Mono')
config.font_size = 12.0

-- Keep a large scrollback buffer for heavy / fast scrolling output
config.scrollback_lines = 100000

-- Let Ctrl-held mouse events reach WezTerm even inside mouse-aware TUIs
-- (e.g. neovim) so the wheel-zoom bindings below actually fire
config.bypass_mouse_reporting_modifiers = 'CTRL'

-- Plain mouse wheel scrolls 3 lines per notch (Wayland defaults to a full page)
-- Ctrl + mouse wheel zooms text in / out
-- mouse_reporting defaults to false (fires in normal shell);
-- bypass_mouse_reporting_modifiers='CTRL' above makes it also fire inside TUIs
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(-3),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(3),
  },
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'CTRL',
    action = act.IncreaseFontSize,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'CTRL',
    action = act.DecreaseFontSize,
  },
}

return config
