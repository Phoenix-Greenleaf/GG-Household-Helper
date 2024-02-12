extends GridContainer

@onready var add_task_button: Button = %AddTaskButton
@onready var task_title_line_edit: LineEdit = %TaskTitleLineEdit
@onready var task_group_line_edit: LineEdit = %TaskGroupLineEdit
@onready var existing_groups_option_button: OptionButton = %ExistingGroupsOption
@onready var task_add_assigned_user_label: Label = %TaskAddAssignedUserLabel
@onready var task_add_assigned_user_option_button: OptionButton = %TaskAddAssignedUserOptionButton
@onready var task_add_schedule_start_label: Label = %TaskAddScheduleStartLabel
@onready var task_add_schedule_start_spin_box: SpinBox = %TaskAddScheduleStartSpinBox
@onready var task_add_units_per_cycle_label: Label = %TaskAddUnitsPerCycleLabel
@onready var task_add_units_per_cycle_spin_box: SpinBox = %TaskAddUnitsPerCycleSpinBox
@onready var accept_new_task_button: Button = %AcceptNewTaskButton
@onready var v_separator_6: VSeparator = %VSeparator6
@onready var v_separator_5: VSeparator = %VSeparator5
@onready var v_separator_4: VSeparator = %VSeparator4
@onready var v_separator_3: VSeparator = %VSeparator3
@onready var v_separator_2: VSeparator = %VSeparator2
@onready var v_separator: VSeparator = %VSeparator

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
var task_checkbox_clear_button_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/task_checkbox_clear_button_cell.tscn")
var delete_task_cell = preload("res://gui/task_tracking/task_spreadsheet/cells/delete_task_data_cell.tscn")

var row_group: String = ""
var blank_counter: int = 0
var section_dropdown_items: Array
var time_of_day_dropdown_items: Array
var priority_dropdown_items: Array
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



func _ready() -> void:
	DataGlobal.load_settings_task_tracking()
	ready_connections()
	close_new_task_panel()
	get_dropdown_items_from_global()
	var task_settings = DataGlobal.active_settings_task_tracking
	if task_settings.enable_auto_load_default_data:
		var default_data_info = task_settings.default_data
		DataGlobal.load_data_task_set(default_data_info[0], default_data_info[1])
	if !DataGlobal.active_data_task_tracking:
		prints("No Tasksheet found for TaskGrid....")
		return
	var title = DataGlobal.active_data_task_tracking.task_set_title
	var year = DataGlobal.active_data_task_tracking.task_set_year
	prints("TaskGrid found:", title, ":", year)
	load_existing_data()
	DataGlobal.task_editor_update_user_profile_dropdown_items()
	update_task_add_options()
	editing_lock_button.button_pressed = true
	editing_lock_button.button_pressed = false


func ready_connections() -> void:
	SignalBus._on_task_set_data_active_data_switched.connect(update_grid_spreadsheet)
	SignalBus._on_task_editor_mode_changed.connect(toggle_info_checkbox_modes)
	SignalBus._on_task_editor_section_changed.connect(section_or_month_changed)
	SignalBus._on_task_editor_month_changed.connect(section_or_month_changed)
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	SignalBus._on_task_editor_task_delete_button_primed_and_pressed.connect(delete_task_row)
	SignalBus._on_task_editor_grid_reload_pressed.connect(reload_grid)


func set_time_unit() -> void:
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			header_cell_array[9] = "Months/Cycle"
			task_add_units_per_cycle_label.text = "Months per Cycle:"
		DataGlobal.Section.WEEKLY:
			header_cell_array[9] = "Weeks/Cycle"
			task_add_units_per_cycle_label.text = "Weeks per Cycle:"
		DataGlobal.Section.DAILY:
			header_cell_array[9] = "Days/Cycle"
			task_add_units_per_cycle_label.text = "Days per Cycle:"


func toggle_info_checkbox_modes() -> void:
	if DataGlobal.task_tracking_current_toggled_editor_mode == DataGlobal.task_tracking_editor_modes["Info"]:
		get_tree().set_group("Info", "visible", true)
		get_tree().set_group("Checkbox", "visible", false)
	elif DataGlobal.task_tracking_current_toggled_editor_mode == DataGlobal.task_tracking_editor_modes["Checkbox"]:
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


func reload_grid() -> void:
	clear_grid_children()
	load_existing_data()


