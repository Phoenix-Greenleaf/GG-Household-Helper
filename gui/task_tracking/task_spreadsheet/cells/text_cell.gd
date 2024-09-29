extends LineEdit

var saved_task_id: String
var saved_column: String
var saved_text: String



func _ready() -> void:
	name = "TextCell"
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)


func disable_cell(editing_locked: bool) -> void:
	editable = !editing_locked


func set_text_cell(task_id_param: String, column_param: String, text_param: String) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	saved_text = text_param
	text = text_param




func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(get_combined_minimum_size().x, self)


func sync_size(size_param: float) -> void:
	var min_size: Vector2 = Vector2(size_param, 0)
	custom_minimum_size = min_size
