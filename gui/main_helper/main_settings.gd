extends Control

@onready var resolution_width_option_button: OptionButton = %ResolutionWidthOptionButton
@onready var resolution_height_option_button: OptionButton = %ResolutionHeightOptionButton
@onready var custom_resolution_h_box_container: HBoxContainer = %CustomResolutionHBoxContainer
@onready var custom_width_spin_box: SpinBox = %CustomWidthSpinBox
@onready var custom_height_spin_box: SpinBox = %CustomHeightSpinBox
@onready var aspect_ratio_whole_value: Label = %AspectRatioWholeValue
@onready var aspect_ratio_single_value: Label = %AspectRatioSingleValue
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

@onready var current_scene: Control

@onready var settings = DataGlobal.active_settings_main

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



func _ready() -> void:
	get_display_data()
	load_settings()
	initialize_option_buttons()
	apply_settings_to_menu()
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
	toggle_changed_settings_section()
	connect_signals()



func _process(_delta: float) -> void:
	if testing_active:
		test_change_timer_label.set_text(str(int(test_change_timer.time_left)))


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
	test_change_timer_label.text = ""


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
	get_tree().get_root().size_changed.connect(window_resized)


func load_settings() -> void:
	window_width = settings.window_width
	window_height = settings.window_height
	window_size = Vector2i(window_width, window_height)
	monitor_mode = settings.monitor_mode
	current_screen = settings.current_monitor
	borderless = settings.borderless


func apply_settings_to_menu() -> void:
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


func save_settings() -> void:
	settings.main_setting_window_width = custom_width_spin_box.value
	settings.main_setting_window_height = custom_height_spin_box.value
	settings.main_setting_monitor_mode = display_mode_option_button.selected
	settings.main_setting_current_monitor = display_preference_option_button.selected
	settings.main_setting_borderless = borderless_check_button.button_pressed
	DataGlobal.save_settings_main()
	load_settings()
	apply_settings_to_menu()


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
#	window_instance.set_position()
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




func _on_reset_button_pressed() -> void:
	if reset_button.text == "Reset to Defaults":
		DataGlobal.button_based_message(reset_button, "CLICK TO CONFIRM RESET")
		return
	settings.reset_main_settings()
	reset_button.text = "Settings Reset!"
	DataGlobal.save_settings_main()
	load_settings()
	apply_settings_to_menu()
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
	if not changed_settings_check():
		prints("All data matches, skipping save")
		return
	if testing_active:
		test_changes_end()
		prints("End test saved")
	save_settings()
	load_settings()
	apply_settings_to_menu()
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
#	toggle_changed_settings_section()


func _on_cancel_changes_button_pressed() -> void:
	apply_settings_to_menu()
	set_window(current_screen, monitor_mode, borderless, window_width, window_height)
	toggle_changed_settings_section()


func _on_back_button_pressed() -> void:
	SignalBus._on_main_settings_back_button_pressed.emit()
