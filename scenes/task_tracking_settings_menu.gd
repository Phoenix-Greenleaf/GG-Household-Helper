extends PanelContainer

@onready var auto_load_check_button: CheckButton = %AutoLoadCheckButton
@onready var default_data_display_button: Button = %DefaultDataDisplayButton
@onready var set_active_button: Button = %SetActiveButton
@onready var set_expired_button: Button = %SetExpiredButton
@onready var set_assigned_button: Button = %SetAssignedButton
@onready var deletion_safety_check_button: CheckButton = %DeletionSafetyCheckButton
@onready var remove_profile_button: Button = %RemoveProfileButton
@onready var purge_profile_data_button: Button = %PurgeProfileDataButton
@onready var delete_task_sheet_button: Button = %DeleteTaskSheetButton
@onready var reset_default_settings_button: Button = %ResetDefaultSettingsButton
@onready var deletion_background_panel_container: PanelContainer = %DeletionBackgroundPanelContainer
@onready var deletion_grid_container: GridContainer = %DeletionGridContainer
@onready var description_preview_length_spin_box: SpinBox = %DescriptionPreviewLengthSpinBox
@onready var reset_checkboxes_button: Button = %ResetCheckboxesButton
@onready var reset_checkboxes_section_option_button: OptionButton = %ResetCheckboxesSectionOptionButton
@onready var reset_checkboxes_month_option_button: OptionButton = %ResetCheckboxesMonthOptionButton

@onready var data_manager: PanelContainer = $DataManager
@onready var settings: TaskSettingsData
@onready var new_checkbox_options: Dictionary

var task_new_checkbox_options_button_group: ButtonGroup = preload("res://gui/task_tracking/task_new_checkbox_options_button_group.tres")

var scanned_profiles: Array
var scan_data: TaskSetData



func _ready() -> void:
	TaskTrackingGlobal.load_task_tracking_settings()
	settings = TaskTrackingGlobal.active_settings
	new_checkbox_options = settings.NewCheckboxOption
	establish_connections()
	load_all_settings()
	disarm_danger_buttons()
	deletion_background_panel_container.visible = false


func establish_connections() -> void:
	task_new_checkbox_options_button_group.pressed.connect(
		_on_task_new_checkbox_options_button_group_pressed
	)


func disarm_danger_buttons() -> void:
		settings.enable_deletion_buttons = false


func load_all_settings() -> void:
	load_auto_load_setting()
	load_default_task_data()
	load_new_checkbox_setting()
	load_deletion_armed_setting()
	load_description_preview_length()
	reset_buttons()


func load_auto_load_setting() -> void:
	if not settings.enable_auto_load_default_data:
		auto_load_check_button.button_pressed = false
		auto_load_check_button.text = "Auto-Load Default Database (Off)"
	if settings.enable_auto_load_default_data:
		auto_load_check_button.button_pressed = true
		auto_load_check_button.text = "Auto-Load Default Database (On!)"


func load_default_task_data() -> void:
	if settings.autoload_database_path:
		default_data_display_button.text = "Current Default: " + SqlManager.database_name
		default_data_display_button.set_pressed_no_signal(true)
		default_data_display_button.disabled = false
	if not settings.autoload_database_path:
		default_data_display_button.text = "No Database Set"
		default_data_display_button.set_pressed_no_signal(false)
		default_data_display_button.disabled = true
		auto_load_check_button.button_pressed = false
		auto_load_check_button.text = "Auto Load Default Data (Off)"


func load_new_checkbox_setting() -> void:
	set_active_button.set_pressed_no_signal(false)
	set_expired_button.set_pressed_no_signal(false)
	set_assigned_button.set_pressed_no_signal(false)
	match settings.current_new_checkbox_option:
		new_checkbox_options.ACTIVE:
			set_active_button.set_pressed_no_signal(true)
		new_checkbox_options.EXPIRED:
			set_expired_button.set_pressed_no_signal(true)
		new_checkbox_options.ASSIGNED:
			set_assigned_button.set_pressed_no_signal(true)


