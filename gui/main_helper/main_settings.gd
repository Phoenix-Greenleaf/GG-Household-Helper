extends Control

@onready var main_settings_tab_container: TabContainer = %MainSettingsTabContainer

@onready var resolution_width_option_button: OptionButton = %ResolutionWidthOptionButton
@onready var resolution_height_option_button: OptionButton = %ResolutionHeightOptionButton
@onready var custom_resolution_h_box_container: HBoxContainer = %CustomResolutionHBoxContainer
@onready var custom_width_spin_box: SpinBox = %CustomWidthSpinBox
@onready var custom_height_spin_box: SpinBox = %CustomHeightSpinBox
@onready var display_preference_option_button: OptionButton = %DisplayPreferenceOptionButton
@onready var display_mode_option_button: OptionButton = %DisplayModeOptionButton
@onready var borderless_check_button: CheckButton = %BorderlessCheckButton
@onready var borderless_status_label: Label = %BorderlessStatusLabel
@onready var accept_button: Button = %AcceptButton
@onready var reset_button: Button = %ResetButton
@onready var back_button: Button = %BackButton
@onready var test_h_separator: HSeparator = %TestHSeparator
@onready var test_buttons_h_box_container: HBoxContainer = %TestButtonsHBoxContainer
@onready var test_button: Button = %TestButton
@onready var save_warning_label: Label = %SaveWarningLabel
@onready var test_change_timer_label: Label = %TestChangeTimerLabel
@onready var test_change_timer: Timer = %TestChangeTimer
@onready var cancel_changes_button: Button = %CancelChangesButton



@onready var theme_title_size_spin_box: SpinBox = %ThemeTitleSizeSpinBox
@onready var theme_sub_title_size_spin_box: SpinBox = %ThemeSubTitleSizeSpinBox
@onready var theme_large_size_spin_box: SpinBox = %ThemeLargeSizeSpinBox
@onready var theme_medium_size_spin_box: SpinBox = %ThemeMediumSizeSpinBox
@onready var theme_small_size_spin_box: SpinBox = %ThemeSmallSizeSpinBox
@onready var theme_font_color_picker_button: ColorPickerButton = %ThemeFontColorPickerButton
@onready var theme_outline_color_picker_button: ColorPickerButton = %ThemeOutlineColorPickerButton
@onready var theme_main_color_picker_button: ColorPickerButton = %ThemeMainColorPickerButton
@onready var theme_secondary_color_picker_button: ColorPickerButton = %ThemeSecondaryColorPickerButton
@onready var theme_tertiary_color_picker_button: ColorPickerButton = %ThemeTertiaryColorPickerButton
@onready var theme_quaternary_color_picker_button: ColorPickerButton = %ThemeQuaternaryColorPickerButton
@onready var theme_quinary_color_picker_button: ColorPickerButton = %ThemeQuinaryColorPickerButton
@onready var theme_button_default_color_picker_button: ColorPickerButton = %ThemeButtonDefaultColorPickerButton
@onready var theme_button_disabled_color_picker_button: ColorPickerButton = %ThemeButtonDisabledColorPickerButton
@onready var theme_button_focus_color_picker_button: ColorPickerButton = %ThemeButtonFocusColorPickerButton
@onready var theme_button_pressed_color_picker_button: ColorPickerButton = %ThemeButtonPressedColorPickerButton
@onready var theme_button_hover_color_picker_button: ColorPickerButton = %ThemeButtonHoverColorPickerButton
@onready var theme_transparency_default_color_picker_button: ColorPickerButton = %ThemeTransparencyDefaultColorPickerButton
@onready var theme_transparency_warning_color_picker_button: ColorPickerButton = %ThemeTransparencyWarningColorPickerButton
@onready var theme_test_button: Button = %ThemeTestButton
@onready var theme_save_warning_label: Label = %ThemeSaveWarningLabel
@onready var theme_test_change_timer_label: Label = %ThemeTestChangeTimerLabel
@onready var theme_cancel_changes_button: Button = %ThemeCancelChangesButton
@onready var theme_reset_button: Button = %ThemeResetButton
@onready var theme_test_change_timer: Timer = %ThemeTestChangeTimer
@onready var theme_test_h_separator: HSeparator = %ThemeTestHSeparator
@onready var theme_test_buttons_h_box_container: HBoxContainer = %ThemeTestButtonsHBoxContainer

