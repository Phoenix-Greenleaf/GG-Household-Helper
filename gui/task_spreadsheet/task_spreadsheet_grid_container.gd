extends GridContainer

@export var data_for_spreadsheet : TaskSpreadsheetData

@onready var add_task_button: Button = %AddTaskButton
@onready var task_title_line_edit: LineEdit = %TaskTitleLineEdit
@onready var task_group_line_edit: LineEdit = %TaskGroupLineEdit
@onready var existing_groups_option_button: OptionButton = %ExistingGroupsOption
@onready var accept_new_task_button: Button = %AcceptNewTaskButton

var checkbox_cell = preload("res://gui/task_spreadsheet/cells/checkbox_cell.tscn")
var dropdown_cell = preload("res://gui/task_spreadsheet/cells/dropdown_cell.tscn")
var multi_line_cell = preload("res://gui/task_spreadsheet/cells/multi_line_cell.tscn")
var number_cell = preload("res://gui/task_spreadsheet/cells/number_cell.tscn")
var text_cell = preload("res://gui/task_spreadsheet/cells/text_cell.tscn")

var row_group : String = ""
var blank_counter : int = 0
var section_dropdown_items : Array
var time_of_day_dropdown_items : Array
var priority_dropdown_items : Array
var full_header_size : int 
var info_header_size : int
var checkbox_header_size : int


func _ready() -> void:
	ready_connections()
	close_new_task_panel()
	get_dropdown_items_from_global()
	if !data_for_spreadsheet:
		print("No Tasksheet found for TaskGrid....")
	else:
		var title = DataGlobal.current_tasksheet_data.spreadsheet_title
		var year = DataGlobal.current_tasksheet_data.spreadsheet_year
		prints("TaskGrid found:", title, ":", year)
		load_existing_data()


func ready_connections() -> void:
	if DataGlobal.current_tasksheet_data:
		data_for_spreadsheet = DataGlobal.current_tasksheet_data
	SignalBus._on_current_tasksheet_data_changed.connect(update_grid_spreadsheet)
	SignalBus._on_editor_mode_changed.connect(toggle_info_checkbox_modes)


func test_spreadsheet_initialization() -> void:
	pass


func toggle_info_checkbox_modes() -> void:
	var info_group : Array[Node] = get_tree().get_nodes_in_group("Info")
	var checkbox_group : Array[Node] = get_tree().get_nodes_in_group("Checkbox")
	if DataGlobal.current_toggled_mode == DataGlobal.editor_modes["Info"]:
		group_visibility(info_group, true)
		group_visibility(checkbox_group, false)
	elif DataGlobal.current_toggled_mode == DataGlobal.editor_modes["Checkbox"]:
		group_visibility(checkbox_group, true)
		group_visibility(info_group, false)
	else:
		prints("Mode toggle has gone wrong")
	set_grid_columns()


func group_visibility(target_group: Array[Node], visibility_bool: bool) -> void:
	for node_iteration in target_group:
		node_iteration.visible = visibility_bool


func get_dropdown_items_from_global() -> void:
	for item in DataGlobal.Section.keys():
		section_dropdown_items.append(item.capitalize())
	for item in DataGlobal.TimeOfDay.keys():
		time_of_day_dropdown_items.append(item.capitalize())
	for item in DataGlobal.Priority.keys():
		priority_dropdown_items.append(item.capitalize())


func update_grid_spreadsheet() -> void:
	data_for_spreadsheet = DataGlobal.current_tasksheet_data
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	prints("TaskGrid updated:", title, ":", year)
	var children = self.get_children()
	var count = self.get_child_count()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()
	prints(count, "children in line for freedom")
	load_existing_data()


func _on_add_task_button_pressed() -> void:
	match add_task_button.text:
		"Add Task":
			open_new_task_panel()
		"Cancel":
			close_new_task_panel()


func open_new_task_panel() -> void:
	add_task_button.text = "Cancel"
	task_title_line_edit.visible = true
	task_group_line_edit.visible = true
	existing_groups_option_button.visible = true
	accept_new_task_button.visible = true


func close_new_task_panel() -> void:
	add_task_button.text = "Add Task"
	task_title_line_edit.visible = false
	task_group_line_edit.visible = false
	existing_groups_option_button.visible = false
	accept_new_task_button.visible = false


