extends LineEdit

var saved_task_id: String
var saved_column: String
var saved_text: String



func _ready() -> void:
	name = "TextCell"
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)


func disable_cell(editing_locked: bool) -> void:
	editable = !editing_locked


func set_text_cell(task_id_param: String, column_param: String, text_param: String) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	saved_text = text_param
	text = text_param
