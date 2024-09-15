extends LineEdit

var saved_task_id: String
var saved_column: String
var saved_text: String



func _ready() -> void:
	name = "TextCell"


func set_text_cell(task_id_param: String, column_param: String, text_param: String) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	saved_text = text_param
	text = text_param
