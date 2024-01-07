extends Control

func _ready() -> void:
	SceneTransition.fade_from_black()


func _on_exit_button_pressed() -> void:
	SceneTransition.fade_to_black("res://scenes/main_menu.tscn")
