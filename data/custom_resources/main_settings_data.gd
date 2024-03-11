extends Resource

class_name MainSettingsData



@export var window_width: int
@export var window_height: int
@export var monitor_mode: int
@export var borderless: bool
@export var last_monitor: int #is this used?
@export var current_monitor: int

@export var theme_title_size: int
@export var theme_sub_title_size: int
@export var theme_large_size: int
@export var theme_medium_size: int
@export var theme_small_size: int
@export var theme_font_color: Color
@export var theme_outlines_color: Color
@export var theme_background_color: Color
@export var theme_border_line_color: Color
@export var theme_primary_color: Color
@export var theme_secondary_color: Color
@export var theme_tertiary_color: Color
@export var theme_quaternary_color: Color
@export var theme_quinary_color: Color
@export var theme_button_default_color: Color
@export var theme_button_disabled_color: Color
@export var theme_button_focus_color: Color
@export var theme_button_pressed_color: Color
@export var theme_button_hover_color: Color
@export var theme_transparency_default_color: Color
@export var theme_transparency_warning_color: Color
@export var theme_color_palettes: Dictionary
@export var theme_current_color_palette: String

@export var alpha_for_transparencies: float = 0.6



func export_json_from_resouce() -> Dictionary:
	var json_data: Dictionary = {
		"window_width": window_width,
		"window_height": window_height,
		"monitor_mode": monitor_mode,
		"borderless": borderless,
		"last_monitor": last_monitor,
		"current_monitor": current_monitor,
		"theme_title_size": theme_title_size,
		"theme_sub_title_size": theme_sub_title_size,
		"theme_large_size": theme_large_size,
		"theme_medium_size": theme_medium_size,
		"theme_small_size": theme_small_size,
		"theme_color_palettes": theme_color_palettes,
		"theme_current_color_palette": theme_current_color_palette,
	}
	return json_data


func import_json_to_resource(data_parameter: Dictionary) -> void:
	window_width = data_parameter.window_width
	window_height = data_parameter.window_height
	monitor_mode = data_parameter.monitor_mode
	borderless = data_parameter.borderless
	last_monitor = data_parameter.last_monitor
	current_monitor = data_parameter.current_monitor
	theme_title_size = data_parameter.theme_title_size
	theme_sub_title_size = data_parameter.theme_sub_title_size
	theme_large_size = data_parameter.theme_large_size
	theme_medium_size = data_parameter.theme_medium_size
	theme_small_size = data_parameter.theme_small_size
	theme_color_palettes = data_parameter.theme_color_palettes
	theme_current_color_palette = data_parameter.theme_current_color_palette


func reset_settings_all_main() -> void:
	reset_settings_display()
	reset_settings_theme()


func reset_settings_display() -> void:
	window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	monitor_mode = 1
	last_monitor = 1
	borderless = true
	prints("Main Settings reset to defaults.")


func reset_settings_theme() -> void:
	reset_settings_theme_text_size()
	reset_settings_theme_colors()


func reset_settings_theme_text_size() -> void:
	theme_title_size = 100
	theme_sub_title_size = 60
	theme_large_size = 40
	theme_medium_size = 30
	theme_small_size = 20


func reset_settings_theme_colors() -> void:
	theme_current_color_palette = "green"
	theme_color_palettes = generate_color_sets()


func generate_color_sets() -> Dictionary:
	var new_color_sets := {
		"red": color_set_red(),
		"orange": color_set_orange(),
		"yellow": color_set_yellow(),
		"green": color_set_green(),
		"blue": color_set_blue(),
		"purple": color_set_purple(),
		"pink": color_set_pink(),
		"neutral": color_set_neutral(),
		"red custom": color_set_red(),
		"orange custom": color_set_orange(),
		"yellow custom": color_set_yellow(),
		"green custom": color_set_green(),
		"blue custom": color_set_blue(),
		"purple custom": color_set_purple(),
		"pink custom": color_set_pink(),
		"neutral custom": color_set_neutral(),
	}
	return new_color_sets


