extends GridContainer


func add_header_cell(cell_parameter) -> void:
	self.add_child(cell_parameter)


func clear_header_children() -> void:
	var children = self.get_children()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()
