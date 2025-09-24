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
theme.palette = {
	fujiWhite = "#8F8536", -- default
	oldWhite = "#C8C093", -- statuslines
	sumiInk4 = "#54546D", -- line numbers, fold column, non-text characters, float borders
	fujiGray = "#8F3F41", -- comments
	oniViolet = "#FFFF00", -- statements, keywords
	crystalBlue = "#A60000", -- functions and titles
	waveAqua2 = "#00CECE", -- types
	springViolet1 = "#FFFFFF", -- light foreground
	springViolet2 = "#FFFF00", -- brackets and punctuation
	springGreen = "#00BD00", -- strings
	boatYellow2 = "#FFFF00", -- operators
	sakuraPink = "#FFFFFF", -- numbers
	carpYellow = "#8F8536", -- identifiers
	surimiOrange = "#00CECE", -- constants, imports, booleans
	springBlue = "#A60000", -- specials and builtin functions
	peachRed = "#FFFF00", -- specials 2: exception handling, return
}

config.colors = {
	foreground = theme.palette.oldWhite,
	cursor_bg = theme.palette.oldWhite,
	cursor_border = theme.palette.oldWhite,
	selection_fg = theme.palette.oldWhite,
	ansi = {
		theme.palette.oldWhite,
		theme.palette.springBlue,
		theme.palette.surimiOrange,
		theme.palette.fujiWhite,
		theme.palette.surimiOrange, -- Cmdline
		theme.palette.peachRed, -- Donate button
		theme.palette.waveAqua2,
		theme.palette.fujiWhite,
	},
	brights = {
		theme.palette.oldWhite,
		theme.palette.crystalBlue, -- branches in git log?
		theme.palette.springGreen, -- strings
		theme.palette.crystalBlue, -- command
		theme.palette.surimiOrange, -- directories
		theme.palette.boatYellow2, -- current directory
		theme.palette.surimiOrange, -- branch name
		theme.palette.boatYellow2,
	},
}

config.window_background_opacity = 0.95
config.text_background_opacity = 0.20
config.win32_system_backdrop = "Auto"
config.window_background_gradient = {
	colors = {
		"#241515",
		"#331717",
	},
	orientation = {
		Radial = {
			cx = 0.75,
			cy = 0.65,
			radius = 1.0,
		},
	},
}

config.inactive_pane_hsb = { hue = 1.0, saturation = 0.7, brightness = 0.7 }

return config
