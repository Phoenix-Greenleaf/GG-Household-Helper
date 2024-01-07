extends PanelContainer


func _ready() -> void:
	SignalBus.data_manager_close.connect(close_data_manager_screen)
	SceneTransition.fade_from_black()


func close_data_manager_screen() -> void:
	SceneTransition.fade_to_black("res://scenes/task_tracking_menu.tscn")
