extends Control


func _ready() -> void:
	SceneTransition.fade_from_black()
	SignalBus._on_main_settings_back_button_pressed.connect(exit_to_main_menu)


func exit_to_main_menu() -> void:
	SceneTransition.fade_to_black("res://scenes/main_menu.tscn")