const MAIN_THEME = preload("res://theme/main_theme.tres")

const PANEL_BACKGROUND_MAIN = preload("res://theme/theme_parts/panel_background_main.tres")
const PANEL_POPUP_MAIN = preload("res://theme/theme_parts/panel_popup_main.tres")
const PANEL_POPUP_SECONDARY = preload("res://theme/theme_parts/panel_popup_secondary.tres")
const PANEL_POPUP_TERTIARY = preload("res://theme/theme_parts/panel_popup_tertiary.tres")

const BUTTON_DISABLED_BOX = preload("res://theme/theme_parts/button_disabled_box.tres")
const BUTTON_FOCUS_BOX = preload("res://theme/theme_parts/button_focus_box.tres")
const BUTTON_HOVER_BOX = preload("res://theme/theme_parts/button_hover_box.tres")
const BUTTON_NORMAL_BOX = preload("res://theme/theme_parts/button_normal_box.tres")
const BUTTON_PRESSED_BOX = preload("res://theme/theme_parts/button_pressed_box.tres")

const PANEL_BACKGROUND_TRANSPARENCY_RED = preload("res://theme/theme_parts/panel_background_transparency_red.tres")
const PANEL_POPUP_TRANSPARENCY = preload("res://theme/theme_parts/panel_popup_transparency.tres")

@onready var settings = DataGlobal.active_settings_main

var current_setting_tab: int = 0

var primary_screen: int
var current_screen: int
var screen_count: int
var screen_size: Vector2i
var screen_native_width: int
var screen_native_height: int
var monitor_mode: int
var borderless: bool
var window_size: Vector2i
var window_width: int
var window_height: int

var testing_active: bool = false
var test_time: int = 13

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
var theme_main_color: Color
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



func _ready() -> void:
	load_all_settings()
	initialize_all_sections()
	toggle_changed_settings_section()
	connect_signals()
	main_settings_tab_container.set_current_tab(current_setting_tab)


func _process(_delta: float) -> void:
	if not testing_active:
		return
	match main_settings_tab_container.current_tab:
		0:
			test_change_timer_label.set_text(str(int(test_change_timer.time_left)))
		1:
			theme_test_change_timer_label.set_text(str(int(theme_test_change_timer.time_left)))
		_:
			prints("No tab timer to update")


func initialize_all_sections() -> void:
	initialize_display()
	initialize_theme()


func initialize_display() -> void:
	get_display_data()
	initialize_option_buttons()
	apply_display_settings_to_menu()
	test_change_timer_label.text = ""
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)


func get_display_data() -> void:
	screen_count = DisplayServer.get_screen_count()
	primary_screen = DisplayServer.get_primary_screen()
	current_screen = DisplayServer.window_get_current_screen()
	window_size = DisplayServer.window_get_size(current_screen)
	screen_size = DisplayServer.screen_get_size(current_screen)
	screen_native_width = screen_size.x
	screen_native_height = screen_size.y


func initialize_option_buttons() -> void:
	initialize_resolution_lists(resolution_width_option_button, screen_native_width)
	initialize_resolution_lists(resolution_height_option_button, screen_native_height)
	initialize_display_preference_options()


func initialize_resolution_lists(button_parameter: OptionButton, native_resolution_paramter: int) -> void:
	button_parameter.clear()
	for resolution_iteration in resolution_list:
		if resolution_iteration == native_resolution_paramter:
			button_parameter.add_item(str(resolution_iteration)+" Native")
		else:
			button_parameter.add_item(str(resolution_iteration))
	button_parameter.add_item("Custom")


func initialize_display_preference_options() -> void:
	display_preference_option_button.clear()
	for display_iteration in screen_count:
		var monitor_name: String = "Monitor " + str(display_iteration + 1)
		var monitor_size: Vector2i = DisplayServer.screen_get_size(display_iteration)
		var monitor_size_string: String = "  (" + str(monitor_size.x) + " x " + str(monitor_size.y) + ")"
		display_preference_option_button.add_item(monitor_name + monitor_size_string)


func connect_signals() -> void:
	test_change_timer.timeout.connect(test_changes_end)
	theme_test_change_timer.timeout.connect(theme_test_changes_end)
	get_tree().get_root().size_changed.connect(window_resized)


func load_all_settings() -> void:
	load_display_settings()
	load_theme_settings()


