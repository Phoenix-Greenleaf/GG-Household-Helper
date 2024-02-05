extends Resource

class_name TaskSettingsData

enum NEW_CHECKBOX_OPTION {ACTIVE, EXPIRED, ASSIGNED}



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


func export_json_from_resouce() -> Dictionary:
	var exported_task_setting_default_data: Dictionary
	if task_setting_default_data:
		exported_task_setting_default_data = task_setting_default_data.export_json_from_resouce()
	var json_data: Dictionary = {
		"task_setting_enable_auto_load_default_data": task_setting_enable_auto_load_default_data,
		"task_setting_default_data": exported_task_setting_default_data,
		"task_setting_enable_deletion_buttons": task_setting_enable_deletion_buttons,
		"task_setting_current_new_checkbox_option": task_setting_current_new_checkbox_option,
		"task_setting_description_preview_length": task_setting_description_preview_length,
		"task_setting_reset_current_checkboxes_section": task_setting_reset_current_checkboxes_section,
		"task_setting_reset_current_checkboxes_month": task_setting_reset_current_checkboxes_month,
	}
	return json_data


func import_json_to_resource(data_parameter: Dictionary) -> void:
	var imported_task_setting_default_data: TaskSpreadsheetData
	if data_parameter.task_setting_default_data:
		imported_task_setting_default_data = TaskSpreadsheetData.new()
		imported_task_setting_default_data.import_json_to_resource(data_parameter.task_setting_default_data)
	else:
		imported_task_setting_default_data = null
	task_setting_enable_auto_load_default_data = data_parameter.task_setting_enable_auto_load_default_data
	task_setting_default_data = imported_task_setting_default_data
	task_setting_enable_deletion_buttons = data_parameter.task_setting_enable_deletion_buttons
	task_setting_current_new_checkbox_option = data_parameter.task_setting_current_new_checkbox_option
	task_setting_description_preview_length = data_parameter.task_setting_description_preview_length
	task_setting_reset_current_checkboxes_section = data_parameter.task_setting_reset_current_checkboxes_section
	task_setting_reset_current_checkboxes_month = data_parameter.task_setting_reset_current_checkboxes_month


func reset_settings() -> void:
	task_setting_enable_auto_load_default_data = false
	task_setting_default_data = null
	task_setting_enable_deletion_buttons = false
	task_setting_current_new_checkbox_option = NEW_CHECKBOX_OPTION.ASSIGNED
	task_setting_description_preview_length = 50
	task_setting_reset_current_checkboxes_section = 0
	task_setting_reset_current_checkboxes_month = 0
	prints("Task Tracking Settings reset to defaults.")
