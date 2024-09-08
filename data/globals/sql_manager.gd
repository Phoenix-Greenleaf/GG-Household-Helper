extends Node

var active_database: SQLite
var database_directory: String = "user://"
var household_name: String
var household_default_name := "My"
var database_standard_title: String = "_household_helper_data"

var program_info_table := "program_info"
var user_info_table := "user_info"
var task_info_table := "task_info"
var monthly_tasks_table := "monthly_tasks"
var weekly_tasks_table := "weekly_tasks"
var daily_tasks_table := "daily_tasks"
var changelog_table := "change_log"
var sections_table := "sections"
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
var group := "group"
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

var data_type := "data_type"
var int_ := "int"
var real := "real"
var text := "text"
var char_part := "char("

var not_null := "not_null"
var primary_key := "primary_key"
var auto_increment := "auto_increment"
var foreign_key := "foreign_key" # {"foreign_key" : "foreign_table.foreign_column"}




func char_(number: int) -> String:
	var char_combined: String = char_part + str(number) + ")"
	return char_combined


func database_path() -> String:
	if not household_name:
		push_warning("Using default household name for database path.")
		household_name = household_default_name.to_snake_case()
	var database_combined_path: String = database_directory + household_name + database_standard_title
	return database_combined_path


func create_new_database() -> void:
	active_database = SQLite.new()
	active_database.path = database_path()
	active_database.foreign_keys = true
	active_database.open_db()
	create_all_tables()


func create_all_tables() -> void:
	create_table_program_info()
	create_table_user_info()
	create_table_task_info()
	create_table_event_info()
	create_table_sections()
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
		task : {data_type:text},
		section : {data_type:int_, foreign_key:table_column_address(sections_table, id)},
		group : {data_type:text},
		assigned_to : {data_type:int_, foreign_key:table_column_address(user_info_table, id)},
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
		monthly_scheduling_end : {data_type:text}
	}
	create_new_table_with_primary_id(task_info_table, data_columns)


func table_column_address(table_parameter: String, column_parameter: String) -> String:
	var address: String = table_parameter + "." + column_parameter
	return address


func create_table_event_info() -> void:
	var data_columns: Dictionary = {
		status : {data_type:text},
		assigned_to : {data_type:int_, foreign_key:table_column_address(user_info_table, id)},
		completed_by : {data_type:int_, foreign_key:table_column_address(user_info_table, id)}
	}
	create_new_table_with_primary_id(event_info_table, data_columns)


func create_table_sections() -> void:
	var data_columns: Dictionary = {
		year : {data_type:text},
		month : {data_type:text},
		section : {data_type:text},
		}
	create_new_table_with_primary_id(sections_table, data_columns)


func create_table_section_tasks(section_parameter: DataGlobal.Section) -> void:
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
	add_columns_section_event_info(event_count, event_units, data_columns)
	create_new_table_with_primary_id(event_section_title, data_columns)


func section_tasks_standard_data() -> Dictionary:
	var standard_data: Dictionary = {
		task : {data_type:int_, foreign_key:table_column_address(task_info_table, id)},
		section : {data_type:int_, foreign_key:table_column_address(sections_table, id)},
	}
	return standard_data


func add_columns_section_event_info(event_count_parameter: int, event_units_parameter: String, data_parameter: Dictionary) -> void:
	for event_iteration in event_count_parameter:
		add_one_event_column(event_units_parameter, event_iteration, data_parameter)


func add_one_event_column(section_text: String, current_number: int, data_parameter: Dictionary) -> void:
	var column_text = section_text + "_" + str(current_number + 1)
	var new_event: Dictionary = {
		column_text : {data_type:int_, foreign_key:table_column_address(event_info_table, id)}
	}
	data_parameter.merge(new_event)


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
	var returned_data: Array = []
	active_database.query(query_parameter)
	returned_data = active_database.query_result
	return returned_data


func update_data(table_parameter: String, conditions_parameter: String, row_data_parameter: Dictionary) -> void:
	active_database.update_rows(table_parameter, conditions_parameter, row_data_parameter)


func remove_data(table_parameter: String, conditions_parameter: String) -> void:
	active_database.delete_rows(table_parameter, conditions_parameter)
