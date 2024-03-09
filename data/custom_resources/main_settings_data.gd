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
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


func color_set_orange() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


func color_set_yellow() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


func color_set_green() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.BLACK.to_html(),
		"theme_background_color": Color.DARK_GREEN.to_html(),
		"theme_border_line_color": Color.BLACK.to_html(),
		"theme_primary_color": Color.FOREST_GREEN.to_html(),
		"theme_secondary_color": Color.LIME_GREEN.to_html(),
		"theme_tertiary_color": Color.GREEN.to_html(),
		"theme_quaternary_color": Color.GREEN_YELLOW.to_html(),
		"theme_quinary_color": Color.DARK_OLIVE_GREEN.to_html(),
		"theme_button_default_color": Color.GOLDENROD.to_html(),
		"theme_button_disabled_color": Color.DIM_GRAY.to_html(),
		"theme_button_focus_color": Color.GOLD.to_html(),
		"theme_button_pressed_color": Color.SADDLE_BROWN.to_html(),
		"theme_button_hover_color": Color.DARK_GOLDENROD.to_html(),
		"theme_transparency_default_color": Color(
			Color.DARK_SLATE_GRAY, alpha_for_transparencies
		).to_html(),
		"theme_transparency_warning_color": Color(
			Color.CRIMSON, alpha_for_transparencies
		).to_html(),
	}
	return color_set


func color_set_blue() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


func color_set_purple() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


func color_set_pink() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


func color_set_neutral() -> Dictionary:
	var color_set := {
		"theme_font_color": Color.WHITE.to_html(),
		"theme_outlines_color": Color.WHITE.to_html(),
		"theme_background_color": Color.WHITE.to_html(),
		"theme_border_line_color": Color.WHITE.to_html(),
		"theme_primary_color": Color.WHITE.to_html(),
		"theme_secondary_color": Color.WHITE.to_html(),
		"theme_tertiary_color": Color.WHITE.to_html(),
		"theme_quaternary_color": Color.WHITE.to_html(),
		"theme_quinary_color": Color.WHITE.to_html(),
		"theme_button_default_color": Color.WHITE.to_html(),
		"theme_button_disabled_color": Color.WHITE.to_html(),
		"theme_button_focus_color": Color.WHITE.to_html(),
		"theme_button_pressed_color": Color.WHITE.to_html(),
		"theme_button_hover_color": Color.WHITE.to_html(),
		"theme_transparency_default_color": Color.WHITE.to_html(),
		"theme_transparency_warning_color": Color.WHITE.to_html(),
	}
	return color_set


