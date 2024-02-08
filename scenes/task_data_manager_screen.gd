extends PanelContainer


func _ready() -> void:
	SignalBus._on_task_data_manager_close_manager_button_pressed.connect(close_data_manager_screen)
	SceneTransition.fade_from_black()


func close_data_manager_screen() -> void:
	SceneTransition.fade_to_black("res://scenes/task_tracking_menu.tscn")
