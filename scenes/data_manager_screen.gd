extends MarginContainer


func _ready() -> void:
	SignalBus.data_manager_close.connect(close_data_manager_screen)



func close_data_manager_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
