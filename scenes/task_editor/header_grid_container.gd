extends GridContainer



func _ready() -> void:
	signal_connections()


func signal_connections() -> void:
	TaskSignalBus._on_header_cell_created.connect(add_header_cell)
	TaskSignalBus._on_grid_column_count_changed.connect(set_columns)
	TaskSignalBus._on_grid_reload_pressed.connect(clear_header_children)






func add_header_cell(cell_parameter) -> void:
	self.add_child(cell_parameter)


func clear_header_children() -> void:
	var children = self.get_children()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()
