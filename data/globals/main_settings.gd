extends Node


var active_settings_main: MainSettingsData

const MAIN_THEME = preload("res://theme/main_theme.tres")
# Regular Panels: squared edges, no border
const PANEL_BACKGROUND = preload("res://theme/theme_parts/panel_background.tres")
const PANEL_PRIMARY = preload("res://theme/theme_parts/panel_primary.tres")
const PANEL_SECONDARY = preload("res://theme/theme_parts/panel_secondary.tres")
const PANEL_TERTIARY = preload("res://theme/theme_parts/panel_tertiary.tres")
const PANEL_QUATERNARY = preload("res://theme/theme_parts/panel_quaternary.tres")
const PANEL_QUINARY = preload("res://theme/theme_parts/panel_quinary.tres")
const PANEL_TRANSPARENCY_DEFAULT = preload("res://theme/theme_parts/panel_transparency_default.tres")
const PANEL_TRANSPARENCY_WARNING = preload("res://theme/theme_parts/panel_transparency_warning.tres")
# Popup Panels: rounded edges, colored border
const POPUP_PRIMARY = preload("res://theme/theme_parts/popup_primary.tres")
const POPUP_SECONDARY = preload("res://theme/theme_parts/popup_secondary.tres")
const POPUP_TERTIARY = preload("res://theme/theme_parts/popup_tertiary.tres")
const POPUP_QUATERNARY = preload("res://theme/theme_parts/popup_quaternary.tres")
const POPUP_QUINARY = preload("res://theme/theme_parts/popup_quinary.tres")
const POPUP_TRANSPARENCY_DEFAULT = preload("res://theme/theme_parts/popup_transparency_default.tres")
const POPUP_TRANSPARENCY_WARNING = preload("res://theme/theme_parts/popup_transparency_warning.tres")
# unsure that these popup_transparencies are needed

const BUTTON_DISABLED_BOX = preload("res://theme/theme_parts/button_disabled_box.tres")
const BUTTON_FOCUS_BOX = preload("res://theme/theme_parts/button_focus_box.tres")
const BUTTON_HOVER_BOX = preload("res://theme/theme_parts/button_hover_box.tres")
const BUTTON_NORMAL_BOX = preload("res://theme/theme_parts/button_normal_box.tres")
const BUTTON_PRESSED_BOX = preload("res://theme/theme_parts/button_pressed_box.tres")

const SEPARATOR_LINE = preload("res://theme/theme_parts/separator_line.tres")
const SEPARATOR_LINE_VERTICAL = preload("res://theme/theme_parts/separator_line_vertical.tres")

var primary_screen: int
var current_screen: int
var screen_count: int
var screen_size: Vector2i
var screen_native_width: int
var screen_native_height: int
var monitor_mode: int
var borderless: bool
var window_size: Vector2i
var starting_window_size: Vector2i
var window_width: int
var window_height: int

var ignore_window_resize: bool = true

var resolution_list: Array = [
	600,
	640,
	648,
	720,
	768,
	800,
	810,
	864,
	900,
	1024,
	1080,
	1154,
	1200,
	1280,
	1360,
	1366,
	1440,
	1536,
	1600,
	1680,
	1920,
	2048,
	2160,
	2560,
	3840,
	4320,
	7680,
]

var theme_title_size: int
var theme_sub_title_size: int
var theme_large_size: int
var theme_medium_size: int
var theme_small_size: int
var theme_font_color: Color
var theme_outlines_color: Color
var theme_background_color: Color
var theme_border_line_color: Color
var theme_primary_color: Color
var theme_secondary_color: Color
var theme_tertiary_color: Color
var theme_quaternary_color: Color
var theme_quinary_color: Color
var theme_button_default_color: Color
var theme_button_disabled_color: Color
var theme_button_focus_color: Color
var theme_button_pressed_color: Color
var theme_button_hover_color: Color
var theme_transparency_default_color: Color
var theme_transparency_warning_color: Color

var theme_current_color_palette: String
var theme_loaded_color_palette: String
var theme_palette_reset_needs_saving: bool = false



func _ready() -> void:
	load_settings_main()
	get_display_data()
	load_all_settings()
	initial_setup()


func initial_setup() -> void:
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
	set_themes()


func create_settings_main() -> void:
	active_settings_main = MainSettingsData.new()
	active_settings_main.reset_settings_all_main()
	prints("New main settings data created")
	save_settings_main()


func save_settings_main() -> void:
	var json_data = active_settings_main.export_json_from_resouce()
	JsonSaveManager.save_data(DataGlobal.filepath_main_settings, json_data)
	prints("Main settings data saved")


