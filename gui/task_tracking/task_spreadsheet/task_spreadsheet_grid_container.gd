extends GridContainer

@export var data_for_spreadsheet: TaskSpreadsheetData

@onready var add_task_button: Button = %AddTaskButton
@onready var task_title_line_edit: LineEdit = %TaskTitleLineEdit
@onready var task_group_line_edit: LineEdit = %TaskGroupLineEdit
@onready var existing_groups_option_button: OptionButton = %ExistingGroupsOption
@onready var accept_new_task_button: Button = %AcceptNewTaskButton
@onready var checkbox_selection_popup: PanelContainer = %CheckboxSelectionPopup
@onready var multi_text_popup_center: CenterContainer = %MultiTextPopupCenter
@onready var task_label: Label = %TaskLabel
@onready var text_edit: TextEdit = %TextEdit
@onready var editing_lock_button: CheckButton = %EditingLockButton
@onready var checkbox_apply_toggle: Button = %CheckboxApplyToggle
@onready var checkbox_inspect_toggle: Button = %CheckboxInspectToggle


var checkbox_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/checkbox_cell.tscn")
var dropdown_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/dropdown_cell.tscn")
var multi_line_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/multi_line_cell.tscn")
var number_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/number_cell.tscn")
var text_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/text_cell.tscn")
var delete_task_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/delete_task_data_cell.tscn")

var row_group: String = ""
var blank_counter: int = 0
var section_dropdown_items: Array
var time_of_day_dropdown_items: Array
var priority_dropdown_items: Array
var user_profiles_dropdown_items: Array
var full_header_size: int 
var info_header_size: int
var checkbox_header_size: int
var current_task: TaskData
var current_focus: Control
var current_text_edit_cell: MultiLineCell

var last_main_cell_position = 3
var header_cell_array: Array = [
	"Task", #1
	"Section", #2
	"Group", #3
	"Assignment", #4
	"Description", #5
	"Time Of Day", #6
	"Priority", #7
	"Location", #8
	"Schedule Start", #9
	"Units/Cycle", #10
	"Delete Task", #11
]
#var month_dictionary: Dictionary



func _ready() -> void:
	ready_connections()
	close_new_task_panel()
	get_dropdown_items_from_global()
	SignalBus.remote_task_settings_reload.emit()
	if DataGlobal.settings_file.task_enable_auto_load_default_data:
		DataGlobal.current_tasksheet_data = DataGlobal.settings_file.task_default_data
		data_for_spreadsheet = DataGlobal.settings_file.task_default_data
	if !data_for_spreadsheet:
		print("No Tasksheet found for TaskGrid....")
		return
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	prints("TaskGrid found:", title, ":", year)
	update_user_profile_dropdown_items()
#	ready_month_dictionary()
	load_existing_data()
	existing_groups_option_section_picker()
	editing_lock_button.button_pressed = true
	editing_lock_button.button_pressed = false


func ready_connections() -> void:
	if DataGlobal.current_tasksheet_data:
		data_for_spreadsheet = DataGlobal.current_tasksheet_data
	SignalBus._on_current_tasksheet_data_changed.connect(update_grid_spreadsheet)
	SignalBus._on_editor_mode_changed.connect(toggle_info_checkbox_modes)
	SignalBus._on_editor_section_changed.connect(section_or_month_changed)
	SignalBus._on_editor_month_changed.connect(section_or_month_changed)
	SignalBus.reload_profiles_triggered.connect(update_user_profile_dropdown_items)
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	SignalBus._on_task_delete_button_primed_and_pressed.connect(delete_task_row)


#func ready_month_dictionary() -> void:
#	for constant in DataGlobal.Month.keys():
#		if constant == "NONE":
#			month_dictionary["All"] = []
#		month_dictionary[constant.capitalize()] = []


func toggle_info_checkbox_modes() -> void:
	if DataGlobal.current_toggled_editor_mode == DataGlobal.editor_modes["Info"]:
		get_tree().set_group("Info", "visible", true)
		get_tree().set_group("Checkbox", "visible", false)
	elif DataGlobal.current_toggled_editor_mode == DataGlobal.editor_modes["Checkbox"]:
		get_tree().set_group("Checkbox", "visible", true)
		get_tree().set_group("Info", "visible", false)
	else:
		prints("Mode toggle has gone wrong")
	set_grid_columns()


