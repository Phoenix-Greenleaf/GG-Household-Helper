extends Control

func _on_task_sheets_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/editor.tscn")


func _on_data_manager_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_data_manager_screen.tscn")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_settings.tscn")
	SignalBus.remote_task_settings_reload.emit()