func load_display_settings() -> void:
	window_width = settings.window_width
	window_height = settings.window_height
	window_size = Vector2i(window_width, window_height)
	monitor_mode = settings.monitor_mode
	current_screen = settings.current_monitor
	borderless = settings.borderless


func apply_display_settings_to_menu() -> void:
	apply_both_resolutions(window_width, window_height)
	apply_display_preference()
	apply_display_mode()
	apply_borderless()
	disable_changed_settings_section(true)


func apply_both_resolutions(width_parameter: int, height_parameter: int) -> void:
	apply_resolution(resolution_width_option_button, custom_width_spin_box, width_parameter)
	apply_resolution(resolution_height_option_button, custom_height_spin_box, height_parameter)
	toggle_custom_resolution_container()


func apply_resolution(button_parameter: OptionButton, spinbox_parameter: SpinBox, resolution_parameter: int) -> void:
	spinbox_parameter.value = resolution_parameter
	if resolution_parameter not in resolution_list:
		button_parameter.select(resolution_list.size())
		spinbox_parameter.editable = true
		return
	var resolution_index = resolution_list.find(resolution_parameter)
	button_parameter.select(resolution_index)
	spinbox_parameter.editable = false


func toggle_custom_resolution_container() -> void:
	if resolution_height_option_button.selected != resolution_list.size() and resolution_width_option_button.selected != resolution_list.size():
		custom_resolution_h_box_container.visible = false
		return
	custom_resolution_h_box_container.visible = true
	toggle_custom_dimension_disable(resolution_height_option_button, custom_height_spin_box)
	toggle_custom_dimension_disable(resolution_width_option_button, custom_width_spin_box)


func toggle_custom_dimension_disable(option_button_parameter: OptionButton, spin_box_parameter: SpinBox) -> void:
	if option_button_parameter.selected == resolution_list.size():
		spin_box_parameter.editable = true
	else:
		spin_box_parameter.editable = false


func apply_display_preference() -> void:
	display_preference_option_button.select(current_screen)
	toggle_display_preference_option_button()


func toggle_display_preference_option_button() -> void:
	if display_preference_option_button.item_count < 2:
		display_preference_option_button.disabled = true


func apply_display_mode() -> void:
	display_mode_option_button.select(monitor_mode)


func apply_borderless() -> void:
	if display_mode_option_button.selected == 0:
		borderless_check_button.disabled = false
		borderless_check_button.set_pressed_no_signal(borderless)
		if borderless:
			borderless_status_label.text = "On"
			return
		borderless_status_label.text = "Off"
		return
	if display_mode_option_button.selected == 1:
		borderless_check_button.disabled = true
		borderless_check_button.set_pressed_no_signal(true)
		borderless_status_label.text = "On"
		return
	prints("apply_borderless ERROR!")


func toggle_borderless_button() -> void:
	if display_mode_option_button.selected == 0:
		borderless_check_button.disabled = false
		return
	if display_mode_option_button.selected == 1:
		borderless_check_button.disabled = true
		return
	prints("Toggle_borderless ERROR!")


func toggle_changed_settings_section() -> void:
	var settings_changed: bool = changed_settings_check()
	prints("Settings changed:", settings_changed)
	if display_mode_option_button.selected == 1:
		fullscreen_resolution_lock(true)
	if display_mode_option_button.selected == 0:
		fullscreen_resolution_lock(false)
	if settings_changed:
		disable_changed_settings_section(false)
		return
	disable_changed_settings_section(true)


func disable_changed_settings_section(disabled_parameter: bool) -> void:
	test_h_separator.visible = !disabled_parameter
	test_buttons_h_box_container.visible = !disabled_parameter
	accept_button.disabled = disabled_parameter


func changed_settings_check() -> bool:
	if window_width != custom_width_spin_box.value: 
		prints("Width setting changed")
		return true
	if window_height != custom_height_spin_box.value:
		prints("Height setting changed")
		return true
	if monitor_mode != display_mode_option_button.selected:
		prints("Display mode setting changed")
		return true
	if current_screen != display_preference_option_button.selected:
		prints("Display preference setting changed")
		return true
	if borderless != borderless_check_button.button_pressed:
		if display_mode_option_button.selected == 0:
			prints("Borderless setting changed")
			return true
	return false