func get_dropdown_items_from_global() -> void:
	for item in DataGlobal.Section.keys():
		section_dropdown_items.append(item.capitalize())
	for item in DataGlobal.TimeOfDay.keys():
		time_of_day_dropdown_items.append(item.capitalize())
	for item in DataGlobal.Priority.keys():
		priority_dropdown_items.append(item.capitalize())


func update_grid_spreadsheet() -> void:
	data_for_spreadsheet = DataGlobal.current_tasksheet_data
	var title = data_for_spreadsheet.spreadsheet_title
	var year = data_for_spreadsheet.spreadsheet_year
	prints("TaskGrid updated:", title, ":", year)
	clear_grid_children()
	load_existing_data()
	existing_groups_option_section_picker()


func section_or_month_changed() -> void:
	clear_grid_children()
	load_existing_data()
	existing_groups_option_section_picker()



func existing_groups_option_section_picker() -> void:
	if not data_for_spreadsheet:
		prints("No existing groups to load")
		return
	var current_section = DataGlobal.current_toggled_section
	match current_section:
		DataGlobal.Section.YEARLY:
			var yearly_section = data_for_spreadsheet.spreadsheet_year_groups
			create_existing_groups_option_button_items(yearly_section)
		DataGlobal.Section.MONTHLY:
			var monthly_section = data_for_spreadsheet.spreadsheet_month_groups
			create_existing_groups_option_button_items(monthly_section)
		DataGlobal.Section.WEEKLY:
			var weekly_section = data_for_spreadsheet.spreadsheet_week_groups
			create_existing_groups_option_button_items(weekly_section)
		DataGlobal.Section.DAILY:
			var daily_section = data_for_spreadsheet.spreadsheet_day_groups
			create_existing_groups_option_button_items(daily_section)


func clear_grid_children() -> void:
	var children = self.get_children()
	var count = self.get_child_count()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()
	prints(count, "children in line for freedom")


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
			var current_section_group = data_for_spreadsheet.spreadsheet_year_groups
			data_for_spreadsheet.spreadsheet_year_data.append(new_task)
			create_task_group(new_task_group, current_section_group)
			create_existing_groups_option_button_items(current_section_group)
		DataGlobal.Section.MONTHLY:
			var current_section_group = data_for_spreadsheet.spreadsheet_month_groups
			data_for_spreadsheet.spreadsheet_month_data.append(new_task)
			create_task_group(new_task_group, current_section_group)
			create_existing_groups_option_button_items(current_section_group)
		DataGlobal.Section.WEEKLY:
			var current_section_group = data_for_spreadsheet.spreadsheet_week_groups
			data_for_spreadsheet.spreadsheet_week_data.append(new_task)
			create_task_group(new_task_group, current_section_group)
			create_existing_groups_option_button_items(current_section_group)
		DataGlobal.Section.DAILY:
			var current_section_group = data_for_spreadsheet.spreadsheet_day_groups
			data_for_spreadsheet.spreadsheet_day_data.append(new_task)
			create_task_group(new_task_group, current_section_group)
			create_existing_groups_option_button_items(current_section_group)
	process_task(new_task)


func process_task(target_task) -> void:
	current_task = target_task
	create_task_row_cells()


func new_task_field_reset() -> void:
	task_title_line_edit.clear()
	task_group_line_edit.clear()
	existing_groups_option_button.select(0)


func create_task_group(task_group: String, section_groups: Array) -> void:
			if section_groups.has(task_group):
				prints("Task group", task_group, "already exists.")
			else:
				section_groups.append(task_group)
				section_groups.sort()
				prints("Created new task group:", task_group)


func load_existing_data() -> void:
	if not data_for_spreadsheet:
		prints("No existing data to load")
		return
	create_header_row()
	match DataGlobal.current_toggled_section:
		DataGlobal.Section.YEARLY:
			for data_iteration in data_for_spreadsheet.spreadsheet_year_data:
				process_task(data_iteration)
		DataGlobal.Section.MONTHLY:
			for data_iteration in data_for_spreadsheet.spreadsheet_month_data:
				process_task(data_iteration)
		DataGlobal.Section.WEEKLY:
			for data_iteration in data_for_spreadsheet.spreadsheet_week_data:
				process_task(data_iteration)
		DataGlobal.Section.DAILY:
			for data_iteration in data_for_spreadsheet.spreadsheet_day_data:
				process_task(data_iteration)
	toggle_info_checkbox_modes()


