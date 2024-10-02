extends LineEdit

var saved_task_id: String
var saved_column: String
var saved_text: String
var saved_new_data_id: int



func _ready() -> void:
	name = "TextCell"
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)
	text_changed.connect(cell_modified)
	TaskSignalBus._on_data_cell_remote_updated.connect(remote_update)


func disable_cell(editing_locked: bool) -> void:
	editable = !editing_locked


func set_text_cell(task_id_param: String, column_param: String, text_param: String) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	update_text(text_param)


func update_text(text_param: String) -> void:
	saved_text = text_param
	text = text_param


func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(get_combined_minimum_size().x, self)


func sync_size(size_param: float) -> void:
	var min_size: Vector2 = Vector2(size_param, 0)
	custom_minimum_size = min_size


func cell_modified() -> void:
	var current_id
	if not saved_task_id.is_empty():
		current_id = saved_task_id
	if saved_new_data_id:
		current_id = saved_new_data_id
	TaskSignalBus._on_data_cell_modified.emit(current_id, saved_column, saved_text, text)
	saved_text = text


func remote_update(cell_id, column_name: String, new_value) -> void:
	if column_name != saved_column:
		return
	match type_string(typeof(cell_id)):
		"String":
			if cell_id != saved_task_id:
				return
		"int":
			if cell_id != saved_new_data_id:
				return
	update_text(new_value)
