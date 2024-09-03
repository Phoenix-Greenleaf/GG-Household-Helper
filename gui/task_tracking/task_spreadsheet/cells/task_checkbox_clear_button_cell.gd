extends Button

@export var saved_task: TaskData

var first_row_flag: bool = false
var column_pair: String


func _ready() -> void:
	pressed.connect(_on_task_checkbox_clear_button_pressed)

func _on_task_checkbox_clear_button_pressed() -> void:
	var reset_safety_message := "Click to CONFIRM Reset"
	if text != reset_safety_message:
		DataGlobal.button_based_message(self, reset_safety_message, 6)
		return
	if text == reset_safety_message:
		saved_task.clear_self_checkboxes()
		TaskSignalBus._on_grid_reload_pressed.emit()

func prep_button() -> void:
	var task_name: String = saved_task.name
	text = "Reset '" + task_name + "'"
