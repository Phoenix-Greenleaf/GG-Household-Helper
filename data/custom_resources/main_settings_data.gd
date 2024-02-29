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
@export var theme_main_color: Color
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
		"theme_font_color": theme_font_color.to_html(),
		"theme_outlines_color": theme_outlines_color.to_html(),
		"theme_main_color": theme_main_color.to_html(),
		"theme_secondary_color": theme_secondary_color.to_html(),
		"theme_tertiary_color": theme_tertiary_color.to_html(),
		"theme_quaternary_color": theme_quaternary_color.to_html(),
		"theme_quinary_color": theme_quinary_color.to_html(),
		"theme_button_default_color": theme_button_default_color.to_html(),
		"theme_button_disabled_color": theme_button_disabled_color.to_html(),
		"theme_button_focus_color": theme_button_focus_color.to_html(),
		"theme_button_pressed_color": theme_button_pressed_color.to_html(),
		"theme_button_hover_color": theme_button_hover_color.to_html(),
		"theme_transparency_default_color": theme_transparency_default_color.to_html(),
		"theme_transparency_warning_color": theme_transparency_warning_color.to_html(),
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
	theme_font_color = Color.from_string(data_parameter.theme_font_color, Color.WHITE)
	theme_outlines_color = Color.from_string(data_parameter.theme_outlines_color, Color.WHITE)
	theme_main_color = Color.from_string(data_parameter.theme_main_color, Color.WHITE)
	theme_secondary_color = Color.from_string(data_parameter.theme_secondary_color, Color.WHITE)
	theme_tertiary_color = Color.from_string(data_parameter.theme_tertiary_color, Color.WHITE)
	theme_quaternary_color = Color.from_string(data_parameter.theme_quaternary_color, Color.WHITE)
	theme_quinary_color = Color.from_string(data_parameter.theme_quinary_color, Color.WHITE)
	theme_button_default_color = Color.from_string(
		data_parameter.theme_button_default_color, Color.WHITE
	)
	theme_button_disabled_color = Color.from_string(
		data_parameter.theme_button_disabled_color, Color.WHITE
	)
	theme_button_focus_color = Color.from_string(
		data_parameter.theme_button_focus_color, Color.WHITE
	)
	theme_button_pressed_color = Color.from_string(
		data_parameter.theme_button_pressed_color, Color.WHITE
	)
	theme_button_hover_color = Color.from_string(
		data_parameter.theme_button_hover_color, Color.WHITE
	)
	theme_transparency_default_color = Color.from_string(
		data_parameter.theme_transparency_default_color, Color.WHITE
	)
	theme_transparency_warning_color = Color.from_string(
		data_parameter.theme_transparency_warning_color, Color.WHITE
	)



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
	theme_title_size = 100
	theme_sub_title_size = 60
	theme_large_size = 40
	theme_medium_size = 30
	theme_small_size = 20
	theme_font_color = Color.WHITE
	theme_outlines_color = Color.BLACK
	theme_main_color = Color.DARK_GREEN
	theme_secondary_color = Color.WEB_GREEN
	theme_tertiary_color = Color.OLIVE_DRAB
	theme_quaternary_color = Color.OLIVE
	theme_quinary_color = Color.FOREST_GREEN
	theme_button_default_color = Color.LIME_GREEN
	theme_button_disabled_color = Color.DARK_SLATE_GRAY
	theme_button_focus_color = Color.GOLD
	theme_button_pressed_color = Color.CHARTREUSE
	theme_button_hover_color = Color.LIME
	theme_transparency_default_color = Color(Color.DIM_GRAY, 0.5)
	theme_transparency_warning_color = Color(Color.DARK_RED, 0.5)
