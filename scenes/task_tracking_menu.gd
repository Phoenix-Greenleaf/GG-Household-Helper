extends Control

func _ready() -> void:
	SceneTransition.fade_from_black()


func _on_task_sheets_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/editor.tscn")


func _on_data_manager_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/task_data_manager_screen.tscn")


func _on_back_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/main_menu.tscn")


func _on_settings_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/task_tracking_settings.tscn")