func _on_sort_tasks_button_pressed() -> void:
	prints("Placeholder")
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
	SignalBus.trigger_save_warning.emit()
	prints(self, "func _on_accept_new_task_button_pressed emits 'trigger_save_warning'")


func create_existing_groups_option_button_items(group) -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	for item in group:
		existing_groups_option_button.add_item(item)


func _on_existing_groups_option_item_selected(index: int) -> void:
	var group_text: String = existing_groups_option_button.get_item_text(index)
	task_group_line_edit.text = group_text


func create_header_row() -> void:
	var header_size = header_cell_array.size()
	for iteration in header_size:
		if iteration < last_main_cell_position:
			create_header_cell(header_cell_array[iteration])
		else:
			create_header_cell(header_cell_array[iteration], "Info")
	var checkbox = "Checkbox"
	var current_section = DataGlobal.current_toggled_section
	var current_month = DataGlobal.Month.find_key(DataGlobal.current_toggled_month).capitalize()
	var current_year = DataGlobal.current_tasksheet_data.spreadsheet_year
	match current_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			for month in DataGlobal.month_strings:
				if month == "All":
					continue
				create_header_cell(month, checkbox)
		DataGlobal.Section.WEEKLY:
			create_checkbox_header("Week", 5)
		DataGlobal.Section.DAILY:
			var days = DataGlobal.days_in_month_finder(current_month, current_year)
			create_checkbox_header("Day", days)
	header_editing_prevention()
	full_header_size = self.get_child_count()
	info_header_size = get_tree().get_nodes_in_group("Info").size()
	checkbox_header_size = get_tree().get_nodes_in_group("Checkbox").size()
	prints("Header Sizes, Full:", full_header_size, " Info:", info_header_size, " Checkbox:", checkbox_header_size)


func header_editing_prevention() -> void:
	var header_nodes: Array[Node] = self.get_children()
	for child in header_nodes:
		child.mouse_filter = 2


func create_checkbox_header(header_string: String, header_length: int) -> void:
	for number in header_length:
		var header_number = " " + str(number + 1)
		create_header_cell(header_string + header_number, "Checkbox")


func set_grid_columns() -> void:
	if not data_for_spreadsheet:
		prints("Columns not set")
		return
	var header_size: int = 0
	if DataGlobal.current_toggled_editor_mode == DataGlobal.editor_modes["Info"]:
		header_size = full_header_size - checkbox_header_size
	elif DataGlobal.current_toggled_editor_mode == DataGlobal.editor_modes["Checkbox"]:
		header_size = full_header_size - info_header_size
	else:
		prints("Header row size has gone wrong")
	self.columns = header_size
	prints("Setting grid to", header_size, "columns.")


func create_task_row_cells() -> void: #task "physical" nodes, display side
	prints(current_task.name)
	create_text_cell(current_task.name, "Task Name")  #1
	create_dropdown_cell(section_dropdown_items, current_task.section, "Section") #2
	create_text_cell(current_task.group, "Group") #3
	var info = "Info"
	create_dropdown_cell(user_profiles_dropdown_items, current_task.assigned_user, "Assigned User", info) #4
	create_multi_line_cell(current_task.description, info) #5
	create_dropdown_cell(time_of_day_dropdown_items, current_task.time_of_day, "Time Of Day", info) #6
	create_dropdown_cell(priority_dropdown_items, current_task.priority, "Priority", info) #7
	create_text_cell(current_task.location, "Location", info) #8
	create_number_cell(current_task.scheduling_start, "Schedule Start", info) #9
	create_number_cell(current_task.units_per_cycle, "Units/Cycle", info) #10
	create_delete_task_cell("Delete Task", info) #11
	var checkbox = "Checkbox"
	var checkbox_position = 1
	match current_task.section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			for month_iteration in current_task.month_checkbox_dictionary:
				if month_iteration == "All":
					continue
				var checkbox_data: CheckboxData = current_task.month_checkbox_dictionary[month_iteration][0]
				var checkbox_state: DataGlobal.Checkbox = checkbox_data.checkbox_status
				var checkbox_user: Array = checkbox_data.assigned_user
				create_checkbox_cell(checkbox_state, checkbox_user, checkbox_position, checkbox)
				checkbox_position += 1
		DataGlobal.Section.WEEKLY, DataGlobal.Section.DAILY:
			var current_month = DataGlobal.current_toggled_month
			var month_key = DataGlobal.Month.find_key(current_month).capitalize()
			prints("Month Key:", month_key, "   Current month:", current_month)
			var current_data: Array = current_task.month_checkbox_dictionary[month_key]
			for checkbox_data in current_data:
				var checkbox_state: DataGlobal.Checkbox = checkbox_data.checkbox_status
				var checkbox_user: Array = checkbox_data.assigned_user
				create_checkbox_cell(checkbox_state, checkbox_user, checkbox_position, checkbox)
				checkbox_position += 1


