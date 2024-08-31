extends CenterContainer



func _ready() -> void:
	visible = false
	TaskSignalBus._on_data_manager_remote_open_pressed.connect(remote_open_data_manager)
	TaskSignalBus._on_data_manager_close_manager_button_pressed.connect(remote_close_data_manager)

func remote_open_data_manager() -> void:
	visible = true


func remote_close_data_manager() -> void:
	visible = false