func load_deletion_armed_setting() -> void:
	return
	if settings.enable_deletion_buttons:
		deletion_safety_check_button.text = "Danger Buttons ARMED"
		deletion_safety_check_button.set_pressed_no_signal(true)
		remove_profile_button.disabled = false
		purge_profile_data_button.disabled = false
		delete_task_sheet_button.disabled = false
		reset_checkboxes_button.disabled = false
		reset_checkboxes_section_option_button.disabled = false
		reset_checkboxes_month_option_button.disabled = false
	if not settings.enable_deletion_buttons:
		deletion_safety_check_button.text = "Danger Buttons Disarmed"
		deletion_safety_check_button.set_pressed_no_signal(false)
		remove_profile_button.disabled = true
		purge_profile_data_button.disabled = true
		delete_task_sheet_button.disabled = true
		reset_checkboxes_button.disabled = true
		reset_checkboxes_section_option_button.disabled = true
		reset_checkboxes_month_option_button.disabled = true


func load_description_preview_length() -> void:
	description_preview_length_spin_box.set_value_no_signal(settings.description_preview_length)


func reset_buttons() -> void:
	reset_default_settings_button.text = "Reset Default Settings"


func reload_settings() -> void:
	TaskTrackingGlobal.save_task_tracking_settings()
	load_all_settings()


func grab_active_task_set_info() -> Array:
	var active_task_set_info = [
		TaskTrackingGlobal.active_data.task_set_title,
		TaskTrackingGlobal.active_data.task_set_year,
		]
	return active_task_set_info



func _on_menu_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_main_menu.tscn")


func _on_sheets_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_editor.tscn")


func _on_auto_load_check_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		settings.enable_auto_load_default_data = false
		reload_settings()
		return
	if not settings.autoload_database_path:
		prints("Default data is needed to enable auto-load")
		DataGlobal.button_based_message(default_data_display_button,
			"Auto-load requires Default Data"
		)
		auto_load_check_button.set_pressed_no_signal(false)
		return
	settings.enable_auto_load_default_data = true
	reload_settings()


func _on_reset_default_settings_button_pressed() -> void:
	if reset_default_settings_button.text == "Reset Default Settings":
		reset_default_settings_button.text = "Confirm Settings Reset"
		return
	settings.reset_task_tracking_settings()
	reload_settings()


func _on_set_default_data_button_pressed() -> void:
	if not SqlManager.database_is_active:
		prints("No data to set as default")
		DataGlobal.button_based_message(default_data_display_button, "No Data to set as Default!")
		return
	settings.autoload_database_path = SqlManager.database_path
	reload_settings()


func _on_task_new_checkbox_options_button_group_pressed(pressed_button: Button) -> void:
	match pressed_button.name:
		"SetActiveButton":
			settings.current_new_checkbox_option = new_checkbox_options.ACTIVE
		"SetExpiredButton":
			settings.current_new_checkbox_option = new_checkbox_options.EXPIRED
		"SetAssignedButton":
			settings.current_new_checkbox_option = new_checkbox_options.ASSIGNED
	reload_settings()


func _on_deletion_safety_check_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		settings.enable_deletion_buttons = false
	if button_pressed:
		settings.enable_deletion_buttons = true
	reload_settings()


func _on_description_preview_length_spin_box_value_changed(value: float) -> void:
	var int_value = value as int
	settings.description_preview_length = int_value
	reload_settings()


func _on_unload_current_data_button_pressed() -> void:
	SqlManager.unload_database()
	TaskTrackingGlobal.current_checkbox_profile = TaskTrackingGlobal.default_profile
	TaskTrackingGlobal.current_checkbox_state = TaskTrackingGlobal.Checkbox.ACTIVE
	if settings.enable_auto_load_default_data:
		settings.enable_auto_load_default_data = false
	reload_settings()