func section_or_month_changed() -> void:
	reload_grid()
	update_task_add_options()


func update_grid_spreadsheet() -> void:
	var title = DataGlobal.active_data_task_tracking.task_set_title
	var year = DataGlobal.active_data_task_tracking.task_set_year
	prints("TaskGrid updated:", title, ":", year)
	section_or_month_changed()


func update_task_add_options() -> void:
	update_existing_groups_option_button_items()
	update_task_add_assigned_users()


func update_task_add_assigned_users() -> void:
	task_add_assigned_user_option_button.clear()
	DataGlobal.task_editor_update_user_profile_dropdown_items()
	for item in DataGlobal.task_tracking_user_profiles_dropdown_items:
		task_add_assigned_user_option_button.add_item(item[0])


func clear_grid_children() -> void:
	var children = self.get_children()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()


func open_new_task_panel() -> void:
	add_task_button.text = "Cancel"
	task_title_line_edit.visible = true
	task_group_line_edit.visible = true
	existing_groups_option_button.visible = true
	accept_new_task_button.visible = true
	task_add_assigned_user_label.visible = true
	task_add_assigned_user_option_button.visible = true
	task_add_schedule_start_label.visible = true
	task_add_schedule_start_spin_box.visible = true
	task_add_units_per_cycle_label.visible = true
	task_add_units_per_cycle_spin_box.visible = true
	v_separator_6.visible = true
	v_separator_5.visible = true
	v_separator_4.visible = true
	v_separator_3.visible = true
	v_separator_2.visible = true
	v_separator.visible = true


func close_new_task_panel() -> void:
	add_task_button.text = "Add Task"
	task_title_line_edit.visible = false
	task_group_line_edit.visible = false
	existing_groups_option_button.visible = false
	accept_new_task_button.visible = false
	task_add_assigned_user_label.visible = false
	task_add_assigned_user_option_button.visible = false
	task_add_schedule_start_label.visible = false
	task_add_schedule_start_spin_box.visible = false
	task_add_units_per_cycle_label.visible = false
	task_add_units_per_cycle_spin_box.visible = false
	v_separator_6.visible = false
	v_separator_5.visible = false
	v_separator_4.visible = false
	v_separator_3.visible = false
	v_separator_2.visible = false
	v_separator.visible = false


func create_new_task_data() -> void: #task code, the data side
	var new_task = TaskData.new()
	var new_task_title = task_title_line_edit.text
	new_task.name = new_task_title
	var new_task_year = DataGlobal.active_data_task_tracking.task_set_year
	new_task.task_year = new_task_year
	var new_task_section := DataGlobal.task_tracking_current_toggled_section
	new_task.section = new_task_section
	new_task.previous_section = new_task_section
	var new_task_assigned_user: Array = DataGlobal.task_tracking_user_profiles_dropdown_items[task_add_assigned_user_option_button.selected]
	new_task.assigned_user = new_task_assigned_user
	var new_task_schedule_start: float = task_add_schedule_start_spin_box.value
	new_task.scheduling_start = new_task_schedule_start
	var new_task_units_per_cycle: float = task_add_units_per_cycle_spin_box.value
	new_task.units_per_cycle = new_task_units_per_cycle
	var new_task_group = "None"
	if task_group_line_edit.text:
		new_task_group = task_group_line_edit.text
	row_group = new_task_group
	new_task.group = new_task_group
	new_task.offbrand_init()
	match new_task_section:
		DataGlobal.Section.YEARLY:
			DataGlobal.active_data_task_tracking.spreadsheet_year_data.append(new_task)
		DataGlobal.Section.MONTHLY:
			DataGlobal.active_data_task_tracking.spreadsheet_month_data.append(new_task)
		DataGlobal.Section.WEEKLY:
			DataGlobal.active_data_task_tracking.spreadsheet_week_data.append(new_task)
		DataGlobal.Section.DAILY:
			DataGlobal.active_data_task_tracking.spreadsheet_day_data.append(new_task)
	DataGlobal.task_editor_scan_task_for_group(new_task)
	update_existing_groups_option_button_items()
	process_task(new_task)


func process_task(target_task) -> void:
	current_task = target_task
	create_task_row_cells()


func new_task_field_reset() -> void:
	task_title_line_edit.clear()
	task_group_line_edit.clear()
	existing_groups_option_button.select(0)
	task_add_assigned_user_option_button.select(0)
	task_add_schedule_start_spin_box.value = 0
	task_add_units_per_cycle_spin_box.value = 0


