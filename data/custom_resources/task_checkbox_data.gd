extends Resource

class_name TaskCheckboxData

@export var checkbox_status: TaskTrackingGlobal.Checkbox
@export var assigned_user: Array



func update_checkbox_data(
	checkbox_status_parameter := TaskTrackingGlobal.task_tracking_current_checkbox_state,
	assigned_user_parameter: Array = TaskTrackingGlobal.task_tracking_current_checkbox_profile,
	) -> void:
		checkbox_status = checkbox_status_parameter
		assigned_user = assigned_user_parameter


func export_json_from_resouce() -> Dictionary:
	var json_data: Dictionary = {
		"checkbox_status": checkbox_status,
		"assigned_user_name": assigned_user[0],
		"assigned_user_color": assigned_user[1].to_html(),
	}
	return json_data


func import_json_to_resource(data_parameter: Dictionary) -> void:
	var imported_user_name: String = data_parameter.assigned_user_name
	var imported_user_color := Color.from_string(data_parameter.assigned_user_color, Color.BLACK)
	checkbox_status = data_parameter.checkbox_status
	assigned_user = [imported_user_name, imported_user_color]