func add_cell_to_groups(cell_parameter, column_group_parameter) -> void:
	if row_group != "":
		cell_parameter.add_to_group(row_group)
	if column_group_parameter != "":
		cell_parameter.add_to_group(column_group_parameter)


func create_text_cell(text: String, current_type: String, column_group: String = "") -> void:
	var cell: LineEdit = text_cell.instantiate()
	self.add_child(cell)
	cell.text = text
	cell.saved_task = current_task
	cell.saved_type = current_type
	add_cell_to_groups(cell, column_group)


func create_header_cell(text, column_group: String = "") -> void:
	var cell: LineEdit = text_cell.instantiate()
	self.add_child(cell)
	cell.text = text
	add_cell_to_groups(cell, column_group)


func create_dropdown_cell(dropdown_items: Array, selected_item, current_type: String, column_group: String = "") -> void:
	var cell: OptionButton = dropdown_cell.instantiate()
	self.add_child(cell)
	var selection_index: int
	if selected_item is int:
		for item in dropdown_items:
			cell.add_item(item)
		selection_index = selected_item
	else:
		for profile in dropdown_items:
			var profile_name = profile[0]
			if profile_name == "No Profile":
				profile_name = "Not Assigned"
			cell.add_item(profile_name)
		selection_index = dropdown_items.find(selected_item)
		if selected_item == DataGlobal.default_profile:
			selection_index = 0
		if selection_index == -1:
			prints("dropdown find error")
			prints("Selected item:", selected_item)
			prints("dropdown items:", dropdown_items)
			prints("")
	cell.selected = selection_index
	cell.saved_task = current_task
	cell.saved_type = current_type
	add_cell_to_groups(cell, column_group) 


func create_multi_line_cell(multi_text_parameter: String, column_group: String = "") -> void:
	var cell: Button = multi_line_cell.instantiate()
	self.add_child(cell)
	cell.saved_task = current_task
	cell.initialize_data(multi_text_parameter)
	cell.pressed.connect(_on_description_button_pressed.bind(cell))
	add_cell_to_groups(cell, column_group) 


func create_number_cell(number: int, current_type: String, column_group: String = "") -> void:
	var cell: SpinBox = number_cell.instantiate()
	self.add_child(cell)
	cell.value = number
	cell.saved_task = current_task
	cell.saved_type = current_type
	cell.connect_spinbox_update()
	add_cell_to_groups(cell, column_group)


func create_checkbox_cell(state: DataGlobal.Checkbox, user_profile: Array, cell_position: int, column_group: String = "") -> void:
	var cell: PanelContainer = checkbox_cell.instantiate()
	self.add_child(cell)
	cell.saved_position = cell_position
	cell.saved_task = current_task
	cell.saved_profile = user_profile 
	cell.saved_state = state
	cell.update_checkbox()
	add_cell_to_groups(cell, column_group)


func create_delete_task_cell(current_type: String, column_group: String = "") -> void:
	var cell: Button = delete_task_cell.instantiate()
	self.add_child(cell)
	cell.saved_type = current_type
	cell.saved_task = current_task
	cell.prep_delete_button()
	add_cell_to_groups(cell, column_group)


