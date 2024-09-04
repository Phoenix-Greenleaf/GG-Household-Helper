extends Node

var active_database: SQLite
var database_directory: String = "user://"
var household_name: String
var database_standard_title: String = "_household_helper_data"

var task_info_table := "task_info"
var main_task_tracking_table := "main_task_tracking"
var monthly_task_table := "monthly_task"
var weekly_task_table := "weekly_task"
var daily_task_table := "daily_task"
var user_info_table := "user_info"
var program_info_table := "program_info"
var changelog_table := "changelog"





func database_path() -> String:
	if not household_name:
		push_warning("Using default household name for database path.")
		household_name = "my"
	var database_combined_path: String = database_directory + household_name + database_standard_title
	return database_combined_path


func create_new_database() -> void:
	active_database = SQLite.new()
	active_database.path = database_path()


func create_table_task_info() -> void:
	var table: Dictionary = {
		"id" : {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name" : {"data_type":"text"},
		"score" : {"data_type":"int"}
	}
	active_database.create_table("task_info", table)


func create_table_main_task_tracking() -> void:
	pass


func create_table_monthly_task() -> void:
	pass


func create_table_weekly_task() -> void:
	pass


func create_table_daily_task() -> void:
	pass


func create_table_user_info() -> void:
	pass


func create_table_program_info() -> void:
	pass


func create_table_changelog() -> void:
#	placeholder
	pass
