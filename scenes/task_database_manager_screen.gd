extends PanelContainer


func _ready() -> void:
	TaskSignalBus._on_data_manager_close_manager_button_pressed.connect(close_data_manager_screen)


func close_data_manager_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_main_menu.tscn")
