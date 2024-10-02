extends Button
class_name MultiLineCell

var saved_task_id: String
var saved_column: String
var saved_multi_text: String
var saved_new_data_id: int




# cell_modified(new_multi_text: String) needs to be called when multi-text is changed.
func _ready() -> void:
	name = "MultiLineCell"
	text = "Ready"
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)
	TaskSignalBus._on_data_cell_remote_updated.connect(remote_update)


func disable_cell(editing_locked: bool) -> void:
	disabled = editing_locked


func set_multi_line_cell(task_id_param: String, column_param: String, multi_text_param: String) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	if multi_text_param == "<null>" or multi_text_param == "":
		saved_multi_text = "(None)"
	else:
		saved_multi_text = multi_text_param
	update_button()


func update_button() -> void:
	var description_preview_length: int = (
		TaskTrackingGlobal.active_settings.description_preview_length
	)
	var button_text := ""
	if saved_multi_text.length() > description_preview_length:
		button_text = saved_multi_text.left(description_preview_length) + "..."
	else:
		button_text = saved_multi_text
	text = button_text



func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(get_combined_minimum_size().x, self)


func sync_size(size_param: float) -> void:
	var min_size: Vector2 = Vector2(size_param, 0)
	custom_minimum_size = min_size


func cell_modified(new_multi: String) -> void:
	var current_id
	if not saved_task_id.is_empty():
		current_id = saved_task_id
	if saved_new_data_id:
		current_id = saved_new_data_id
	TaskSignalBus._on_data_cell_modified.emit(current_id, saved_column, saved_multi_text, new_multi)
	saved_multi_text = new_multi


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
	saved_multi_text = new_value


func _on_pressed() -> void:
	TaskSignalBus._on_description_button_pressed.emit(self)
