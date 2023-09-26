extends Button

@export var saved_task: TaskData
@export var saved_type: String

var button_text: String


func _ready() -> void:
	pressed.connect(_on_delete_button_pressed)

func prep_delete_button() -> void:
	var task_name: String = saved_task.name
	button_text = "Delete " + task_name
	text = button_text


func _on_delete_button_pressed() -> void:
	if text == button_text:
		DataGlobal.button_based_message(self, "CONFIRM DELETE")
		return
	SignalBus._on_task_delete_button_primed_and_pressed.emit(saved_task)
