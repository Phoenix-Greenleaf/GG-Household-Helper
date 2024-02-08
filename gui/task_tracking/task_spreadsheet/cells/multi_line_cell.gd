extends Button
class_name MultiLineCell

@export var saved_task: TaskData

func _ready() -> void:
	name = "MultiLineCell"


func update_data(text_parameter: String) -> void:
	saved_task.description = text_parameter
	update_button()
	SignalBus._on_task_set_data_modified.emit()
	print_verbose("MultiLineCell", saved_task.name, "func update_data emits '_on_task_set_data_modified'")


func initialize_data(text_parameter: String) -> void:
	saved_task.description = text_parameter
	update_button()


func update_button() -> void:
	var description_preview_length: int = DataGlobal.settings_file.task_setting_description_preview_length
	var button_text := ""
	if saved_task.description.length() > description_preview_length:
		button_text = saved_task.description.left(description_preview_length) + "..."
	else:
		button_text = saved_task.description
	self.text = button_text
