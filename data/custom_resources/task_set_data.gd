extends Resource

class_name TaskSetData

@export var task_set_title: String
@export var task_set_year: int
@export var user_profiles: Array = []

@export var spreadsheet_year_data: Array
@export var spreadsheet_month_data: Array
@export var spreadsheet_week_data: Array
@export var spreadsheet_day_data: Array


func export_json_from_resouce() -> Dictionary:
	var user_profile_export: Array = []
	for unformatted_profile in user_profiles:
		var formatted_profile := [unformatted_profile[0], unformatted_profile[1].to_html()]
		user_profile_export.append(formatted_profile)
	var spreadsheet_year_data_export: Array = []
	export_task_data_array(spreadsheet_year_data, spreadsheet_year_data_export)
	var spreadsheet_month_data_export: Array = []
	export_task_data_array(spreadsheet_month_data, spreadsheet_month_data_export)
	var spreadsheet_week_data_export: Array = []
	export_task_data_array(spreadsheet_week_data, spreadsheet_week_data_export)
	var spreadsheet_day_data_export: Array = []
	export_task_data_array(spreadsheet_day_data, spreadsheet_day_data_export)
	var json_data: Dictionary = {
		"task_set_year": task_set_year,
		"task_set_title": task_set_title,
		#"spreadsheet_filepath": spreadsheet_filepath,
		"user_profiles": user_profile_export,
		"spreadsheet_year_data": spreadsheet_year_data_export,
		"spreadsheet_month_data": spreadsheet_month_data_export,
		"spreadsheet_week_data": spreadsheet_week_data_export,
		"spreadsheet_day_data": spreadsheet_day_data_export,
	}
	return json_data


func export_task_data_array(raw_array_parameter: Array, export_array_parameter: Array) -> void:
	for task_iteration in raw_array_parameter:
		export_array_parameter.append(task_iteration.export_json_from_resource())


func import_json_to_resource(data_parameter: Dictionary) -> void:
	var user_profile_import: Array = []
	for unformatted_profile in data_parameter.user_profiles:
		var formatted_profile := [unformatted_profile[0], Color.from_string(unformatted_profile[1], Color.BLACK)]
		user_profile_import.append(formatted_profile)
	var spreadsheet_year_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_year_data, spreadsheet_year_data_import)
	var spreadsheet_month_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_month_data, spreadsheet_month_data_import)
	var spreadsheet_week_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_week_data, spreadsheet_week_data_import)
	var spreadsheet_day_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_day_data, spreadsheet_day_data_import)
	task_set_year = data_parameter.task_set_year
	task_set_title = data_parameter.task_set_title
	#spreadsheet_filepath = data_parameter.spreadsheet_filepath
	user_profiles = user_profile_import
	spreadsheet_year_data = spreadsheet_year_data_import
	spreadsheet_month_data = spreadsheet_month_data_import
	spreadsheet_week_data = spreadsheet_week_data_import
	spreadsheet_day_data = spreadsheet_day_data_import


func import_task_data_array(raw_array_parameter: Array, import_array_parameter: Array) -> void:
	for task_iteration in raw_array_parameter:
		var imported_task := TaskData.new()
		imported_task.import_json_to_resource(task_iteration)
		import_array_parameter.append(imported_task)
