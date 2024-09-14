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








func create_header_row() -> void:
	current_grid_section = GRID_SECTION.HEADER
	var column_data: Dictionary = TaskTrackingGlobal.active_data.column_data
	var column_order: Array = TaskTrackingGlobal.active_data.column_order
	column_pairs = {}
	full_header_size = 0
	sorting_count = 0
	for column_array_iteration in column_order:
		var column_iteration: String = column_array_iteration[0]
		var iteration_data: Dictionary = column_data[column_iteration]
		if iteration_data["Sorting Enabled"]:
			if iteration_data["Sorting Mode"] != 0:
				sorting_count += 1
		match column_iteration:
			"TrackerCheckboxes":
				create_checkbox_column_header(column_iteration)
			"Units/Cycle":
				create_time_unit_column_header(column_iteration)
			_:
				create_standard_column_header(column_iteration)
	prints("Full header size:", full_header_size)





func create_standard_column_header(column_parameter: String) -> void:
	var column_data: Dictionary = TaskTrackingGlobal.active_data.column_data
	var current_column_data: Dictionary = column_data[column_parameter]
	var header_text: String = column_parameter
	var column_order: int = current_column_data["Column Order"]
	var ordering_enabled: bool = true
	var sorting_mode: int = current_column_data["Sorting Mode"]
	var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	var column_group: String = column_parameter
	full_header_size += 1
	create_header_cell(header_text, column_order, ordering_enabled, sorting_mode, sorting_enabled, column_group)


#func create_time_unit_column_header(column_parameter: String) -> void:
	#var column_data: Dictionary = TaskTrackingGlobal.active_data.column_data
	#var current_column_data: Dictionary = column_data[column_parameter]
	#var header_text: String = ""
	#var column_order: int = current_column_data["Column Order"]
	#var ordering_enabled: bool = true
	#var sorting_mode: int = current_column_data["Sorting Mode"]
	#var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	#var column_group: String = column_parameter
	#match TaskTrackingGlobal.current_toggled_section:
		#DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			#header_text = "Months/Cycle"
			#task_add_units_per_cycle_label.text = "Months per Cycle:"
		#DataGlobal.Section.WEEKLY:
			#header_text = "Weeks/Cycle"
			#task_add_units_per_cycle_label.text = "Weeks per Cycle:"
		#DataGlobal.Section.DAILY:
			#header_text = "Days/Cycle"
			#task_add_units_per_cycle_label.text = "Days per Cycle:"
	#full_header_size += 1
	#create_header_cell(header_text, column_order, ordering_enabled, sorting_mode, sorting_enabled, column_group)


func create_checkbox_column_header(column_parameter: String) -> void:
	var column_data: Dictionary = TaskTrackingGlobal.active_data.column_data
	var current_column_data: Dictionary = column_data[column_parameter]
	var column_order: int = current_column_data["Column Order"]
	var ordering_enabled: bool = true
	var sorting_mode: int = current_column_data["Sorting Mode"]
	var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	var checkbox := "Checkboxes"
	var header_text: String = checkbox
	var column_group: String = checkbox
	var current_section = TaskTrackingGlobal.current_toggled_section
	var current_month = DataGlobal.Month.find_key(
		TaskTrackingGlobal.current_toggled_month
	).capitalize()
	var current_year = TaskTrackingGlobal.active_data.task_set_year
	var first_column: bool = true
	match current_section:
		DataGlobal.Section.MONTHLY:
			for month in DataGlobal.month_strings:
				if month == "All":
					continue
				full_header_size += 1
				if first_column:
					create_header_cell(month, column_order, ordering_enabled, sorting_mode, false, column_group)
					first_column = false
					continue
				create_header_cell(month, column_order, false, sorting_mode, false, column_group)
		DataGlobal.Section.WEEKLY:
			header_text = "Week "
			for week_iteration in 5:
				full_header_size += 1
				var header_number = str(week_iteration + 1)
				var combined_string: String = header_text + header_number
				if first_column:
					create_header_cell(combined_string, column_order, ordering_enabled, sorting_mode, false, column_group)
					first_column = false
					continue
				create_header_cell(combined_string, column_order, false, sorting_mode, false, column_group)
		DataGlobal.Section.DAILY:
			var number_of_days = DataGlobal.days_in_month_finder(current_month, current_year)
			header_text = "Day "
			for day_iteration in number_of_days:
				full_header_size += 1
				var header_number = str(day_iteration + 1)
				var combined_string: String = header_text + header_number
				if first_column:
					create_header_cell(combined_string, column_order, ordering_enabled, sorting_mode, false, column_group)
					first_column = false
					continue
				create_header_cell(combined_string, column_order, false, sorting_mode, false, column_group)


func header_editing_prevention() -> void:
	var header_nodes: Array[Node] = self.get_children()
	for child in header_nodes:
		child.mouse_filter = 2