func load_settings_main() -> void:
	DataGlobal.directory_check(DataGlobal.settings_folder)
	if active_settings_main:
		prints("Main settings exist")
		return
	if not FileAccess.file_exists(DataGlobal.filepath_main_settings):
		prints("Creating new main settings")
		create_settings_main()
		return
	prints("Loading main settings")
	active_settings_main = MainSettingsData.new()
	var json_data = JsonSaveManager.load_data(DataGlobal.filepath_main_settings)
	active_settings_main.import_json_to_resource(json_data)


func get_display_data() -> void:
	screen_count = DisplayServer.get_screen_count()
	primary_screen = DisplayServer.get_primary_screen()
	current_screen = DisplayServer.window_get_current_screen()
	window_size = DisplayServer.window_get_size(current_screen)
	starting_window_size = DisplayServer.window_get_size(current_screen)
	screen_size = DisplayServer.screen_get_size(current_screen)
	screen_native_width = screen_size.x
	screen_native_height = screen_size.y



func load_all_settings() -> void:
	load_display_settings()
	load_theme_settings()


func load_display_settings() -> void:
	window_width = active_settings_main.window_width
	window_height = active_settings_main.window_height
	window_size = Vector2i(window_width, window_height)
	monitor_mode = active_settings_main.monitor_mode
	current_screen = active_settings_main.current_monitor
	borderless = active_settings_main.borderless


func set_window(current_screen_parameter: int, mode_parameter: int,
	borderless_parameter: int, width_parameter: int, height_parameter: int
) -> void:
	ignore_window_resize = true
	var window_instance = get_window()
	if mode_parameter == 1:
		window_instance.set_mode(Window.MODE_FULLSCREEN)
	if mode_parameter == 0:
		window_instance.set_mode(Window.MODE_WINDOWED)
		window_instance.set_flag(Window.FLAG_BORDERLESS, borderless_parameter)
		window_instance.set_size(Vector2i(width_parameter, height_parameter))
	window_instance.set_current_screen(current_screen_parameter)
	ignore_window_resize = false


func load_theme_settings() -> void:
	theme_title_size = active_settings_main.theme_title_size
	theme_sub_title_size = active_settings_main.theme_sub_title_size
	theme_large_size = active_settings_main.theme_large_size
	theme_medium_size = active_settings_main.theme_medium_size
	theme_small_size = active_settings_main.theme_small_size
	theme_current_color_palette = active_settings_main.theme_current_color_palette
	theme_loaded_color_palette = active_settings_main.theme_current_color_palette
	load_theme_color_palette()


func load_theme_color_palette() -> void:
	var color_profile = active_settings_main.theme_color_palettes[theme_current_color_palette]
	theme_font_color = Color(color_profile.theme_font_color)
	theme_outlines_color = Color(color_profile.theme_outlines_color)
	theme_background_color = Color(color_profile.theme_background_color)
	theme_border_line_color = Color(color_profile.theme_border_line_color)
	theme_primary_color = Color(color_profile.theme_primary_color)
	theme_secondary_color = Color(color_profile.theme_secondary_color)
	theme_tertiary_color = Color(color_profile.theme_tertiary_color)
	theme_quaternary_color = Color(color_profile.theme_quaternary_color)
	theme_quinary_color = Color(color_profile.theme_quinary_color)
	theme_button_default_color = Color(color_profile.theme_button_default_color)
	theme_button_disabled_color = Color(color_profile.theme_button_disabled_color)
	theme_button_focus_color = Color(color_profile.theme_button_focus_color)
	theme_button_pressed_color = Color(color_profile.theme_button_pressed_color)
	theme_button_hover_color = Color(color_profile.theme_button_hover_color)
	theme_transparency_default_color = Color(color_profile.theme_transparency_default_color)
	theme_transparency_warning_color = Color(color_profile.theme_transparency_warning_color)








func set_themes() -> void:
	set_themes_all_font_sizes()
	set_themes_all_colors()


func set_themes_all_font_sizes() -> void:
	set_themes_small_font(theme_small_size)
	set_themes_medium_font(theme_medium_size)
	set_themes_large_font(theme_large_size)
	set_themes_sub_title_font(theme_sub_title_size)
	set_themes_title_font(theme_title_size)


