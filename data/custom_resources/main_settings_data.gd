extends Resource

class_name MainSettingsData



@export var main_setting_window_width: int
@export var main_setting_window_height: int
@export var main_setting_monitor_mode: int
@export var main_setting_borderless: bool
@export var main_setting_last_monitor: int #is this used?
@export var main_setting_current_monitor: int


func export_json_from_resouce() -> Dictionary:
	var json_data: Dictionary = {
		"main_setting_window_width": main_setting_window_width,
		"main_setting_window_height": main_setting_window_height,
		"main_setting_monitor_mode": main_setting_monitor_mode,
		"main_setting_borderless": main_setting_borderless,
		"main_setting_last_monitor": main_setting_last_monitor,
		"main_setting_current_monitor": main_setting_current_monitor,
	}
	return json_data


func import_json_to_resource(data_parameter: Dictionary) -> void:
	var imported_task_setting_default_data: TaskSpreadsheetData
	if data_parameter.task_setting_default_data:
		imported_task_setting_default_data = TaskSpreadsheetData.new()
		imported_task_setting_default_data.import_json_to_resource(data_parameter.task_setting_default_data)
	else:
		imported_task_setting_default_data = null
	main_setting_window_width = data_parameter.main_setting_window_width
	main_setting_window_height = data_parameter.main_setting_window_height
	main_setting_monitor_mode = data_parameter.main_setting_monitor_mode
	main_setting_borderless = data_parameter.main_setting_borderless
	main_setting_last_monitor = data_parameter.main_setting_last_monitor
	main_setting_current_monitor = data_parameter.main_setting_current_monitor


func reset_settings() -> void:
	main_setting_window_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	main_setting_window_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	main_setting_monitor_mode = 1
	main_setting_last_monitor = 1
	main_setting_borderless = true
	prints("Main Settings reset to defaults.")

