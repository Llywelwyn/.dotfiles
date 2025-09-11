local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.max_fps = 120
config.default_prog = { "pwsh.exe" }

config.font_size = 12.0
config.font = wezterm.font("FiraCode Nerd Font", {})
config.line_height = 1.2

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
config.integrated_title_buttons = { "Hide", "Close" }
config.integrated_title_button_alignment = "Right"
config.integrated_title_button_color = "auto"
config.initial_rows = 30
config.initial_cols = 80

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_max_width = 25

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.disable_default_key_bindings = true
config.keys = require("keys")

local theme = {}
if os.getenv("THEME") == "light" then
	theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").dawn
else
	theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").main
end

config.colors = theme.colors()
config.window_frame = theme.window_frame()
config.window_frame.font_size = 10
config.window_background_opacity = 1.0
config.text_background_opacity = 0.4
config.win32_system_backdrop = "Auto"

config.inactive_pane_hsb = { hue = 1.0, saturation = 0.7, brightness = 0.7 }

return config
