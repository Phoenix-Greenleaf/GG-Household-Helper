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
var header_size : int
var blank_counter : int = 0



func _ready() -> void:
	ready_connections()
	close_new_task_panel()
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


func test_spreadsheet_initialization() -> void:
	pass


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


func _on_sort_tasks_button_pressed() -> void:
	pass # Replace with function body.


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
	


func create_existing_groups_option_button_items(group) -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	for item in group:
		existing_groups_option_button.add_item(item)


func _on_existing_groups_option_item_selected(index: int) -> void:
	var group_text : String = existing_groups_option_button.get_item_text(index)
#	task_group_line_edit.set_text(group_text)
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
	prints("Child Check: Self", self.get_child_count())
	prints("Child Check: Other", get_child_count())

	var checkbox = "Checkbox"
	pass #checkboxes

	header_size = self.get_child_count()
	set_grid_columns()


func set_grid_columns() -> void:
	self.columns = header_size #change with info/cb toggle
	prints("Setting grid to", header_size, "columns.")


func create_task_row_cells(task_data : TaskData) -> void: #task "physical" nodes, display side
	blank_counter = 0
	var info = "Info"
	
	var task_name : String = task_data.name #1
	create_text_cell(task_name)
	prints("1 is go")
	
	var section = task_data.section #2
	create_dropdown_cell()
	prints("2 is go")
	
	var group : String = task_data.group #3
	create_text_cell(group)
	prints("3 is go")
	
	var assignment : String = ""  #4
	if task_data.assigned_user:
		assignment = task_data.assigned_user[0]
	else:
		assignment = "No Assignment"
	create_text_cell(assignment, info)
	prints("4 is go")
	
	var description = task_data  #5
	create_multi_line_cell()
	prints("5 is go")
	
	var time_of_day = task_data.time_of_day #6
	create_dropdown_cell()
	prints("6 is go")
	
	var priority = task_data.priority #7
	create_dropdown_cell()
	prints("7 is go")
	
	var location : String = task_data.location #8
	if location == "":
		location = "No Location"
	create_text_cell(location, info)
	prints("8 is go")
	
	var cycle_time_unit : String = task_data.time_unit #9
	if cycle_time_unit == "":
		cycle_time_unit = "No Unit"
	create_text_cell(cycle_time_unit, info)
	prints("9 is go")
	
	var time_units_per_cycle = task_data.units_per_cycle #10
	create_number_cell(time_units_per_cycle, info)
	prints("10 is go")
	
	var time_units_added_when_skipped = task_data.units_added_when_skipped #11
	create_number_cell(time_units_added_when_skipped, info)
	prints("11 is go")
	
	var last_completed : String = task_data.last_completed #12
	if last_completed == "":
		last_completed = "Never"
	create_text_cell(last_completed, info)
	prints("12 is go")
	
	var checkbox = "Checkbox"
	pass #checkboxes



func create_text_cell(text : String, column_group : String = "") -> void:
	var cell = text_cell.instantiate()
	self.add_child(cell)
	cell.text = text
	
	if row_group != "":
		cell.add_to_group(row_group)
	if column_group != "":
		cell.add_to_group(column_group)
	prints("Text", text)


func blank_slug() -> void:
	blank_counter += 1
	var slug_imprint = "BLANK " + str(blank_counter)
	create_text_cell(slug_imprint, "Info")


func create_dropdown_cell() -> void:
	print("Drowpdown")
	blank_slug()


func create_multi_line_cell() -> void: #only description uses it
	print("Multiline")
	blank_slug() 


func create_number_cell(number : int, column_group : String = "") -> void:
	print("Number")
	blank_slug()


func create_checkbox_cell() -> void:
	pass

