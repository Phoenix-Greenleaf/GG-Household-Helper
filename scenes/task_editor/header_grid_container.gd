extends GridContainer

const HEADER_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/header_cell.tscn")

var header_columns: Array




func _ready() -> void:
	signal_connections()


func signal_connections() -> void:
	#TaskSignalBus._on_grid_reload_pressed.connect(clear_header_children)
	TaskSignalBus._on_task_grid_populated.connect(create_header_row)
	TaskSignalBus._on_task_cells_resized_workaround_all_columns.connect(resize_all_columns)



func clear_header_children() -> void:
	var children = get_children()
	for current_kiddo in children:
		remove_child(current_kiddo)
		current_kiddo.queue_free()


func create_header_row(data_row_param: Dictionary) -> void:
	clear_header_children()
	header_columns = []
	generate_header_columns(data_row_param)
	for header_iteration in header_columns:
		create_header_cell(header_iteration)
	var child_count: int = get_child_count()
	columns = child_count
	TaskSignalBus._on_task_grid_column_count_changed.emit(child_count)



func generate_header_columns(data_row_param: Dictionary) -> void:
	var row_keys: Array = data_row_param.keys()
	for column_iteration: String in row_keys:
		if column_iteration == "task_info_id" or column_iteration == "days_in_month":
			continue
		if column_iteration.ends_with("_currently_assigned") or column_iteration.ends_with("_completed_by"):
			continue
		if column_iteration.ends_with("_status"):
			var reduced_iteration: String = column_iteration.replace("_status", "")
			header_columns.append(reduced_iteration)
			continue
		header_columns.append(column_iteration)




func create_header_cell(column_param: String) -> void:
	var printing_title: String = column_param.capitalize()
	var new_header_cell: PanelContainer = HEADER_CELL.instantiate()
	add_child(new_header_cell)
	new_header_cell.set_header_title(column_param, printing_title)


func resize_all_columns() -> void:
	prints("Resizing All Columns")
	for header_iteration in header_columns:
		TaskSignalBus._on_task_cells_resized_workaround.emit(header_iteration)
