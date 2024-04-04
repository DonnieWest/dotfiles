local wezterm = require 'wezterm'
local config = {}
config.font = wezterm.font 'Victor Mono SemiBold'
config.font_size = 22.0
config.enable_wayland = true
config.enable_tab_bar = false
config.default_cursor_style = 'BlinkingBar'

config.window_close_confirmation = 'NeverPrompt'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.keys = {
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

config.colors = {
  foreground = '#e6e9ea',
  background = '#03090e',
  cursor_bg = '#52ad70',
  cursor_fg = '#03090e',
  cursor_border = '#52ad70',
  selection_fg = '#000000',
  selection_bg = '#fffacd',
  scrollbar_thumb = '#222222',
  split = '#444444',
  ansi = {
    '#03090e',
    '#d12820',
    '#ddecb2',
    '#ffb610',
    '#195466',
    '#4e5166',
    '#33859e',
    '#e6e9ea',
  },
  brights = {
    '#061620',
    '#ecb2c0',
    '#091f2e',
    '#9da5ab',
    '#223543',
    '#27b8c2',
    '#f5fafd',
    '#d3ebe9',
  },
  indexed = { [136] = '#af8700' },
  compose_cursor = '#ffa500',
  copy_mode_active_highlight_bg = { Color = '#000000' },
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },
  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },
}
return config

