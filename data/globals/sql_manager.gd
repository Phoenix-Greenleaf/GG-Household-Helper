extends Node

var active_database: SQLite
var database_directory: String = "user://"
var household_name: String
var household_default_name := "My"
var database_standard_title: String = "_household_helper_data"

var program_info_table := "Program Info"
var user_info_table := "User Info"
var task_info_table := "Task Info"
var monthly_task_table := "Monthly Task"
var weekly_task_table := "Weekly Task"
var daily_task_table := "Daily Task"
var changelog_table := "Change Log"
var section_table := "Section"

var unassigned_user_text := "Not Assigned"
var unassigned_user_color := Color.WHITE

var id := "id"
var name_ := "name"
var color_ := "color"
var status := "status"
var completed_by := "completed_by"
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
var foreign_key := "foreign_key" # {fk : foreign_table.foreign_column}




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


func create_column_primary_id() -> Dictionary:
	var column: Dictionary = {
		id : {data_type:int_, primary_key:true, not_null:true, auto_increment:true}
		}
	return column


func add_column_primary_id(columns_parameter: Dictionary) -> Dictionary:
	var combined_columns: Dictionary = create_column_primary_id()
	combined_columns.merge(columns_parameter)
	return combined_columns


func create_table_user_info() -> void:
	var data_columns: Dictionary = {
		name_ : {data_type:text},
		color_ : {data_type:text}
	}
	var table_data: Dictionary = add_column_primary_id(data_columns)
	active_database.create_table(user_info_table, table_data)
	add_unassigned_user_row()


func add_unassigned_user_row() -> void:
	var data: Dictionary = {
		name_ : unassigned_user_text,
		color_ : unassigned_user_color.to_html()
	}
	active_database.insert_row(user_info_table, data)


func create_table_task_info() -> void:
	var data_columns: Dictionary = {
		task : {data_type:text},
		section : {data_type:int_, foreign_key:table_column_address(section_table, id)},
		group : {data_type:text},
		assigned_to : {data_type:int_, foreign_key:table_column_address(user_info_table, id)},
		description : {data_type:text},
		time_of_day : {data_type:text},
		priority : {data_type:text},
		location : {data_type:text},
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
	var table_data: Dictionary = add_column_primary_id(data_columns)
	active_database.create_table(task_info_table, table_data)


func table_column_address(table_parameter: String, column_parameter: String) -> String:
	var address: String = table_parameter + "." + column_parameter
	return address


func create_table_section_tracking() -> void:
	var data_columns: Dictionary = {
		year : {data_type:text},
		month : {data_type:text},
		section : {data_type:text},
		}
	var table_data: Dictionary = add_column_primary_id(data_columns)
	active_database.create_table(section_table, table_data)


func create_table_monthly_task() -> void:
	var data_columns: Dictionary = {
		task : {data_type:int_, foreign_key:table_column_address(task_info_table, id)},
		section : {data_type:int_, foreign_key:table_column_address(section_table, id)},
		name_ : {data_type:text},
		name_ : {data_type:text},
		name_ : {data_type:text},
		name_ : {data_type:text},
	}
	var table_data: Dictionary = add_column_primary_id(data_columns)
	active_database.create_table(monthly_task_table, table_data)


func create_table_weekly_task() -> void:
	var data_columns: Dictionary = {
		name_ : {data_type:text}
	}
	var table_data: Dictionary = add_column_primary_id(data_columns)
	active_database.create_table(weekly_task_table, table_data)


func create_table_daily_task() -> void:
	var data_columns: Dictionary = {
		name_ : {data_type:text}
	}
	var table_data: Dictionary = add_column_primary_id(data_columns)
	active_database.create_table(daily_task_table, table_data)


func create_table_program_info() -> void:
#	placeholder
	pass


func create_table_changelog() -> void:
#	placeholder
	pass
