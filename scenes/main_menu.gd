extends Control


@onready var versoning: Label = %Versoning


func _ready() -> void:
	versoning.text = "Version " + ProjectSettings.get_setting("application/config/version")
	SqlManager.create_new_database()


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
