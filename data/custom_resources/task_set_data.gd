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

# to be deleted after old data not needed


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
	if not data_parameter.has("user_profiles"):
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
	if not data_parameter.has("spreadsheet_year_data"):
		return []
	var spreadsheet_year_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_year_data, spreadsheet_year_data_import)
	return spreadsheet_year_data_import


func import_spreadsheet_month_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.has("spreadsheet_month_data"):
		return []
	var spreadsheet_month_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_month_data, spreadsheet_month_data_import)
	return spreadsheet_month_data_import


func import_spreadsheet_week_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.has("spreadsheet_week_data"):
		return []
	var spreadsheet_week_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_week_data, spreadsheet_week_data_import)
	return spreadsheet_week_data_import


func import_spreadsheet_day_data(data_parameter: Dictionary) -> Array:
	if not data_parameter.has("spreadsheet_day_data"):
		return []
	var spreadsheet_day_data_import: Array = []
	import_task_data_array(data_parameter.spreadsheet_day_data, spreadsheet_day_data_import)
	return spreadsheet_day_data_import


func import_column_data(data_parameter: Dictionary) -> Dictionary:
	if not data_parameter.has("column_data"):
		return new_column_data_dictionary()
	return data_parameter.column_data


func import_column_order(data_parameter: Dictionary) -> Array:
	if not data_parameter.has("column_order"):
		return new_column_order_array()
	return data_parameter.column_order


func import_task_data_array(raw_array_parameter: Array, import_array_parameter: Array) -> void:
	for task_iteration in raw_array_parameter:
		var imported_task := TaskData.new()
		imported_task.import_json_to_resource(task_iteration)
		import_array_parameter.append(imported_task)


func new_column_data_dictionary() -> Dictionary:
	var data_dictionary := {  # [column order, # of column, sorting mode, sorting enabled, visible]
		"Order": new_single_column_data_dictionary(1, 1, 0, true, true),
		"Task": new_single_column_data_dictionary(2, 1, 0, true, true),
		"Section": new_single_column_data_dictionary(3, 1, 0, false, true), #(y/m/w/d)
		"Group": new_single_column_data_dictionary(4, 1, 0, true, true),
		"Assignment": new_single_column_data_dictionary(5, 1, 0, true, true),
		"Description": new_single_column_data_dictionary(6, 1, 0, false, true),
		"Time Of Day": new_single_column_data_dictionary(7, 1, 0, true, true),
		"Priority": new_single_column_data_dictionary(8, 1, 0, true, true),
		"Location": new_single_column_data_dictionary(9, 1, 0, true, true),
		"TrackerCheckboxes": new_single_column_data_dictionary(10, 5, 0, false, true),
		"Reset Checkboxes": new_single_column_data_dictionary(11, 1, 0, false, true),
		"Schedule Start": new_single_column_data_dictionary(12, 1, 0, false, true),
		"Units/Cycle": new_single_column_data_dictionary(13, 1, 0, true, true),
		"Delete Task": new_single_column_data_dictionary(14, 1, 0, false, true),
	}
	return data_dictionary


func new_single_column_data_dictionary(
	column_order_parameter,
	column_count_parameter,
	sorting_mode_parameter,
	sorting_enabled_parameter,
	column_visible_parameter,
) -> Dictionary:
	var single_column_data: Dictionary = {}
	single_column_data["Column Order"] = column_order_parameter
	single_column_data["Column Count"] = column_count_parameter
	single_column_data["Sorting Mode"] = sorting_mode_parameter
	single_column_data["Sorting Enabled"] = sorting_enabled_parameter
	single_column_data["Column Visible"] = column_visible_parameter
	return single_column_data


func new_column_order_array() -> Array:
	var new_dictionary = new_column_data_dictionary()
	var order_array := []
	for column_entry in new_dictionary:
		var column_dictonary = new_dictionary[column_entry]
		order_array.append([column_entry, column_dictonary["Column Order"]])
	order_array.sort_custom(sort_ascending)
	return order_array


func sort_ascending(a, b):
	if a[1] < b[1]:
		return true
	return false