func color_set_red() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.FIREBRICK.to_html(),
		"theme_primary_color": Color.DARK_RED.to_html(),
		"theme_secondary_color": Color(0.91670173406601, 0.1148528829217, 0.00000077009202).to_html(),
		"theme_tertiary_color": Color.CRIMSON.to_html(),
		"theme_quaternary_color": Color(0.26208853721619, 0.00000026171097, 0.0000000962615).to_html(),
		"theme_quinary_color": Color(0.98803395032883, 0.4358266890049, 0.38310959935188).to_html(),
		"theme_button_default_color": Color.DARK_VIOLET.to_html(),
		"theme_button_disabled_color": Color.PEACH_PUFF.to_html(),
		"theme_button_focus_color": Color.ORANGE_RED.to_html(),
		"theme_button_pressed_color": Color.VIOLET.to_html(),
		"theme_button_hover_color": Color.BLUE_VIOLET.to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_orange() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.ORANGE_RED.to_html(),
		"theme_primary_color": Color(0.70434302091599, 0.17934420704842, 0).to_html(),
		"theme_secondary_color": Color(1, 0.43137255311012, 0).to_html(),
		"theme_tertiary_color": Color(0.84705883264542, 0.52549022436142, 0).to_html(),
		"theme_quaternary_color": Color.ORANGE.to_html(),
		"theme_quinary_color": Color(0.93504923582077, 0.31310641765594, 0).to_html(),
		"theme_button_default_color": Color.DARK_RED.to_html(),
		"theme_button_disabled_color": Color(0.27412435412407, 0.15679737925529, 0).to_html(),
		"theme_button_focus_color": Color.YELLOW.to_html(),
		"theme_button_pressed_color": Color.RED.to_html(),
		"theme_button_hover_color": Color(0.67901474237442, 0.00000116717069, 0.00000038504601).to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_yellow() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.GOLDENROD.to_html(),
		"theme_primary_color": Color.DARK_GOLDENROD.to_html(),
		"theme_secondary_color": Color(0.76078432798386, 0.73725491762161, 0).to_html(),
		"theme_tertiary_color": Color(0.54117649793625, 0.54509806632996, 0).to_html(),
		"theme_quaternary_color": Color.YELLOW.to_html(),
		"theme_quinary_color": Color(1, 1, 0.5686274766922).to_html(),
		"theme_button_default_color": Color.ORANGE_RED.to_html(),
		"theme_button_disabled_color": Color.LIGHT_YELLOW.to_html(),
		"theme_button_focus_color": Color.GREEN_YELLOW.to_html(),
		"theme_button_pressed_color": Color(1, 0.43137255311012, 0).to_html(),
		"theme_button_hover_color": Color(0.70434302091599, 0.17934420704842, 0).to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_green() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color(0.03137255087495, 0.2392156869173, 0.13725490868092).to_html(),
		"theme_primary_color": Color(0.01568627543747, 0.10588235408068, 0.0627451017499).to_html(),
		"theme_secondary_color": Color(0.24313725531101, 0.64705884456635, 0).to_html(),
		"theme_tertiary_color": Color(0.01568627543747, 0.34901961684227, 0.26274511218071).to_html(),
		"theme_quaternary_color": Color(0, 0.27843138575554, 0).to_html(),
		"theme_quinary_color": Color.YELLOW_GREEN.to_html(),
		"theme_button_default_color": Color.DARK_GOLDENROD.to_html(),
		"theme_button_disabled_color": Color(0.26701414585114, 0.11950565129519, 0.01849975250661).to_html(),
		"theme_button_focus_color": Color(0, 0.23137255012989, 0.34509804844856).to_html(),
		"theme_button_pressed_color": Color.GOLD.to_html(),
		"theme_button_hover_color": Color.GOLDENROD.to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_blue() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.DARK_BLUE.to_html(),
		"theme_primary_color": Color.MIDNIGHT_BLUE.to_html(),
		"theme_secondary_color": Color.ROYAL_BLUE.to_html(),
		"theme_tertiary_color": Color.MEDIUM_BLUE.to_html(),
		"theme_quaternary_color": Color.LIGHT_SKY_BLUE.to_html(),
		"theme_quinary_color": Color.DEEP_SKY_BLUE.to_html(),
		"theme_button_default_color": Color.LIGHT_SEA_GREEN.to_html(),
		"theme_button_disabled_color": Color.LIGHT_BLUE.to_html(),
		"theme_button_focus_color": Color.REBECCA_PURPLE.to_html(),
		"theme_button_pressed_color": Color.MEDIUM_AQUAMARINE.to_html(),
		"theme_button_hover_color": Color.AQUAMARINE.to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_purple() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.REBECCA_PURPLE.to_html(),
		"theme_primary_color": Color(0.24612122774124, 0.10968459397554, 0.38070160150528).to_html(),
		"theme_secondary_color": Color(0.57852011919022, 0.34901505708694, 0.82685434818268).to_html(),
		"theme_tertiary_color": Color.PURPLE.to_html(),
		"theme_quaternary_color": Color.MEDIUM_PURPLE.to_html(),
		"theme_quinary_color": Color.WEB_PURPLE.to_html(),
		"theme_button_default_color": Color.DARK_BLUE.to_html(),
		"theme_button_disabled_color": Color.LAVENDER.to_html(),
		"theme_button_focus_color": Color.CRIMSON.to_html(),
		"theme_button_pressed_color": Color.BLUE.to_html(),
		"theme_button_hover_color": Color.MEDIUM_BLUE.to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_pink() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.MAROON.to_html(),
		"theme_primary_color": Color.PINK.to_html(),
		"theme_secondary_color": Color.PALE_VIOLET_RED.to_html(),
		"theme_tertiary_color": Color.HOT_PINK.to_html(),
		"theme_quaternary_color": Color.DEEP_PINK.to_html(),
		"theme_quinary_color": Color.MEDIUM_VIOLET_RED.to_html(),
		"theme_button_default_color": Color.DARK_VIOLET.to_html(),
		"theme_button_disabled_color": Color.PEACH_PUFF.to_html(),
		"theme_button_focus_color": Color.WEB_MAROON.to_html(),
		"theme_button_pressed_color": Color.VIOLET.to_html(),
		"theme_button_hover_color": Color.BLUE_VIOLET.to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set


func color_set_neutral() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_background_color": Color.BLACK.to_html(),
		"theme_primary_color": Color.DIM_GRAY.to_html(),
		"theme_secondary_color": Color.SLATE_GRAY.to_html(),
		"theme_tertiary_color": Color.DARK_SLATE_GRAY.to_html(),
		"theme_quaternary_color": Color.TAN.to_html(),
		"theme_quinary_color": Color.ROSY_BROWN.to_html(),
		"theme_button_default_color": Color.SADDLE_BROWN.to_html(),
		"theme_button_disabled_color": Color.LIGHT_STEEL_BLUE.to_html(),
		"theme_button_focus_color": Color.BROWN.to_html(),
		"theme_button_pressed_color": Color.SANDY_BROWN.to_html(),
		"theme_button_hover_color": Color.BURLYWOOD.to_html(),
		"theme_transparency_default_color": Color(Color.DIM_GRAY, alpha_for_transparencies).to_html(),
		"theme_transparency_warning_color": Color(Color.RED, alpha_for_transparencies).to_html(),
	}
	return color_set
