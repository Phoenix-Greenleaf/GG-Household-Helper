extends Control


func _ready() -> void:
	SceneTransition.fade_from_black()


func _on_exit_button_pressed() -> void:
	SceneTransition.fade_quit()


func _on_task_tracking_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/task_tracking_menu.tscn")


func _on_household_documents_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/documents_menu.tscn")


func _on_storage_organizer_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/storage_menu.tscn")


func _on_sensor_network_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/sensor_network_menu.tscn")


func _on_display_screens_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/display_screens_menu.tscn")


func _on_settings_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/main_settings_screen.tscn")