func delete_task_row(target_task: TaskData) -> void:
	var current_grid_children = self.get_children()
	for current_child in current_grid_children:
		if current_child.saved_task == target_task:
			self.remove_child(current_child)
			current_child.queue_free()
	match DataGlobal.current_toggled_section:
		DataGlobal.Section.YEARLY:
			DataGlobal.current_tasksheet_data.spreadsheet_year_data.erase(target_task)
		DataGlobal.Section.MONTHLY:
			DataGlobal.current_tasksheet_data.spreadsheet_month_data.erase(target_task)
		DataGlobal.Section.WEEKLY:
			DataGlobal.current_tasksheet_data.spreadsheet_week_data.erase(target_task)
		DataGlobal.Section.DAILY:
			DataGlobal.current_tasksheet_data.spreadsheet_day_data.erase(target_task)
	SignalBus.trigger_save_warning.emit()
	prints(self, "func delete_task_row emits 'trigger_save_warning'")


func _on_focus_changed(control_node:Control) -> void:
	if control_node == null:
		return
	current_focus = control_node
	print()
	prints("Focused", control_node.name)
	if "CheckboxCell" in control_node.name:
		prints("Task:", control_node.saved_task.name)
		prints("Position:", control_node.saved_position)
		DataGlobal.focus_checkbox_profile = control_node.saved_profile
		DataGlobal.focus_checkbox_state = control_node.saved_state
		selected_checkbox(control_node)
	if (
		"TextCell" in control_node.name
		or "MultiLineCell"in control_node.name
		or "DropdownCell"in control_node.name
		or "NumberCell" in control_node.name
		):
		prints("Task:", control_node.saved_task.name)


func selected_checkbox(target) -> void:
	var current_profile = DataGlobal.current_checkbox_profile
	var current_state = DataGlobal.current_checkbox_state
	var focus_profile = target.saved_profile
	var focus_state = target.saved_state
	match DataGlobal.current_toggled_checkbox_mode:
		DataGlobal.CheckboxToggle.APPLY:
			if ((current_profile == focus_profile) and (current_state == focus_state)):
				prints("Checkbox already applied!")
				return
			target.saved_profile = current_profile
			target.saved_state = current_state
			prints("selected checkbox check")
			target.update_checkbox()
			target.update_active_data()
		DataGlobal.CheckboxToggle.INSPECT:
			DataGlobal.current_checkbox_profile = focus_profile
			DataGlobal.current_checkbox_state = focus_state
			checkbox_selection_popup.default_profile_status_limiter(focus_profile)
			SignalBus.update_checkbox_button.emit()
			checkbox_selection_popup.update_edit_profile_menu()


func return_data_to_sender(data, return_address) -> void:
	prints("Return:", data)
	prints("Sender:", return_address)
	return_address = data


func update_user_profile_dropdown_items() -> void:
	prints("Updating user profile dropdown.")
	user_profiles_dropdown_items.clear()
	user_profiles_dropdown_items.append(DataGlobal.default_profile)
	for profile in DataGlobal.current_tasksheet_data.user_profiles:
		user_profiles_dropdown_items.append(profile)
	prints("New Dropdown:")
	print_profiles_dropdown()


func print_profiles_dropdown() -> void:
	for profile in user_profiles_dropdown_items:
		prints(profile[0])


func _on_accept_multi_text_button_pressed() -> void:
	multi_text_popup_center.visible = false
	current_text_edit_cell.update_data(text_edit.text)
	text_edit.clear()


func _on_description_button_pressed(cell_parameter: MultiLineCell) -> void:
	multi_text_popup_center.visible = true
	current_text_edit_cell = cell_parameter
	task_label.text = cell_parameter.saved_task.name
	text_edit.text = cell_parameter.saved_task.description


func _on_editing_lock_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		grid_editable(true)
		editing_lock_button.text = "Editing\nLock Off"
		checkbox_apply_toggle.disabled = false
	if button_pressed:
		grid_editable(false)
		editing_lock_button.text = "Editing\nLock ON!"
		checkbox_apply_toggle.disabled = true
		checkbox_inspect_toggle.button_pressed = true


func grid_editable(editable_bool: bool) -> void:
	var current_grid_children = self.get_children()
	for item_iteration in current_grid_children:
		if "editable" in item_iteration:
			item_iteration.editable = editable_bool
		if item_iteration is Button:
			item_iteration.disabled = not editable_bool
