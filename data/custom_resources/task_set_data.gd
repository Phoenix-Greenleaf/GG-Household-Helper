extends Resource

class_name TaskSetData

@export var task_set_title: String
@export var task_set_year: int
@export var user_profiles: Array = []

@export var spreadsheet_year_data: Array
@export var spreadsheet_month_data: Array
@export var spreadsheet_week_data: Array
@export var spreadsheet_day_data: Array

@export var column_data: Dictionary
@export var column_order: Array



func export_json_from_resouce() -> Dictionary:
	var json_data: Dictionary = {
		"task_set_year": task_set_year,
		"task_set_title": task_set_title,
		"user_profiles": format_user_profile(),
		"spreadsheet_year_data": format_spreadsheet_year_data(),
		"spreadsheet_month_data": format_spreadsheet_month_data(),
		"spreadsheet_week_data": format_spreadsheet_week_data(),
		"spreadsheet_day_data": format_spreadsheet_day_data(),
		"column_data": column_data,
		"column_order": column_order,
	}
	return json_data


func format_user_profile() -> Array:
	var user_profile_export: Array = []
	for unformatted_profile in user_profiles:
		var formatted_profile := [unformatted_profile[0], unformatted_profile[1].to_html()]
		user_profile_export.append(formatted_profile)
	return user_profile_export


func format_spreadsheet_year_data() -> Array:
	var spreadsheet_year_data_export: Array = []
	export_task_data_array(spreadsheet_year_data, spreadsheet_year_data_export)
	return spreadsheet_year_data_export


func format_spreadsheet_month_data() -> Array:
	var spreadsheet_month_data_export: Array = []
	export_task_data_array(spreadsheet_month_data, spreadsheet_month_data_export)
	return spreadsheet_month_data_export


func format_spreadsheet_week_data() -> Array:
	var spreadsheet_week_data_export: Array = []
	export_task_data_array(spreadsheet_week_data, spreadsheet_week_data_export)
	return spreadsheet_week_data_export


func format_spreadsheet_day_data() -> Array:
	var spreadsheet_day_data_export: Array = []
	export_task_data_array(spreadsheet_day_data, spreadsheet_day_data_export)
	return spreadsheet_day_data_export


func export_task_data_array(raw_array_parameter: Array, export_array_parameter: Array) -> void:
	for task_iteration in raw_array_parameter:
		export_array_parameter.append(task_iteration.export_json_from_resource())


func import_json_to_resource(data_parameter: Dictionary) -> void:
	task_set_year = data_parameter.task_set_year
	task_set_title = data_parameter.task_set_title
	user_profiles = import_user_profile(data_parameter)
	spreadsheet_year_data = import_spreadsheet_year_data(data_parameter)
	spreadsheet_month_data = import_spreadsheet_month_data(data_parameter)
	spreadsheet_week_data = import_spreadsheet_week_data(data_parameter)
	spreadsheet_day_data = import_spreadsheet_day_data(data_parameter)
	column_data = import_column_data(data_parameter)
	column_order = import_column_order(data_parameter)


func import_user_profile(data_parameter: Dictionary) -> Array:
	if not data_parameter.user_profiles:
		#load default data?
		return []
	var user_profile_import: Array = []
	for unformatted_profile in data_parameter.user_profiles:
		var formatted_profile: Array = [
			unformatted_profile[0],
			Color.from_string(unformatted_profile[1],
			Color.BLACK)
		]
		user_profile_import.append(formatted_profile)
	return user_profile_import


func import_spreadsheet_year_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.spreadsheet_year_data:
		return []
	var spreadsheet_year_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_year_data, spreadsheet_year_data_import)
	return spreadsheet_year_data_import


func import_spreadsheet_month_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.spreadsheet_month_data:
		return []
	var spreadsheet_month_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_month_data, spreadsheet_month_data_import)
	return spreadsheet_month_data_import


func import_spreadsheet_week_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.spreadsheet_week_data:
		return []
	var spreadsheet_week_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_week_data, spreadsheet_week_data_import)
	return spreadsheet_week_data_import


func import_spreadsheet_day_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.spreadsheet_day_data:
		return []
	var spreadsheet_day_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_day_data, spreadsheet_day_data_import)
	return spreadsheet_day_data_import


func import_column_data(data_parameter: Dictionary) -> Dictionary:
	if not data_parameter.column_data:
		return new_column_data_dictionary()
	return data_parameter.column_data


func import_column_order(data_parameter: Dictionary) -> Array:
	if not data_parameter.column_order:
		return new_column_order_array()
	return data_parameter.column_order


func import_task_data_array(raw_array_parameter: Array, import_array_parameter: Array) -> void:
	for task_iteration in raw_array_parameter:
		var imported_task := TaskData.new()
		imported_task.import_json_to_resource(task_iteration)
		import_array_parameter.append(imported_task)


func new_column_data_dictionary() -> Dictionary:
# now we have to grab the other columns, from where they used to be handled. 
	var data_dictionary := {  # [column order, # of column, visible 
		"Order": [1, 1, true],
		"Task": [2, 1, true],
		"Section": [3, 1, true], #(y/m/w/d)
		"Group": [4, 1, true], 
		"Assignment": [5, 1, true], 
		"Description": [6, 1, true], 
		"Time Of Day": [7, 1, true],
		"Priority": [8, 1, true],
		"Location": [9, 1, true],
		"TrackerCheckboxes": [10, 5, true],
		"Schedule Start": [11, 1, true],
		"Units/Cycle": [12, 1, true],
		"Delete Task": [13, 1, true],
	}
	return data_dictionary


func new_column_order_array() -> Array:
	var new_dictionary = new_column_data_dictionary()
	var order_array := []
	for dictionary_entry in new_dictionary:
		order_array.append([dictionary_entry, new_dictionary[dictionary_entry[0]]])
	order_array.sort_custom(sort_ascending)
	return order_array


func sort_ascending(a, b):
	if a[1] < b[1]:
		return true
	return false
