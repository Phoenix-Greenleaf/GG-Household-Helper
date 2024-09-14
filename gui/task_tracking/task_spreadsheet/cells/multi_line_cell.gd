extends Button
class_name MultiLineCell

@export var saved_task: TaskData

var first_row_flag: bool = false
var column_pair: String


func _ready() -> void:
	name = "MultiLineCell"


func update_data(text_parameter: String) -> void:
	saved_task.description = text_parameter
	update_button()
	TaskSignalBus._on_data_set_modified.emit()
	print_verbose("MultiLineCell", saved_task.name,
		"func update_data emits '_on_task_set_data_modified'"
	)


func initialize_data(text_parameter: String) -> void:
	saved_task.description = text_parameter
	update_button()


func update_button() -> void:
	var description_preview_length: int = (
		TaskTrackingGlobal.active_settings.description_preview_length
	)
	var button_text := ""
	if saved_task.description.length() > description_preview_length:
		button_text = saved_task.description.left(description_preview_length) + "..."
	else:
		button_text = saved_task.description
	self.text = button_text


func create_multi_line_cell(multi_text_parameter: String, column_group: String = "") -> void:
	var cell: Button = multi_line_cell.instantiate()
	self.add_child(cell)
	cell.saved_task = current_task
	cell.initialize_data(multi_text_parameter)
	cell.pressed.connect(_on_description_button_pressed.bind(cell))
	add_cell_to_groups(cell, column_group)
	set_first_row_flag(cell) 