func load_existing_data() -> void:
	if not DataGlobal.active_data_task_tracking:
		prints("No existing data to load")
		return
	set_time_unit()
	create_header_row()
	update_existing_groups_option_button_items()
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY:
			for data_iteration in DataGlobal.active_data_task_tracking.spreadsheet_year_data:
				process_task(data_iteration)
		DataGlobal.Section.MONTHLY:
			for data_iteration in DataGlobal.active_data_task_tracking.spreadsheet_month_data:
				process_task(data_iteration)
		DataGlobal.Section.WEEKLY:
			for data_iteration in DataGlobal.active_data_task_tracking.spreadsheet_week_data:
				process_task(data_iteration)
		DataGlobal.Section.DAILY:
			for data_iteration in DataGlobal.active_data_task_tracking.spreadsheet_day_data:
				process_task(data_iteration)
	toggle_info_checkbox_modes()

func update_existing_groups_option_button_items() -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	DataGlobal.task_editor_update_task_group_dropdown_items()
	for item in DataGlobal.task_tracking_task_group_dropdown_items:
		existing_groups_option_button.add_item(item)


func create_header_row() -> void:
	var header_size = header_cell_array.size()
	for iteration in header_size:
		if iteration < last_main_cell_position:
			create_header_cell(header_cell_array[iteration])
		else:
			create_header_cell(header_cell_array[iteration], "Info")
	var checkbox = "Checkbox"
	var current_section = DataGlobal.task_tracking_current_toggled_section
	var current_month = DataGlobal.Month.find_key(DataGlobal.task_tracking_current_toggled_month).capitalize()
	var current_year = DataGlobal.active_data_task_tracking.task_set_year
	match current_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			for month in DataGlobal.month_strings:
				if month == "All":
					continue
				create_header_cell(month, checkbox)
			create_header_cell("Reset Task Checkboxes", "Checkbox")
		DataGlobal.Section.WEEKLY:
			create_checkbox_header("Week", 5)
			create_header_cell("Reset " + current_month + " Checkboxes", "Checkbox")
		DataGlobal.Section.DAILY:
			var days = DataGlobal.days_in_month_finder(current_month, current_year)
			create_checkbox_header("Day", days)
			create_header_cell("Reset " + current_month + " Checkboxes", "Checkbox")
	header_editing_prevention()
	full_header_size = self.get_child_count()
	info_header_size = get_tree().get_nodes_in_group("Info").size()
	checkbox_header_size = get_tree().get_nodes_in_group("Checkbox").size()


func header_editing_prevention() -> void:
	var header_nodes: Array[Node] = self.get_children()
	for child in header_nodes:
		child.mouse_filter = 2


func create_checkbox_header(header_string: String, header_length: int) -> void:
	for number in header_length:
		var header_number = " " + str(number + 1)
		create_header_cell(header_string + header_number, "Checkbox")


func set_grid_columns() -> void:
	if not DataGlobal.active_data_task_tracking:
		prints("Columns not set")
		return
	var header_size: int = 0
	if DataGlobal.task_tracking_current_toggled_editor_mode == DataGlobal.task_tracking_editor_modes["Info"]:
		header_size = full_header_size - checkbox_header_size
	elif DataGlobal.task_tracking_current_toggled_editor_mode == DataGlobal.task_tracking_editor_modes["Checkbox"]:
		header_size = full_header_size - info_header_size
	else:
		prints("Header row size has gone wrong")
	self.columns = header_size



