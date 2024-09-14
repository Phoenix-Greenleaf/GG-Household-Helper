extends LineEdit

@export var saved_task: TaskData
@export var saved_type: String

var first_row_flag: bool = false
var column_pair: String


func _ready() -> void:
	name = "TextCell"
	self.text_changed.connect(update_active_data)


func update_active_data(text_parameter) -> void:
	match saved_type:
		"Task Name":
			saved_task.name = text_parameter
		"Group":
			saved_task.group = text_parameter
		"Assigned User":
			saved_task.assigned_user[0] = text_parameter
		"Location":
			saved_task.location = text_parameter
		"Cycle Time Unit":
			saved_task.time_unit = text_parameter
		"Last Completed":
			saved_task.last_completed = text_parameter
		_:
			prints("LineEdit active data update failed")
			return
	TaskSignalBus._on_data_set_modified.emit()




func create_text_cell(text: String, current_type: String, column_group: String = "") -> void:
	var cell: LineEdit = text_cell.instantiate()
	self.add_child(cell)
	cell.text = text
	cell.saved_task = current_task
	cell.saved_type = current_type
	add_cell_to_groups(cell, column_group)
	set_first_row_flag(cell)
