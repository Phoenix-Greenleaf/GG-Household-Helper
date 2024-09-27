extends GridContainer

const HEADER_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/header_cell.tscn")

func _ready() -> void:
	signal_connections()


func signal_connections() -> void:
	#TaskSignalBus._on_grid_reload_pressed.connect(clear_header_children)
	TaskSignalBus._on_task_grid_populated.connect(create_header_row)


func clear_header_children() -> void:
	var children = get_children()
	for current_kiddo in children:
		remove_child(current_kiddo)
		current_kiddo.queue_free()


func create_header_row(data_row_param: Dictionary) -> void:
	clear_header_children()
	var queried_columns: Array = data_row_param.keys()
	for column_iteration in queried_columns:
		if column_iteration == "task_info_id":
			continue
		create_header_cell(column_iteration)
	var child_count: int = get_child_count()
	columns = child_count
	TaskSignalBus._on_task_grid_column_count_changed.emit(child_count)


func create_header_cell(column_param: String) -> void:
	var printing_title: String = column_param.capitalize()
	var new_header_cell: PanelContainer = HEADER_CELL.instantiate()
	add_child(new_header_cell)
	new_header_cell.set_header_title(printing_title)
