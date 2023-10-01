extends Button

@export var saved_task: TaskData

func _ready() -> void:
	pressed.connect(_on_task_checkbox_clear_button_pressed)

func _on_task_checkbox_clear_button_pressed() -> void:
	saved_task.clear_self_checkboxes()
	SignalBus.remote_spreadsheet_grid_reload.emit()

func prep_button() -> void:
	var task_name: String = saved_task.name
	text = "Reset: " + task_name