func test_changes_start() -> void:
	test_mass_disable(true)
	disable_main_settings_tab_container_all_tabs(true)
	set_window(display_preference_option_button.selected, display_mode_option_button.selected, borderless_check_button.button_pressed, custom_width_spin_box.value, custom_height_spin_box.value)
	test_button.text = "Cancel Test"
	save_warning_label.text = "Test Active, will revert in:"
	testing_active = true
	test_change_timer.start(test_time)


func test_mass_disable(disabled_parameter: bool) -> void:
	get_tree().call_group("testing_lock", "set_disabled", disabled_parameter)
	get_tree().call_group("testing_lock", "set_editable", !disabled_parameter)


func fullscreen_resolution_lock(lock_parameter: bool) -> void:
	get_tree().call_group("fullscreen_lock", "set_disabled", lock_parameter)
	get_tree().call_group("fullscreen_lock", "set_editable", !lock_parameter)


func test_changes_end() -> void:
	if not testing_active:
		return
	test_mass_disable(false)
	disable_main_settings_tab_container_all_tabs(false)
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
	test_button.text = "Test Changes"
	save_warning_label.text = "Changes not saved!"
	testing_active = false
	if not test_change_timer.is_stopped():
		test_change_timer.stop()
	test_change_timer_label.text = ""
	toggle_custom_resolution_container()
	toggle_display_preference_option_button()
	toggle_borderless_button()
	toggle_changed_settings_section()


func save_display_settings() -> void:
	settings.main_setting_window_width = custom_width_spin_box.value
	settings.main_setting_window_height = custom_height_spin_box.value
	settings.main_setting_monitor_mode = display_mode_option_button.selected
	settings.main_setting_current_monitor = display_preference_option_button.selected
	settings.main_setting_borderless = borderless_check_button.button_pressed
	DataGlobal.save_settings_main()
	load_display_settings()
	apply_display_settings_to_menu()


func set_window(current_screen_parameter: int, mode_parameter: int, borderless_parameter: int, width_parameter: int, height_parameter: int) -> void:
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


func window_resized() -> void:
	if ignore_window_resize:
		prints("Window resized signal IGNORED")
		return
	var resized_window_size: Vector2i = DisplayServer.window_get_size(current_screen)
	prints("Window resized function activated")
	var resized_window_width: int = resized_window_size.x
	var resized_window_height: int = resized_window_size.y
	apply_both_resolutions(resized_window_width, resized_window_height)


func disable_main_settings_tab_container_all_tabs(disabled_parameter:bool) -> void:
	for tab_iteration in main_settings_tab_container.get_tab_count():
		main_settings_tab_container.set_tab_disabled(tab_iteration, disabled_parameter)


func initialize_theme() -> void:
	apply_theme_settings_to_menu()
	theme_test_change_timer_label.text = ""


func apply_theme_settings_to_menu() -> void:
	theme_title_size_spin_box.value = theme_title_size
	theme_sub_title_size_spin_box.value = theme_sub_title_size
	theme_large_size_spin_box.value = theme_large_size
	theme_medium_size_spin_box.value = theme_medium_size
	theme_small_size_spin_box.value = theme_small_size
	theme_font_color_picker_button.color = theme_font_color
	theme_outline_color_picker_button.color = theme_outlines_color
	theme_main_color_picker_button.color = theme_main_color
	theme_secondary_color_picker_button.color = theme_secondary_color
	theme_tertiary_color_picker_button.color = theme_tertiary_color
	theme_quaternary_color_picker_button.color = theme_quaternary_color
	theme_quinary_color_picker_button.color = theme_quinary_color
	theme_button_default_color_picker_button.color = theme_button_default_color
	theme_button_disabled_color_picker_button.color = theme_button_disabled_color
	theme_button_focus_color_picker_button.color = theme_button_focus_color
	theme_button_pressed_color_picker_button.color = theme_button_pressed_color
	theme_button_hover_color_picker_button.color = theme_button_hover_color
	theme_transparency_default_color_picker_button.color = theme_transparency_default_color
	theme_transparency_warning_color_picker_button.color = theme_transparency_warning_color
	theme_disable_changed_settings_section(true)


func theme_toggle_changed_settings_section() -> void:
	if theme_changed_settings_check():
		theme_disable_changed_settings_section(false)
		return
	theme_disable_changed_settings_section(true)