func create_new_task_data() -> void: #task coded model, the data side
	var new_task = TaskData.new()
	var new_task_title = task_title_line_edit.text
	var new_task_group = "None"
	if task_group_line_edit.text:
		new_task_group = task_group_line_edit.text
	row_group = new_task_group
	var new_task_section := DataGlobal.current_toggled_section
	new_task.offbrand_init(new_task_title, new_task_section, new_task_group)
	
	match new_task_section:
		DataGlobal.Section.YEARLY:
			var current_group = data_for_spreadsheet.spreadsheet_year_groups
			data_for_spreadsheet.spreadsheet_year_data.append(new_task)
			create_task_group(new_task_group, current_group)
			create_existing_groups_option_button_items(current_group)
		DataGlobal.Section.MONTHLY:
			data_for_spreadsheet.spreadsheet_month_data.append(new_task)
			create_task_group(new_task_group, data_for_spreadsheet.spreadsheet_month_groups)
		DataGlobal.Section.WEEKLY:
			data_for_spreadsheet.spreadsheet_week_data.append(new_task)
			create_task_group(new_task_group, data_for_spreadsheet.spreadsheet_week_groups)
		DataGlobal.Section.DAILY:
			data_for_spreadsheet.spreadsheet_day_data.append(new_task)
			create_task_group(new_task_group, data_for_spreadsheet.spreadsheet_day_groups)
	create_task_row_cells(new_task)


func new_task_field_reset() -> void:
	task_title_line_edit.clear()
	task_group_line_edit.clear()
	existing_groups_option_button.select(0)


func create_task_group(task_group : String, section_groups : Array) -> void:
			var groups : Array = section_groups
			if groups.has(task_group):
				prints("Task group", task_group, "already exists.")
			else:
				groups.append(task_group)
				groups.sort()
				prints("Created new task group:", task_group)


func load_existing_data() -> void:
	create_header_row()
	match DataGlobal.current_toggled_section:
		DataGlobal.Section.YEARLY:
			for data_iteration in data_for_spreadsheet.spreadsheet_year_data:
				create_task_row_cells(data_iteration)
		DataGlobal.Section.MONTHLY:
			for data_iteration in data_for_spreadsheet.spreadsheet_month_data:
				create_task_row_cells(data_iteration)
		DataGlobal.Section.WEEKLY:
			for data_iteration in data_for_spreadsheet.spreadsheet_week_data:
				create_task_row_cells(data_iteration)
		DataGlobal.Section.DAILY:
			for data_iteration in data_for_spreadsheet.spreadsheet_day_data:
				create_task_row_cells(data_iteration)
	toggle_info_checkbox_modes()


func _on_sort_tasks_button_pressed() -> void:
	pass


func _on_accept_new_task_button_pressed() -> void:
	if not task_title_line_edit.text:
		DataGlobal.button_based_message(accept_new_task_button, "Title Needed!")
		return
	if self.get_child_count() == 0:
		create_header_row()
	else:
		prints("Header Already Added; child count:", self.get_child_count())
	create_new_task_data()
	close_new_task_panel()
	new_task_field_reset()
	toggle_info_checkbox_modes()
	


func create_existing_groups_option_button_items(group) -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	for item in group:
		existing_groups_option_button.add_item(item)


func _on_existing_groups_option_item_selected(index: int) -> void:
	var group_text : String = existing_groups_option_button.get_item_text(index)
	task_group_line_edit.text = group_text


func create_header_row() -> void:
	var info = "Info"
	create_text_cell("Task") #1
	create_text_cell("Section") #2
	create_text_cell("Group") #3
	create_text_cell("Assignment", info) #4
	create_text_cell("Description", info) #5
	create_text_cell("Time Of Day", info) #6
	create_text_cell("Priority", info) #7
	create_text_cell("Location", info) #8
	create_text_cell("Cycle Time Unit", info) #9
	create_text_cell("Time Units Per Cycle", info) #10
	create_text_cell("Time Units Added When Skipped", info) #11
	create_text_cell("Last Completed", info) #12
	var checkbox = "Checkbox"
	
	full_header_size = self.get_child_count()
	info_header_size = get_tree().get_nodes_in_group("Info").size()
	checkbox_header_size = get_tree().get_nodes_in_group("Checkbox").size()
	set_grid_columns()
	
	