func set_themes_all_colors() -> void:
	set_themes_background_color(theme_background_color)
	set_themes_primary_color(theme_primary_color)
	set_themes_secondary_color(theme_secondary_color)
	set_themes_tertiary_color(theme_tertiary_color)
	set_themes_quaternary_color(theme_quaternary_color)
	set_themes_quinary_color(theme_quinary_color)
	set_themes_border_line_color(theme_border_line_color)
	set_themes_font_color(theme_font_color)
	set_themes_outline_color(theme_outlines_color)
	set_themes_button_default_color(theme_button_default_color)
	set_themes_button_disabled_color(theme_button_disabled_color)
	set_themes_button_focus_color(theme_button_focus_color)
	set_themes_button_pressed_color(theme_button_pressed_color)
	set_themes_button_hover_color(theme_button_hover_color)
	set_themes_transparency_default_color(theme_transparency_default_color)
	set_themes_transparency_warning_color(theme_transparency_warning_color)


func set_themes_small_font(size_parameter: int) -> void:
	MAIN_THEME.set_font_size("font_size", "Label", size_parameter)
	MAIN_THEME.set_font_size("font_size", "LineEdit", size_parameter)
	MAIN_THEME.set_font_size("font_size", "Button", size_parameter)
	MAIN_THEME.set_font_size("font_size", "OptionButton", size_parameter)
	MAIN_THEME.set_font_size("font_size", "PopupMenu", size_parameter) 
	MAIN_THEME.set_font_size("font_size", "CheckButton", size_parameter)
	MAIN_THEME.set_font_size("font_size", "TabContainer", size_parameter)
	MAIN_THEME.set_font_size("font_size", "TextEdit", size_parameter)


func set_themes_medium_font(size_parameter: int) -> void:
	MAIN_THEME.set_font_size("font_size", "Label_Medium", size_parameter)
	MAIN_THEME.set_font_size("font_size", "LineEdit_Medium", size_parameter)
	MAIN_THEME.set_font_size("font_size", "Button_Medium", size_parameter)
	MAIN_THEME.set_font_size("font_size", "Button_Medium_Hover_Demo", size_parameter)
	MAIN_THEME.set_font_size("font_size", "OptionButton_Medium", size_parameter)
	MAIN_THEME.set_font_size("font_size", "PopupMenu_Medium", size_parameter)
	MAIN_THEME.set_font_size("font_size", "CheckButton_Medium", size_parameter)
	MAIN_THEME.set_font_size("font_size", "TabContainer_Medium", size_parameter)


func set_themes_large_font(size_parameter: int) -> void:
	MAIN_THEME.set_font_size("font_size", "Label_Large", size_parameter)
	MAIN_THEME.set_font_size("font_size", "LineEdit_Large", size_parameter)
	MAIN_THEME.set_font_size("font_size", "Button_Large", size_parameter)
	MAIN_THEME.set_font_size("font_size", "TabContainer_Large", size_parameter)


func set_themes_sub_title_font(size_parameter: int) -> void:
	MAIN_THEME.set_font_size("font_size", "Label_Title_Secondary", size_parameter)
	MAIN_THEME.set_font_size("font_size", "LineEdit_Title_Secondary", size_parameter)


func set_themes_title_font(size_parameter: int) -> void:
	MAIN_THEME.set_font_size("font_size", "Label_Title", size_parameter)
	MAIN_THEME.set_font_size("font_size", "LineEdit_Title", size_parameter)


func set_themes_background_color(color_parameter: Color) -> void:
	PANEL_BACKGROUND.set("bg_color", color_parameter)


func set_themes_primary_color(color_parameter: Color) -> void:
	POPUP_PRIMARY.set("bg_color", color_parameter)
	PANEL_PRIMARY.set("bg_color", color_parameter)


func set_themes_secondary_color(color_parameter: Color) -> void:
	POPUP_SECONDARY.set("bg_color", color_parameter)
	PANEL_SECONDARY.set("bg_color", color_parameter)


func set_themes_tertiary_color(color_parameter: Color) -> void:
	POPUP_TERTIARY.set("bg_color", color_parameter)
	PANEL_TERTIARY.set("bg_color", color_parameter)


func set_themes_quaternary_color(color_parameter: Color) -> void:
	POPUP_QUATERNARY.set("bg_color", color_parameter)
	PANEL_QUATERNARY.set("bg_color", color_parameter)


func set_themes_quinary_color(color_parameter: Color) -> void:
	POPUP_QUINARY.set("bg_color", color_parameter)
	PANEL_QUINARY.set("bg_color", color_parameter)