func theme_disable_changed_settings_section(disabled_parameter: bool) -> void:
	theme_test_h_separator.visible = !disabled_parameter
	theme_test_buttons_h_box_container.visible = !disabled_parameter
	accept_button.disabled = disabled_parameter


func theme_changed_settings_check() -> bool:
	if theme_title_size != theme_title_size_spin_box.value:
		return true
	if theme_sub_title_size != theme_sub_title_size_spin_box.value:
		return true
	if theme_large_size != theme_large_size_spin_box.value:
		return true
	if theme_medium_size != theme_medium_size_spin_box.value:
		return true
	if theme_small_size != theme_small_size_spin_box.value:
		return true
	if theme_font_color != theme_font_color_picker_button.color:
		return true
	if theme_outlines_color != theme_outline_color_picker_button.color:
		return true
	if theme_main_color != theme_main_color_picker_button.color:
		return true
	if theme_secondary_color != theme_secondary_color_picker_button.color:
		return true
	if theme_tertiary_color != theme_tertiary_color_picker_button.color:
		return true
	if theme_quaternary_color != theme_quaternary_color_picker_button.color:
		return true
	if theme_quinary_color != theme_quinary_color_picker_button.color:
		return true
	if theme_button_default_color != theme_button_default_color_picker_button.color:
		return true
	if theme_button_disabled_color != theme_button_disabled_color_picker_button.color:
		return true
	if theme_button_focus_color != theme_button_focus_color_picker_button.color:
		return true
	if theme_button_pressed_color != theme_button_pressed_color_picker_button.color:
		return true
	if theme_button_hover_color != theme_button_hover_color_picker_button.color:
		return true
	if theme_transparency_default_color != theme_transparency_default_color_picker_button.color:
		return true
	if theme_transparency_warning_color != theme_transparency_warning_color_picker_button.color:
		return true
	return false


func theme_test_changes_start() -> void:
	theme_test_mass_disable(true)
	disable_main_settings_tab_container_all_tabs(true)
	test_themes()
	theme_test_button.text = "Cancel Test"
	theme_save_warning_label.text = "Test Active, will revert in:"
	testing_active = true
	theme_test_change_timer.start(test_time)


func theme_test_mass_disable(disabled_parameter: bool) -> void:
	get_tree().call_group("theme_testing_lock", "set_disabled", disabled_parameter)
	get_tree().call_group("theme_testing_lock", "set_editable", !disabled_parameter)


func theme_test_changes_end() -> void:
	if not testing_active:
		return
	theme_test_mass_disable(false)
	disable_main_settings_tab_container_all_tabs(false)
	set_themes()
	theme_test_button.text = "Test Changes"
	theme_save_warning_label.text = "Changes not saved!"
	testing_active = false
	if not theme_test_change_timer.is_stopped():
		theme_test_change_timer.stop()
	theme_test_change_timer_label.text = ""
	toggle_changed_settings_section()


func load_theme_settings() -> void:
	theme_title_size = settings.theme_title_size
	theme_sub_title_size = settings.theme_sub_title_size
	theme_large_size = settings.theme_large_size
	theme_medium_size = settings.theme_medium_size
	theme_small_size = settings.theme_small_size
	theme_font_color = settings.theme_font_color
	theme_outlines_color = settings.theme_outlines_color
	theme_main_color = settings.theme_main_color
	theme_secondary_color = settings.theme_secondary_color
	theme_tertiary_color = settings.theme_tertiary_color
	theme_quaternary_color = settings.theme_quaternary_color
	theme_quinary_color = settings.theme_quinary_color
	theme_button_default_color = settings.theme_button_default_color
	theme_button_disabled_color = settings.theme_button_disabled_color
	theme_button_focus_color = settings.theme_button_focus_color
	theme_button_pressed_color = settings.theme_button_pressed_color
	theme_button_hover_color = settings.theme_button_hover_color
	theme_transparency_default_color = settings.theme_transparency_default_color
	theme_transparency_warning_color = settings.theme_transparency_warning_color