func create_task_row_cells() -> void: #task "physical" nodes, display side
	create_text_cell(current_task.name, "Task Name")  #1
	create_dropdown_cell(section_dropdown_items, current_task.section, "Section") #2
	create_dropdown_cell(DataGlobal.task_tracking_task_group_dropdown_items, current_task.group, "Group") #3
	var info = "Info"
	create_dropdown_cell(DataGlobal.task_tracking_user_profiles_dropdown_items, current_task.assigned_user, "Assigned User", info) #4
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
				var checkbox_data: TaskCheckboxData = current_task.month_checkbox_dictionary[month_iteration][0]
				var checkbox_state: DataGlobal.Checkbox = checkbox_data.checkbox_status
				var checkbox_user: Array = checkbox_data.assigned_user
				create_checkbox_cell(checkbox_state, checkbox_user, checkbox_position, checkbox)
				checkbox_position += 1
			create_checkbox_clear_cell(checkbox)
		DataGlobal.Section.WEEKLY, DataGlobal.Section.DAILY:
			var current_month = DataGlobal.task_tracking_current_toggled_month
			var month_key = DataGlobal.Month.find_key(current_month).capitalize()
			var current_data: Array = current_task.month_checkbox_dictionary[month_key]
			for checkbox_data in current_data:
				var checkbox_state: DataGlobal.Checkbox = checkbox_data.checkbox_status
				var checkbox_user: Array = checkbox_data.assigned_user
				create_checkbox_cell(checkbox_state, checkbox_user, checkbox_position, checkbox)
				checkbox_position += 1
			create_checkbox_clear_cell(checkbox)


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
	cell.saved_task = current_task
	cell.saved_type = current_type
	cell.dropdown_items = dropdown_items
	cell.update_dropdown_items(selected_item)
	cell.connect_type_updates()
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


func create_checkbox_clear_cell(column_group: String = "") -> void:
	var cell: Button = task_checkbox_clear_button_cell.instantiate()
	self.add_child(cell)
	cell.saved_task = current_task
	cell.prep_button()
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
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY:
			DataGlobal.active_data_task_tracking.spreadsheet_year_data.erase(target_task)
		DataGlobal.Section.MONTHLY:
			DataGlobal.active_data_task_tracking.spreadsheet_month_data.erase(target_task)
		DataGlobal.Section.WEEKLY:
			DataGlobal.active_data_task_tracking.spreadsheet_week_data.erase(target_task)
		DataGlobal.Section.DAILY:
			DataGlobal.active_data_task_tracking.spreadsheet_day_data.erase(target_task)
	update_existing_groups_option_button_items()
	SignalBus._on_task_set_data_modified.emit()


func grid_editable(editable_bool: bool) -> void:
	var current_grid_children = self.get_children()
	for item_iteration in current_grid_children:
		if "editable" in item_iteration:
			item_iteration.editable = editable_bool
		if item_iteration is Button:
			item_iteration.disabled = not editable_bool


func selected_checkbox(target) -> void:
	var current_profile = DataGlobal.task_tracking_current_checkbox_profile
	var current_state = DataGlobal.task_tracking_current_checkbox_state
	var focus_profile = target.saved_profile
	var focus_state = target.saved_state
	match DataGlobal.task_tracking_current_toggled_checkbox_mode:
		DataGlobal.CheckboxToggle.APPLY:
			if ((current_profile == focus_profile) and (current_state == focus_state)):
				return
			target.saved_profile = current_profile
			target.saved_state = current_state
			target.update_checkbox()
			target.update_active_data()
		DataGlobal.CheckboxToggle.INSPECT:
			DataGlobal.task_tracking_current_checkbox_profile = focus_profile
			DataGlobal.task_tracking_current_checkbox_state = focus_state
			checkbox_selection_popup.default_profile_status_limiter(focus_profile)
			SignalBus._on_task_editor_checkbox_selection_changed.emit()
			checkbox_selection_popup.update_edit_profile_menu()


func _on_focus_changed(control_node:Control) -> void:
	if control_node == null:
		return
	current_focus = control_node
	if "CheckboxCell" in control_node.name:
		DataGlobal.task_tracking_focus_checkbox_profile = control_node.saved_profile
		DataGlobal.task_tracking_focus_checkbox_state = control_node.saved_state
		selected_checkbox(control_node)


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


func _on_add_task_button_pressed() -> void:
	match add_task_button.text:
		"Add Task":
			open_new_task_panel()
		"Cancel":
			close_new_task_panel()


func _on_sort_tasks_button_pressed() -> void:
	pass


func _on_accept_new_task_button_pressed() -> void:
	if not task_title_line_edit.text:
		DataGlobal.button_based_message(accept_new_task_button, "Title Needed!")
		return
	if self.get_child_count() == 0:
		create_header_row()
	create_new_task_data()
	close_new_task_panel()
	new_task_field_reset()
	toggle_info_checkbox_modes()
	SignalBus._on_task_set_data_modified.emit()
	update_existing_groups_option_button_items()


func _on_existing_groups_option_item_selected(index: int) -> void:
	var group_text: String = existing_groups_option_button.get_item_text(index)
	task_group_line_edit.text = group_text
