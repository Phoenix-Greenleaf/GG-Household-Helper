extends Control


@onready var versoning: Label = %Versoning

var sql_inject_old_data: bool = true

var sql_query_test_active: bool = false




func _ready() -> void:
	versoning.text = "Version " + ProjectSettings.get_setting("application/config/version")
	if sql_inject_old_data:
		sql_transfer_testing()
	if sql_query_test_active:
		sql_query_test()




func sql_transfer_testing() -> void:
	TaskTrackingGlobal.load_data_task_set("Greenleaf Household", 2024)
	TaskTrackingGlobal.transer_old_data_to_database()


func sql_query_test() -> void:
	var query_string := "SELECT task_info.task, user_info.name FROM task_info JOIN user_info ON task_info.assigned_to = user_info.user_info_id"
	prints("")
	prints("Query Test Results")
	prints(SqlManager.query_data(query_string))
	prints("")


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
