extends OptionButton

var saved_task_id: String
var saved_column: String
var saved_user_id: int
var saved_dropdown_text: String
var saved_dropdown_item_index: int
var saved_new_data_id: int


func _ready() -> void:
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)
	item_selected.connect(cell_modified)
	TaskSignalBus._on_data_cell_remote_updated.connect(remote_update)


func disable_cell(editing_locked: bool) -> void:
	disabled = editing_locked


func set_dropdown_cell(task_id_param, column_param: String, dropdown_param: String, dropdown_items: Array, user_id_param: int) -> void:
	if type_string(typeof(task_id_param)) == "String":
		saved_task_id = task_id_param
	if type_string(typeof(task_id_param)) == "int":
		saved_new_data_id = task_id_param
	saved_column = column_param
	#saved_dropdown_item_id = 0
	saved_dropdown_text = dropdown_param.capitalize()
	if user_id_param != -1:
		saved_user_id = user_id_param
	var item_id: int = 0
	if not dropdown_items[0]:
		return
	for item_iteration in dropdown_items:
		if item_iteration == null:
			continue
		add_item(item_iteration, item_id)
		if item_iteration == saved_dropdown_text:
			var dropdown_item_id = item_id
			saved_dropdown_item_index = get_item_index(dropdown_item_id)
		item_id += 1
	selected = saved_dropdown_item_index



func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(get_combined_minimum_size().x, self)


func sync_size(size_param: float) -> void:
	var min_size: Vector2 = Vector2(size_param, 0)
	custom_minimum_size = min_size


func cell_modified(new_selected_index: int) -> void:
	var current_id
	if not saved_task_id.is_empty():
		current_id = saved_task_id
	if saved_new_data_id:
		current_id = saved_new_data_id
	TaskSignalBus._on_data_cell_modified.emit(current_id, saved_column, saved_dropdown_item_index, new_selected_index)
	saved_dropdown_item_index = new_selected_index


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
	selected = new_value
	saved_dropdown_item_index = new_value
