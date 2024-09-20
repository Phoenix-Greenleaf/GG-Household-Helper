extends Node

var active_database: SQLite
var database_is_active: bool = false #the new active_data
var database_path: String = ""
var database_name: String = ""

var current_database_changes: Dictionary
var database_changelog: Array

var database_directory: String = "user://"
var household_name: String
var household_default_name := "My"
var database_standard_title: String = "_household_helper_data"
var database_extension: String = ".db"

var program_info_table := "program_info"
var user_info_table := "user_info"
var task_info_table := "task_info"
var monthly_tasks_table := "monthly_tasks"
var weekly_tasks_table := "weekly_tasks"
var daily_tasks_table := "daily_tasks"
var changelog_table := "change_log"
var dates_table := "dates"
var event_info_table := "event_info"

var unassigned_user_text := "Not Assigned"
var unassigned_user_color := Color.WHITE

var section_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Section)
var month_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Month)
var time_of_day_strings: Array = DataGlobal.enum_to_strings(DataGlobal.TimeOfDay)
var priority_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Priority)

var id := "id"
var name_ := "name"
var color_ := "color"
var status := "status"
var completed_by := "completed_by"
var last_completed := "last_completed"
var task := "task"
var task_name := "task_name"
var task_group := "task_group"
var assigned_to := "assigned_to"
var description := "description"
var time_of_day := "time_of_day"
var priority := "priority"
var location := "location"
var year := "year"
var month := "month"
var section := "section"
var daily_scheduling_start := "daily_scheduling_start"
var days_per_cycle := "days_per_cycle"
var daily_scheduling_end := "daily_scheduling_end"
var weekly_scheduling_start := "weekly_scheduling_start"
var weeks_per_cycle := "weeks_per_cycle"
var weekly_scheduling_end := "weekly_scheduling_end"
var monthly_scheduling_start := "monthly_scheduling_start"
var months_per_cycle := "months_per_cycle"
var monthly_scheduling_end := "monthly_scheduling_end"
#var date := "date"
var days_in_month := "days_in_month"

var data_type := "data_type"
var int_ := "int"
var real := "real"
var text := "text"
var char_part := "char("

var not_null := "not_null"
var primary_key := "primary_key"
var auto_increment := "auto_increment"
var foreign_key := "foreign_key" # {"foreign_key" : "foreign_table.foreign_column"}


var task_info_id: String = table_id(task_info_table)
var dates_id: String = table_id(dates_table)
var user_info_id: String = table_id(user_info_table)
var monthly_tasks_id: String = table_id(monthly_tasks_table)
var weekly_tasks_id: String = table_id(weekly_tasks_table)
var daily_tasks_id: String = table_id(daily_tasks_table)
var event_info_id: String = table_id(event_info_table)

var verbose_sql_output: bool = false

var daily_checkbox_columns: Dictionary
var weekly_checkbox_columns: Dictionary
var monthly_checkbox_columns: Dictionary

func _ready() -> void:
	generate_all_checkbox_columns_info()
	initialize_database()


func generate_all_checkbox_columns_info() -> void:
	generate_section_checkbox_column_info(DataGlobal.Section.DAILY)
	generate_section_checkbox_column_info(DataGlobal.Section.WEEKLY)
	generate_section_checkbox_column_info(DataGlobal.Section.MONTHLY)


func generate_section_checkbox_column_info(section_parameter: DataGlobal.Section) -> void:
	var event_count: int = 0
	var event_units: String = ""
	var event_section_title: String = ""
	var data_columns: Dictionary = {}
	match section_parameter:
		DataGlobal.Section.MONTHLY:
			event_count = 12
			event_units = "month"
			event_section_title = monthly_tasks_table
		DataGlobal.Section.WEEKLY:
			event_count = 5
			event_units = "week"
			event_section_title = weekly_tasks_table
		DataGlobal.Section.DAILY:
			event_count = 31
			event_units = "day"
			event_section_title = daily_tasks_table
	data_columns = section_tasks_standard_data()
	if section_parameter == DataGlobal.Section.DAILY:
		add_standard_data_days_in_month(data_columns)
	add_section_checkbox_columns_info(event_count, event_units, data_columns)
	match section_parameter:
		DataGlobal.Section.MONTHLY:
			monthly_checkbox_columns = data_columns
		DataGlobal.Section.WEEKLY:
			weekly_checkbox_columns = data_columns
		DataGlobal.Section.DAILY:
			daily_checkbox_columns = data_columns


