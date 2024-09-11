extends Control


@onready var versoning: Label = %Versoning

var sql_test_active: bool = false
var sql_inject_old_data: bool = true




func _ready() -> void:
	versoning.text = "Version " + ProjectSettings.get_setting("application/config/version")
	sql_testing()




func sql_testing() -> void:
	if not sql_test_active:
		return
	#var database_path: String = SqlManager.database_path()
	#var tables_exist_query: Array = SqlManager.select_data("sqlite_master", "type='table' and name='" + SqlManager.user_info_table + "'", ["count(name)"])
	var tables_exist: bool = SqlManager.database_tables_exist()   #tables_exist_query[0]["count(name)"]
	prints("")
	prints("Sql Table Check")
	prints(tables_exist)
	prints("")
	if not tables_exist:
		prints("Createing new database")
		SqlManager.create_new_database()
	if not sql_inject_old_data:
		return
	TaskTrackingGlobal.load_data_task_set("Greenleaf Household", 2024)
	TaskTrackingGlobal.transer_old_data_to_database()



func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_task_tracking_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_main_menu.tscn")


func _on_household_documents_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/documents_menu.tscn")


func _on_storage_organizer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/storage_menu.tscn")


func _on_sensor_network_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/sensor_network_menu.tscn")


func _on_display_screens_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/display_screens_menu.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_settings_screen.tscn")