func save_theme_settings() -> void:
	settings.theme_title_size = theme_title_size_spin_box.value
	settings.theme_sub_title_size = theme_sub_title_size_spin_box.value
	settings.theme_large_size = theme_large_size_spin_box.value
	settings.theme_medium_size = theme_medium_size_spin_box.value
	settings.theme_small_size = theme_small_size_spin_box.value
	settings.theme_font_color = theme_font_color_picker_button.color
	settings.theme_outlines_color = theme_outline_color_picker_button.color
	settings.theme_main_color = theme_main_color_picker_button.color
	settings.theme_secondary_color = theme_secondary_color_picker_button.color
	settings.theme_tertiary_color = theme_tertiary_color_picker_button.color
	settings.theme_quaternary_color = theme_quaternary_color_picker_button.color
	settings.theme_quinary_color = theme_quinary_color_picker_button.color
	settings.theme_button_default_color = theme_button_default_color_picker_button.color
	settings.theme_button_disabled_color = theme_button_disabled_color_picker_button.color
	settings.theme_button_focus_color = theme_button_focus_color_picker_button.color
	settings.theme_button_pressed_color = theme_button_pressed_color_picker_button.color
	settings.theme_button_hover_color = theme_button_hover_color_picker_button.color
	settings.theme_transparency_default_color = theme_transparency_default_color_picker_button.color
	settings.theme_transparency_warning_color = theme_transparency_warning_color_picker_button.color
	DataGlobal.save_settings_main()
	load_theme_settings()
	apply_display_settings_to_menu()


func set_themes() -> void:
	MAIN_THEME.set_font_size("font_size", "Label", theme_small_size)
	MAIN_THEME.set_font_size("font_size", "Label_Medium", theme_medium_size)
	MAIN_THEME.set_font_size("font_size", "Label_Large", theme_large_size)
	MAIN_THEME.set_font_size("font_size", "Label_Title_Secondary", theme_sub_title_size)
	MAIN_THEME.set_font_size("font_size", "Label_Title", theme_title_size)
	PANEL_BACKGROUND_MAIN.set("bg_color", theme_main_color)
	#PANEL_POPUP_MAIN.set("bg_color", theme_main_color)
	PANEL_POPUP_SECONDARY.set("bg_color", theme_secondary_color)
	PANEL_POPUP_TERTIARY.set("bg_color", theme_tertiary_color)

	BUTTON_DISABLED_BOX.set("bg_color", theme_button_disabled_color)
	BUTTON_FOCUS_BOX.set("border_color", theme_button_focus_color)
	BUTTON_HOVER_BOX.set("bg_color", theme_button_hover_color)
	BUTTON_NORMAL_BOX.set("bg_color", theme_button_default_color)
	BUTTON_PRESSED_BOX.set("bg_color", theme_button_pressed_color)

	PANEL_BACKGROUND_TRANSPARENCY_RED.set("bg_color", theme_transparency_warning_color)
	PANEL_POPUP_TRANSPARENCY.set("bg_color", theme_transparency_default_color)


func test_themes() -> void:
	MAIN_THEME.set_font_size("font_size", "Label", theme_small_size_spin_box.value)
	MAIN_THEME.set_font_size("font_size", "Label_Medium", theme_medium_size_spin_box.value)
	MAIN_THEME.set_font_size("font_size", "Label_Large", theme_large_size_spin_box.value)
	MAIN_THEME.set_font_size("font_size", "Label_Title_Secondary", theme_sub_title_size_spin_box.value)
	MAIN_THEME.set_font_size("font_size", "Label_Title", theme_title_size_spin_box.value)
	PANEL_BACKGROUND_MAIN.set("bg_color", theme_main_color_picker_button.color)
	#PANEL_POPUP_MAIN.set("bg_color", theme_main_color_picker_button.color)
	PANEL_POPUP_SECONDARY.set("bg_color", theme_secondary_color_picker_button.color)
	PANEL_POPUP_TERTIARY.set("bg_color", theme_tertiary_color_picker_button.color)

	BUTTON_DISABLED_BOX.set("bg_color", theme_button_disabled_color_picker_button.color)
	BUTTON_FOCUS_BOX.set("border_color", theme_button_focus_color_picker_button.color)
	BUTTON_HOVER_BOX.set("bg_color", theme_button_hover_color_picker_button.color)
	BUTTON_NORMAL_BOX.set("bg_color", theme_button_default_color_picker_button.color)
	BUTTON_PRESSED_BOX.set("bg_color", theme_button_pressed_color_picker_button.color)

	PANEL_BACKGROUND_TRANSPARENCY_RED.set("bg_color", theme_transparency_warning_color_picker_button.color)
	PANEL_POPUP_TRANSPARENCY.set("bg_color", theme_transparency_default_color_picker_button.color)