func section_tasks_standard_data() -> Dictionary:
	var standard_data: Dictionary = {
		task : {data_type:int_, foreign_key:table_column_address(task_info_table, task_info_id)},
		year : {data_type:text},
		month : {data_type:text},
	}
	return standard_data


func add_standard_data_days_in_month(data_parameter: Dictionary) -> void:
	var days_in_month_column: Dictionary = {
		days_in_month : {data_type:int_},
	}
	data_parameter.merge(days_in_month_column)


func add_section_checkbox_columns_info(event_count_parameter: int, event_units_parameter: String, data_parameter: Dictionary) -> void:
	for event_iteration in event_count_parameter:
		add_one_checkbox_column_set(event_units_parameter, event_iteration, data_parameter)


func add_one_checkbox_column_set(section_text: String, current_number: int, data_parameter: Dictionary) -> void:
	var column_text = section_text + "_" + str(current_number + 1)
	var new_event: Dictionary = {
		column_text + "_status" : {data_type:text},
		column_text + "_currently_assigned" : {data_type:int_, foreign_key:table_column_address(user_info_table, user_info_id)},
		column_text + "_completed_by" : {data_type:int_, foreign_key:table_column_address(user_info_table, user_info_id)},
	}
	data_parameter.merge(new_event)


func initialize_database() -> void:
	if database_path == "":
		database_path = create_database_path()
	if database_name == "":
		database_name = create_database_name(database_path)
	load_database()


func char_(number: int) -> String:
	var char_combined: String = char_part + str(number) + ")"
	return char_combined


func create_database_path() -> String:
	if not household_name:
		push_warning("Using default household name for database path.")
		household_name = household_default_name.to_snake_case()
	var database_combined_path: String = database_directory + household_name + database_standard_title + database_extension
	return database_combined_path


func create_database_name(path_param: String) -> String:
	return get_database_name_from_path(path_param)


func create_new_database() -> void:
	create_all_tables()


func create_all_tables() -> void:
	create_table_program_info()
	create_table_user_info()
	create_table_task_info()
	create_table_section_tasks(DataGlobal.Section.MONTHLY)
	create_table_section_tasks(DataGlobal.Section.WEEKLY)
	create_table_section_tasks(DataGlobal.Section.DAILY)
	create_table_changelog()


func create_table_user_info() -> void:
	var data_columns: Dictionary = {
		name_ : {data_type:text},
		color_ : {data_type:text}
	}
	create_new_table_with_primary_id(user_info_table, data_columns)
	add_unassigned_user_row()


func create_new_table_with_primary_id(table_title: String, data_columns: Dictionary) -> void:
	var table_data: Dictionary = add_column_primary_id(table_title, data_columns)
	active_database.create_table(table_title, table_data)


func add_column_primary_id(table_title: String, data_parameter: Dictionary) -> Dictionary:
	var combined_columns: Dictionary = create_column_primary_id(table_title)
	combined_columns.merge(data_parameter)
	return combined_columns


func create_column_primary_id(table_title_parameter: String) -> Dictionary:
	var column: Dictionary = {
		table_id(table_title_parameter) : {data_type:int_, primary_key:true, not_null:true, auto_increment:true}
		}
	return column


func table_id(table_title_parameter: String) -> String:
	var table_id: String = table_title_parameter + "_" + id
	return table_id


func add_unassigned_user_row() -> void:
	var data: Dictionary = {
		name_ : unassigned_user_text,
		color_ : unassigned_user_color.to_html()
	}
	active_database.insert_row(user_info_table, data)


func create_table_task_info() -> void:
	var data_columns: Dictionary = {
		task_name : {data_type:text},
		task_group : {data_type:text},
		section : {data_type:text},
		assigned_to : {data_type:int_, foreign_key:table_column_address(user_info_table, user_info_id)},
		description : {data_type:text},
		time_of_day : {data_type:text},
		priority : {data_type:text},
		location : {data_type:text},
		last_completed : {data_type:text},
		daily_scheduling_start : {data_type:text},
		days_per_cycle : {data_type:text},
		daily_scheduling_end : {data_type:text},
		weekly_scheduling_start : {data_type:text},
		weeks_per_cycle : {data_type:text},
		weekly_scheduling_end : {data_type:text},
		monthly_scheduling_start : {data_type:text},
		months_per_cycle : {data_type:text},
		monthly_scheduling_end : {data_type:text},
	}
	create_new_table_with_primary_id(task_info_table, data_columns)


func table_column_address(table_parameter: String, column_parameter: String) -> String:
	var address: String = table_parameter + "." + column_parameter
	return address


