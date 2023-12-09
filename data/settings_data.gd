extends Resource

class_name SettingsData

enum NEW_CHECKBOX_OPTION {ACTIVE, EXPIRED, ASSIGNED}

@export var main_setting_window_width: int
@export var main_setting_window_height: int
@export var main_setting_monitor_mode: int
@export var main_setting_borderless: bool
@export var main_setting_last_monitor: int #is this used?
@export var main_setting_current_monitor: int

@export var task_setting_enable_auto_load_default_data: bool
@export var task_setting_default_data: TaskSpreadsheetData
@export var task_setting_enable_deletion_buttons: bool
@export var task_setting_current_new_checkbox_option: NEW_CHECKBOX_OPTION
@export var task_setting_description_preview_length: int
@export var task_setting_reset_current_checkboxes_section: int
@export var task_setting_reset_current_checkboxes_month: int



func _init() -> void:
	DisplayServer.window_set_min_size(Vector2i(500, 500))
	prints("Minimun window size applied")

func reset_all_default_settings() -> void:
	prints("Changing all settings to defaults...")
	reset_main_settings()
	reset_task_tracking_settings()


func reset_main_settings() -> void:
	main_setting_window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	main_setting_window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	main_setting_monitor_mode = 1
	main_setting_last_monitor = 1
	main_setting_borderless = true
	prints("Main Settings reset to defaults.")


func reset_task_tracking_settings() -> void:
	task_setting_enable_auto_load_default_data = false
	task_setting_default_data = null
	task_setting_enable_deletion_buttons = false
	task_setting_current_new_checkbox_option = NEW_CHECKBOX_OPTION.ASSIGNED
	task_setting_description_preview_length = 50
	task_setting_reset_current_checkboxes_section = 0
	task_setting_reset_current_checkboxes_month = 0
	prints("Task Tracking Settings reset to defaults.")
