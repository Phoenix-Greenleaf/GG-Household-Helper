extends SpinBox

var saved_task_id: String
var saved_column: String
var saved_number: int
var saved_new_data_id: int


func _ready() -> void:
	name = "NumberCell"
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)
	value_changed.connect(cell_modified)
	TaskSignalBus._on_data_cell_remote_updated.connect(remote_update)


func disable_cell(editing_locked: bool) -> void:
	editable = !editing_locked


func set_number_cell(task_id_param, column_param: String, number_param: String, min_param: int, max_param: int) -> void:
	if type_string(typeof(task_id_param)) == "String":
		saved_task_id = task_id_param
	if type_string(typeof(task_id_param)) == "int":
		saved_new_data_id = task_id_param
	saved_column = column_param
	saved_number = number_param.to_int()
	min_value = min_param
	max_value = max_param
	update_number_value(number_param.to_int())


func update_number_value(number_param: int) -> void:
	set_value_no_signal(number_param)
	saved_number = number_param


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
	TaskSignalBus._on_data_cell_modified.emit(current_id, saved_column, saved_number, value)
	saved_number = value


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
	update_number_value(new_value)


#
#
#
		#"year", "daily_scheduling_start", "days_per_cycle", "daily_scheduling_end",\
					#"weekly_scheduling_start", "weeks_per_cycle", "weekly_scheduling_end",\
					#"monthly_scheduling_start", "months_per_cycle", "monthly_scheduling_end":
