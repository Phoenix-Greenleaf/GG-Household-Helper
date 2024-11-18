extends OptionButton

var saved_task_id: String
var saved_new_data_id: int
var saved_column: String
var saved_dropdown_text: String


func _ready() -> void:
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)
	item_selected.connect(cell_modified)
	TaskSignalBus._on_data_cell_remote_updated.connect(remote_update)


func disable_cell(editing_locked: bool) -> void:
	disabled = editing_locked


func set_dropdown_cell(task_id_param, column_param: String, dropdown_param: String, dropdown_items: Array) -> void:
	if type_string(typeof(task_id_param)) == "String":
		saved_task_id = task_id_param
	if type_string(typeof(task_id_param)) == "int":
		saved_new_data_id = task_id_param
	saved_column = column_param
	saved_dropdown_text = dropdown_param.capitalize()
	if dropdown_items.is_empty():
		return
	for item_iteration in dropdown_items:
		if item_iteration == null:
			continue
		add_item(item_iteration)
	for index_iteration in item_count:
		if get_item_text(index_iteration) == saved_dropdown_text:
			selected = index_iteration


func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(get_combined_minimum_size().x, self)


func sync_size(size_param: float) -> void:
	var min_size: Vector2 = Vector2(size_param, 0)
	custom_minimum_size = min_size


func cell_modified(new_selected_index: int) -> void:
	var new_selected_text: String = get_item_text(new_selected_index)
	var current_id
	if not saved_task_id.is_empty():
		current_id = saved_task_id
	if saved_new_data_id:
		current_id = saved_new_data_id
	TaskSignalBus._on_data_cell_modified.emit(current_id, saved_column, saved_dropdown_text, new_selected_text)
	saved_dropdown_text = new_selected_text


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
	for index_iteration in item_count:
		if get_item_text(index_iteration) == new_value:
			selected = index_iteration
			saved_dropdown_text = new_value
