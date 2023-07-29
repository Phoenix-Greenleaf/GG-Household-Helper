extends Control

@onready var menu_button = $"Main Margin/Main HBox/Side Menu VBox/Menu Button"

func _ready() -> void:
	var popup = menu_button.get_popup()
	popup.connect("id_pressed", menu_button_actions)


func menu_button_actions(id):
	match id:
		0:
			get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
		1:
			print("Save File Pressed")
		2:
			print("Change Logs Pressed")
