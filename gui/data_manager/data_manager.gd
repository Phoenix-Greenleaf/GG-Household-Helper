extends PanelContainer


@onready var close_manager_button: Button = %CloseManager



func _ready() -> void:
	close_manager_button.pressed.connect(emit_exit_signal)
	




func emit_exit_signal() -> void:
	SignalBus.emit_signal("data_manager_close")
	prints("data manager close Emitted")