func accept_button_display_settings() -> void:
	if not changed_settings_check():
		prints("No changes in Display Settings, skipping save.")
		return
	if testing_active:
		test_changes_end()
		prints("End test: Accepted")
	save_display_settings()
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)


func accept_button_theme_settings() -> void:
	if not changed_settings_check():
		prints("No changes in Display Settings, skipping save.")
		return
	if testing_active:
		test_changes_end()
		prints("End test: Accepted")
	save_display_settings()
	set_themes()





func _on_reset_button_pressed() -> void:
	if reset_button.text == "Reset to Defaults":
		DataGlobal.button_based_message(reset_button, "CLICK TO CONFIRM RESET")
		return
	settings.reset_settings_display()
	reset_button.text = "Settings Reset!"
	DataGlobal.save_settings_main()
	load_display_settings()
	apply_display_settings_to_menu()
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
	toggle_changed_settings_section()


func _on_display_mode_option_button_item_selected(index: int) -> void:
	if index == 1:
		custom_width_spin_box.value = screen_native_width
		custom_height_spin_box.value = screen_native_height
		apply_both_resolutions(screen_native_width, screen_native_height)
	toggle_changed_settings_section()
	apply_borderless()


func _on_resolution_width_option_button_item_selected(index: int) -> void:
	if resolution_list.size() != index:
		custom_width_spin_box.value = resolution_list[index]
	toggle_custom_resolution_container()
	toggle_changed_settings_section()


func _on_resolution_height_option_button_item_selected(index: int) -> void:
	if resolution_list.size() != index:
		custom_height_spin_box.value = resolution_list[index]
	toggle_custom_resolution_container()
	toggle_changed_settings_section()


func _on_custom_width_spin_box_value_changed(_value: float) -> void:
	toggle_changed_settings_section()

func _on_custom_height_spin_box_value_changed(_value: float) -> void:
	toggle_changed_settings_section()


func _on_display_preference_option_button_item_selected(_index: int) -> void:
	toggle_changed_settings_section()


func _on_borderless_check_button_toggled(button_pressed: bool) -> void:
	toggle_changed_settings_section()
	if button_pressed:
		borderless_status_label.text = "On"
		return
	borderless_status_label.text = "Off"


func _on_test_button_pressed() -> void:
	if not testing_active:
		test_changes_start()
		prints("Start test press")
		return
	if testing_active:
		test_changes_end()
		test_change_timer.stop()
		prints("End test press")


func _on_accept_button_pressed() -> void:
	match main_settings_tab_container.current_tab:
		0:
			accept_button_display_settings()
		1:
			accept_button_theme_settings()
		_:
			prints("Accept Button Error: Tab not found:", main_settings_tab_container.current_tab)


func _on_cancel_changes_button_pressed() -> void:
	match main_settings_tab_container.current_tab:
		0:
			pass
		1:
			pass
		_:
			prints("Cancel Button Error: Tab not found:", main_settings_tab_container.current_tab)
	apply_display_settings_to_menu()
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
	toggle_changed_settings_section()


func _on_back_button_pressed() -> void:
	SignalBus._on_main_settings_back_button_pressed.emit()


func _on_theme_test_button_pressed() -> void:
	if not testing_active:
		theme_test_changes_start()
		prints("Start test press")
		return
	if testing_active:
		theme_test_changes_end()
		theme_test_change_timer.stop()
		prints("End test press")


func _on_theme_cancel_changes_button_pressed() -> void:
	apply_theme_settings_to_menu()
	theme_toggle_changed_settings_section()


func _on_theme_reset_button_pressed() -> void:
	if theme_reset_button.text == "Reset to Defaults":
		DataGlobal.button_based_message(theme_reset_button, "CLICK TO CONFIRM RESET")
		return
	settings.reset_settings_theme()
	theme_reset_button.text = "Settings Reset!"
	DataGlobal.save_settings_main()
	load_theme_settings()
	apply_theme_settings_to_menu()
	theme_toggle_changed_settings_section()


func _on_main_settings_tab_container_tab_changed(tab: int) -> void:
	current_setting_tab = tab


func _on_theme_title_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_sub_title_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_large_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_medium_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_small_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_font_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_outline_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_main_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_secondary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_tertiary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_quaternary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_quinary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_default_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_disabled_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_focus_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_pressed_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_hover_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_transparency_default_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_transparency_warning_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()