func set_grid_columns() -> void:
	var header_size : int = 0
	prints("Header Sizes, Full:", full_header_size, " Info:", info_header_size, " Checkbox:", checkbox_header_size)
	if DataGlobal.current_toggled_mode == DataGlobal.editor_modes["Info"]:
		header_size = full_header_size - checkbox_header_size
	elif DataGlobal.current_toggled_mode == DataGlobal.editor_modes["Checkbox"]:
		header_size = full_header_size - info_header_size
	else:
		prints("Header row size has gone wrong")
	self.columns = header_size
	prints("Setting grid to", header_size, "columns.")


func create_task_row_cells(task_data : TaskData) -> void: #task "physical" nodes, display side
	blank_counter = 0
	var info = "Info"
	
	var task_name : String = task_data.name #1
	create_text_cell(task_name)
#	prints("1 is go")
	
	var section : int = task_data.section #2
	prints("section dropdown:", section_dropdown_items)
	create_dropdown_cell(section_dropdown_items, section)
#	prints("2 is go")
	
	var group : String = task_data.group #3
	create_text_cell(group)
#	prints("3 is go")
	
	var assignment : String = ""  #4
	if task_data.assigned_user:
		assignment = task_data.assigned_user[0]
	else:
		assignment = "No Assignment"
	create_text_cell(assignment, info)
#	prints("4 is go")
	
	var description : String = task_data.description  #5
	create_multi_line_cell(description, info)
#	prints("5 is go")
	
	var time_of_day : int #6
	if task_data.time_of_day is int:
		time_of_day = task_data.time_of_day 
	else:
		time_of_day = 0
	create_dropdown_cell(time_of_day_dropdown_items, time_of_day, info)
#	prints("6 is go")

	var priority : int #7
	if task_data.priority is int:
		priority = task_data.priority 
	else:
		priority = 0
	create_dropdown_cell(priority_dropdown_items, priority, info)
#	prints("7 is go")
	
	var location : String = task_data.location #8
	if location == "":
		location = "No Location"
	create_text_cell(location, info)
#	prints("8 is go")
	
	var cycle_time_unit : String = task_data.time_unit #9
	if cycle_time_unit == "":
		cycle_time_unit = "No Unit"
	create_text_cell(cycle_time_unit, info)
#	prints("9 is go")
	
	var time_units_per_cycle : int = task_data.units_per_cycle #10
	create_number_cell(time_units_per_cycle, info)
#	prints("10 is go")
	
	var time_units_added_when_skipped : int = task_data.units_added_when_skipped #11
	create_number_cell(time_units_added_when_skipped, info)
#	prints("11 is go")
	
	var last_completed : String = task_data.last_completed #12
	if last_completed == "":
		last_completed = "Never"
	create_text_cell(last_completed, info)
#	prints("12 is go")
	
	var checkbox = "Checkbox"
	pass #checkboxes



func add_cell_to_groups(cell_parameter, column_group_parameter) -> void:
	if row_group != "":
		cell_parameter.add_to_group(row_group)
	if column_group_parameter != "":
		cell_parameter.add_to_group(column_group_parameter)


func create_text_cell(text : String, column_group : String = "") -> void:
	var cell : LineEdit = text_cell.instantiate()
	self.add_child(cell)
	cell.text = text
	add_cell_to_groups(cell, column_group)


func blank_slug() -> void:
	blank_counter += 1
	var slug_imprint = "BLANK " + str(blank_counter)
	create_text_cell(slug_imprint, "Info")


func create_dropdown_cell(dropdown_items : Array, selected_item : int, column_group : String = "") -> void:
	var cell : OptionButton = dropdown_cell.instantiate()
	self.add_child(cell)
	for item in dropdown_items:
		cell.add_item(item)
	cell.selected = selected_item
	add_cell_to_groups(cell, column_group) 


func create_multi_line_cell(multi_text: String, column_group : String = "") -> void:
	var cell : TextEdit = multi_line_cell.instantiate()
	self.add_child(cell)
	cell.text = multi_text
	add_cell_to_groups(cell, column_group) 


func create_number_cell(number : int, column_group : String = "") -> void:
	var cell : SpinBox = number_cell.instantiate()
	self.add_child(cell)
	cell.value = number
	add_cell_to_groups(cell, column_group)


func create_checkbox_cell() -> void:
	pass