func create_table_section_tasks(section_parameter: DataGlobal.Section) -> void:
	match section_parameter:
		DataGlobal.Section.MONTHLY:
			create_new_table_with_primary_id(monthly_tasks_table, monthly_checkbox_columns)
		DataGlobal.Section.WEEKLY:
			create_new_table_with_primary_id(weekly_tasks_table, weekly_checkbox_columns)
		DataGlobal.Section.DAILY:
			create_new_table_with_primary_id(daily_tasks_table, daily_checkbox_columns)


func create_table_program_info() -> void:
#	placeholder
	pass


func create_table_changelog() -> void:
#	placeholder
	pass


# unstable science warning



func add_data(table_parameter: String, row_data_parameter: Array) -> void:
	active_database.insert_rows(table_parameter, row_data_parameter)


func select_data(table_parameter: String, conditions_parameter: String, column_parameters: Array) -> Array:
	var returned_data: Array = []
	returned_data = active_database.select_rows(table_parameter, conditions_parameter, column_parameters)
	return returned_data


func query_data(query_parameter: String) -> Array:
	active_database.query(query_parameter)
	return active_database.query_result


func update_data(table_parameter: String, conditions_parameter: String, row_data_parameter: Dictionary) -> void:
	active_database.update_rows(table_parameter, conditions_parameter, row_data_parameter)


func remove_data(table_parameter: String, conditions_parameter: String) -> void:
	active_database.delete_rows(table_parameter, conditions_parameter)


func verify_database_tables_exist() -> bool:
	var tables_exist_query: Array = SqlManager.select_data("sqlite_schema", "type='table' and name='" + user_info_table + "'", ["count(name)"])
	prints("Db Exists Query Results:", tables_exist_query)
	var tables_exist: bool = tables_exist_query[0]["count(name)"]
	return tables_exist


func load_database() -> void:
	active_database = SQLite.new()
	active_database.path = database_path
	active_database.foreign_keys = true
	if verbose_sql_output:
		active_database.verbosity_level = SQLite.VERBOSE
	active_database.open_db()
	if not verify_database_tables_exist():
		prints("Load_database creating new database")
		create_new_database()
	database_is_active = true
	prints("")
	prints("Emitting database loaded signal")
	prints("")
	TaskSignalBus._on_new_database_loaded.emit()


func get_existing_database_files() -> Array:
	var existing_files_info =  DirAccess.get_files_at(database_directory)
	prints("existing files info:", existing_files_info)
	var database_files_only: Array
	for file_info_iteration: String in existing_files_info:
		if not file_info_iteration.ends_with(database_extension):
			continue
		database_files_only.append(file_info_iteration)
	prints("existing database files", database_files_only)
	return database_files_only


func get_existing_database_names(database_files_param: Array) -> Array:
	var database_file_names: Array
	for file_iteration: String in database_files_param:
		var full_file_name: String = file_iteration.get_file()
		var file_name_without_extension: String = full_file_name.replace(".db", "")
		var capitalized_file_name: String = file_name_without_extension.capitalize()
		database_file_names.append(capitalized_file_name)
	return database_file_names


func get_database_name_from_path(path_parameter: String) -> String:
	var full_file_name: String = path_parameter.get_file()
	var file_name_without_extension: String = full_file_name.replace(".db", "")
	var capitalized_file_name: String = file_name_without_extension.capitalize()
	return capitalized_file_name


func set_database_name_and_path(name_param: String, path_param: String) -> void:
	database_name = name_param
	database_path = path_param


func join_tables(join_type: String, left_table: String, left_column: String, right_table: String, right_column: String) -> String:
	var join_parts: Array
	#join_parts.append(left_table)
	join_parts.append(join_type)
	join_parts.append(right_table)
	join_parts.append("ON")
	var full_left_column = left_table + "." + left_column
	join_parts.append(full_left_column)
	join_parts.append("=")
	var full_right_column = right_table + "." + right_column
	join_parts.append(full_right_column)
	var assembled_parts: String = " ".join(join_parts)
	return assembled_parts



func get_unique_elements_from_column(table_param: String, column_param: String) -> Array:
	var element_dictionaries: Array = query_data("select distinct " + column_param + " from " + table_param)
	var element_array: Array
	for dictionary_iteration in element_dictionaries:
		element_array.append(dictionary_iteration[column_param])
	return element_array












"""
change happens
item calls out with details
add change to changelog
	add to previous log if same item editing (like when each letter of word is typed)
add detail to change dictionary
check if new value is original value, purge from dictionary if so


current_database_changes - ease of updating changes and database
database_changelog - history and undo
"""
