extends Resource

class_name SettingsData

enum NEW_CHECKBOX_OPTION {ACTIVE, EXPIRED, ASSIGNED}

@export var task_enable_auto_load_default_data: bool
@export var task_default_data: TaskSpreadsheetData
@export var task_enable_deletion_buttons: bool
@export var task_current_new_checkbox_option: NEW_CHECKBOX_OPTION
@export var task_description_preview_length: int


func reset_all_default_settings() -> void:
	prints("Changing all settings to defaults...")
	reset_task_tracking_settings()


func reset_task_tracking_settings() -> void:
	task_enable_auto_load_default_data = false
	task_default_data = null
	task_enable_deletion_buttons = false
	task_current_new_checkbox_option = NEW_CHECKBOX_OPTION.ASSIGNED
	task_description_preview_length = 50
	prints("Task Tracking Settings reset to defaults.")
