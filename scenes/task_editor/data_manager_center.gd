extends CenterContainer



func _ready() -> void:
	SignalBus._on_task_editor_data_manager_remote_open_pressed.connect(remote_open_data_manager)


func remote_open_data_manager() -> void:
	visible = true