func set_themes_border_line_color(color_parameter: Color) -> void:
	BUTTON_NORMAL_BOX.set("border_color", color_parameter)
	BUTTON_DISABLED_BOX.set("border_color", color_parameter)
	BUTTON_PRESSED_BOX.set("border_color", color_parameter)
	BUTTON_HOVER_BOX.set("border_color", color_parameter)

	POPUP_PRIMARY.set("border_color", color_parameter)
	POPUP_SECONDARY.set("border_color", color_parameter)
	POPUP_TERTIARY.set("border_color", color_parameter)
	POPUP_QUATERNARY.set("border_color", color_parameter)
	POPUP_QUINARY.set("border_color", color_parameter)

	POPUP_TRANSPARENCY_DEFAULT.set("border_color", color_parameter)
	POPUP_TRANSPARENCY_WARNING.set("border_color", color_parameter)

	SEPARATOR_LINE.set("color", color_parameter)
	SEPARATOR_LINE_VERTICAL.set("color", color_parameter)

func set_themes_font_color(color_parameter: Color) -> void:
	MAIN_THEME.set_color("font_color", "Label", color_parameter)
	MAIN_THEME.set_color("font_color", "LineEdit", color_parameter)
	MAIN_THEME.set_color("font_color", "OptionButton", color_parameter)
	MAIN_THEME.set_color("font_color", "PopupMenu", color_parameter) 
	MAIN_THEME.set_color("font_color", "CheckButton", color_parameter)
	MAIN_THEME.set_color("font_color", "TextEdit", color_parameter)
	
	MAIN_THEME.set_color("font_color", "Button", color_parameter)
	MAIN_THEME.set_color("font_focus_color", "Button", color_parameter)
	MAIN_THEME.set_color("font_hover_color", "Button", color_parameter)
	MAIN_THEME.set_color("font_pressed_color", "Button", color_parameter)
	MAIN_THEME.set_color("font_hover_pressed_color", "Button", color_parameter)
	MAIN_THEME.set_color("font_disabled_color", "Button", Color(color_parameter, 0.5))
	
	MAIN_THEME.set_color("font_unselected_color", "TabContainer", color_parameter)
	MAIN_THEME.set_color("font_focus_color", "TabContainer", color_parameter)
	MAIN_THEME.set_color("font_hover_color", "TabContainer", color_parameter)
	MAIN_THEME.set_color("font_selected_color", "TabContainer", color_parameter)
	MAIN_THEME.set_color("font_hover_pressed_color", "TabContainer", color_parameter)
	MAIN_THEME.set_color("font_disabled_color", "TabContainer", Color(color_parameter, 0.5))


func set_themes_outline_color(color_parameter: Color) -> void:
	MAIN_THEME.set_color("font_outline_color", "Label", color_parameter)
	MAIN_THEME.set_color("font_outline_color", "LineEdit", color_parameter)
	MAIN_THEME.set_color("font_outline_color", "Button", color_parameter)
	MAIN_THEME.set_color("font_outline_color", "OptionButton", color_parameter)
	MAIN_THEME.set_color("font_outline_color", "PopupMenu", color_parameter) 
	MAIN_THEME.set_color("font_outline_color", "CheckButton", color_parameter)
	MAIN_THEME.set_color("font_outline_color", "TabContainer", color_parameter)
	MAIN_THEME.set_color("font_outline_color", "TextEdit", color_parameter)


func set_themes_button_default_color(color_parameter: Color) -> void:
	BUTTON_NORMAL_BOX.set("bg_color", color_parameter)


func set_themes_button_disabled_color(color_parameter: Color) -> void:
	BUTTON_DISABLED_BOX.set("bg_color", color_parameter)


func set_themes_button_focus_color(color_parameter: Color) -> void:
	BUTTON_FOCUS_BOX.set("border_color", color_parameter)


func set_themes_button_pressed_color(color_parameter: Color) -> void:
	BUTTON_PRESSED_BOX.set("bg_color", color_parameter)


func set_themes_button_hover_color(color_parameter: Color) -> void:
	BUTTON_HOVER_BOX.set("bg_color", color_parameter)


func set_themes_transparency_default_color(color_parameter: Color) -> void:
	PANEL_TRANSPARENCY_DEFAULT.set("bg_color", color_parameter)
	POPUP_TRANSPARENCY_DEFAULT.set("bg_color", color_parameter)


func set_themes_transparency_warning_color(color_parameter: Color) -> void:
	PANEL_TRANSPARENCY_WARNING.set("bg_color", color_parameter)
	POPUP_TRANSPARENCY_WARNING.set("bg_color", color_parameter)
