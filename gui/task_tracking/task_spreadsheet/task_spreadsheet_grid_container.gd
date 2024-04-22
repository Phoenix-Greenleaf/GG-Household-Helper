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
const COLUMN_HEADER = preload("res://gui/task_tracking/task_spreadsheet/column_header.tscn")
const COLUMN_VISIBILITY_CHECKBOX = preload("res://gui/task_tracking/task_spreadsheet/column_visibility_checkbox.tscn")

var row_group: String = ""
var blank_counter: int = 0
var section_dropdown_items: Array
var time_of_day_dropdown_items: Array
var priority_dropdown_items: Array
var full_header_size: int 
var current_header_size: int
var current_task: TaskData
var current_focus: Control
var current_text_edit_cell: MultiLineCell
var sorting_count: int



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
	SignalBus._on_task_editor_column_visibility_toggled.connect(toggle_column_visibility)
	SignalBus._on_task_editor_section_changed.connect(section_or_month_changed)
	SignalBus._on_task_editor_month_changed.connect(section_or_month_changed)
	get_viewport().gui_focus_changed.connect(_on_focus_changed)
	SignalBus._on_task_editor_task_delete_button_primed_and_pressed.connect(delete_task_row)
	SignalBus._on_task_editor_grid_reload_pressed.connect(reload_grid)


func apply_all_column_visibility() -> void:
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	for column_key in column_data:
		var current_column_data: Dictionary = column_data[column_key]
		var column_visibility: bool = current_column_data["Column Visible"]
		toggle_column_visibility(column_key, column_visibility)
	set_grid_columns()


func toggle_column_visibility(column_parameter: String, visible_parameter: bool) -> void:
	get_tree().set_group(column_parameter, "visible", visible_parameter)


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
	var new_task_assigned_user: Array = (
		DataGlobal.task_tracking_user_profiles_dropdown_items[
			task_add_assigned_user_option_button.selected
		]
	)
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
	apply_all_column_visibility()


func update_existing_groups_option_button_items() -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	DataGlobal.task_editor_update_task_group_dropdown_items()
	for item in DataGlobal.task_tracking_task_group_dropdown_items:
		existing_groups_option_button.add_item(item)


func create_header_row() -> void:
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	var column_order: Array = DataGlobal.active_data_task_tracking.column_order
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


			#create_header_cell("Reset Task Checkboxes", "Checkbox")
			#create_header_cell("Reset " + current_month + " Checkboxes", "Checkbox")
			#create_header_cell("Reset " + current_month + " Checkboxes", "Checkbox")


func create_standard_column_header(column_parameter: String) -> void:
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	var current_column_data: Dictionary = column_data[column_parameter]
	var header_text: String = column_parameter
	var column_order: int = current_column_data["Column Order"]
	var ordering_enabled: bool = true
	var sorting_mode: int = current_column_data["Sorting Mode"]
	var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	var column_group: String = column_parameter
	full_header_size += 1
	create_header_cell(header_text, column_order, ordering_enabled, sorting_mode, sorting_enabled, column_group)


func create_time_unit_column_header(column_parameter: String) -> void:
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	var current_column_data: Dictionary = column_data[column_parameter]
	var header_text: String = ""
	var column_order: int = current_column_data["Column Order"]
	var ordering_enabled: bool = true
	var sorting_mode: int = current_column_data["Sorting Mode"]
	var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	var column_group: String = column_parameter
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			header_text = "Months/Cycle"
			task_add_units_per_cycle_label.text = "Months per Cycle:"
		DataGlobal.Section.WEEKLY:
			header_text = "Weeks/Cycle"
			task_add_units_per_cycle_label.text = "Weeks per Cycle:"
		DataGlobal.Section.DAILY:
			header_text = "Days/Cycle"
			task_add_units_per_cycle_label.text = "Days per Cycle:"
	full_header_size += 1
	create_header_cell(header_text, column_order, ordering_enabled, sorting_mode, sorting_enabled, column_group)


func create_checkbox_column_header(column_parameter: String) -> void:
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	var current_column_data: Dictionary = column_data[column_parameter]
	var column_order: int = current_column_data["Column Order"]
	var ordering_enabled: bool = true
	var sorting_mode: int = current_column_data["Sorting Mode"]
	var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	var checkbox := "Checkboxes"
	var header_text: String = checkbox
	var column_group: String = checkbox
	var current_section = DataGlobal.task_tracking_current_toggled_section
	var current_month = DataGlobal.Month.find_key(
		DataGlobal.task_tracking_current_toggled_month
	).capitalize()
	var current_year = DataGlobal.active_data_task_tracking.task_set_year
	var first_column: bool = true
	match current_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			full_header_size += 12
			for month in DataGlobal.month_strings:
				if month == "All":
					continue
				if first_column:
					create_header_cell(month, column_order, ordering_enabled, sorting_mode, false, column_group)
					first_column = false
					continue
				create_header_cell(month, column_order, false, sorting_mode, false, column_group)
		DataGlobal.Section.WEEKLY:
			full_header_size += 5
			header_text = "Week "
			for week_iteration in 5:
				var header_number = str(week_iteration + 1)
				var combined_string: String = header_text + header_number
				if first_column:
					create_header_cell(combined_string, column_order, ordering_enabled, sorting_mode, false, column_group)
					first_column = false
					continue
				create_header_cell(combined_string, column_order, false, sorting_mode, false, column_group)
		DataGlobal.Section.DAILY:
			var number_of_days = DataGlobal.days_in_month_finder(current_month, current_year)
			full_header_size += number_of_days
			header_text = "Day "
			for day_iteration in number_of_days:
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


func set_grid_columns() -> void:
	if not DataGlobal.active_data_task_tracking:
		prints("Columns not set")
		return
	var active_column_count: int = 0
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	for column_key in column_data:
		var current_column_data: Dictionary = column_data[column_key]
		var column_visibility: bool = current_column_data["Column Visible"]
		if not column_visibility:
			continue
		var current_column_count: int = current_column_data["Column Count"]
		active_column_count += current_column_count
	columns = active_column_count


func create_column_visibility_checkboxes() -> void:
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	var column_order: Array = DataGlobal.active_data_task_tracking.column_order
	for column_iteration in column_order:
		var cell: CheckBox = COLUMN_VISIBILITY_CHECKBOX.instantiate() #change for visibility checkbox when made
		SignalBus._on_task_editor_column_visibility_checkbox_created.emit(cell) #change
		cell.set_column_title(column_iteration)
		var current_column: Dictionary = column_data[column_iteration]
		cell.column_visible(current_column["Column Visible"])


func sort_task_array() -> void:

	if not DataGlobal.active_data_task_tracking:
		prints("No existing data to load")
		return
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
			DataGlobal.active_data_task_tracking.spreadsheet_day_data.sort_custom(multi_sort)


func multi_sort(a, b) -> bool:
	return false


	for level_iteration in sorting_count:
		pass


func recursive_sort() -> void:
	pass


	"""
	sorting while task adding
	reference the header row option values
	-sorting mode
	-sorting order
	-recur as needed
	"""


func ascending_sort(a, b) -> bool:
	return false


func descending_sort(a, b) -> bool:
	return false


func create_task_row_cells() -> void: #task "physical" nodes, display side
	var column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data
	var column_order: Array = DataGlobal.active_data_task_tracking.column_order
	for column_array_iteration in column_order:
		var column_iteration: String = column_array_iteration[0]
		var current_column: Dictionary = column_data[column_iteration]
		match column_iteration:
			"Order":
				create_number_cell(
					current_task.row_order,
					"Row Order",
					column_iteration,
				)
			"Task":
				create_text_cell(current_task.name, "Task Name", column_iteration)
			"Section":
				create_dropdown_cell(
					section_dropdown_items,
					current_task.section,
					"Section",
					column_iteration
				)
			"Group":
				create_dropdown_cell(
					DataGlobal.task_tracking_task_group_dropdown_items,
					current_task.group,
					"Group",
					column_iteration,
				)
			"Assignment":
				create_dropdown_cell(
					DataGlobal.task_tracking_user_profiles_dropdown_items,
					current_task.assigned_user,
					"Assigned User",
					column_iteration,
				)
			"Description":
				create_multi_line_cell(current_task.description, column_iteration)
			"Time Of Day":
				create_dropdown_cell(
					time_of_day_dropdown_items,
					current_task.time_of_day,
					"Time Of Day",
					column_iteration
				)
			"Priority":
				create_dropdown_cell(
					priority_dropdown_items,
					current_task.priority,
					"Priority",
					column_iteration,
				)
			"Location":
				create_text_cell(current_task.location, "Location", column_iteration)
			"TrackerCheckboxes":
				create_all_checkbox_cells()
			"Schedule Start":
				create_number_cell(current_task.scheduling_start, "Schedule Start", column_iteration)
			"Units/Cycle":
				create_number_cell(current_task.units_per_cycle, "Units/Cycle", column_iteration)
			"Delete Task":
				create_delete_task_cell("Delete Task", column_iteration)
			_:
				printerr("Unknown column")


func create_all_checkbox_cells() -> void:
	var checkbox = "Checkboxes"
	var checkbox_position = 1
	match current_task.section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			for month_iteration in current_task.month_checkbox_dictionary:
				if month_iteration == "All":
					continue
				var checkbox_data: TaskCheckboxData = (
					current_task.month_checkbox_dictionary[month_iteration][0]
				)
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


func create_header_cell(
	header_text_parameter: String,
	order_parameter: int,
	ordering_enabled_parameter: bool,
	sorting_mode_parameter: int,
	sorting_enabled_parameter: bool,
	column_group_parameter: String,
) -> void:
	var cell: PanelContainer = COLUMN_HEADER.instantiate()
	SignalBus._on_task_editor_header_cell_created.emit(cell)
	cell.header_button.text = header_text_parameter
	cell.order_spin_box.set_value_no_signal(order_parameter)
	cell.ordering_enabled(ordering_enabled_parameter)
	cell.set_sorting_mode(sorting_mode_parameter)
	cell.sorting_enabled(sorting_enabled_parameter)
	add_cell_to_groups(cell, column_group_parameter)


func create_dropdown_cell(
	dropdown_items: Array,
	selected_item,
	current_type: String,
	column_group: String = ""
) -> void:
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


func create_checkbox_cell(state: DataGlobal.Checkbox, user_profile: Array,
	cell_position: int, column_group: String = ""
) -> void:
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
	apply_all_column_visibility()
	SignalBus._on_task_set_data_modified.emit()
	update_existing_groups_option_button_items()


func _on_existing_groups_option_item_selected(index: int) -> void:
	var group_text: String = existing_groups_option_button.get_item_text(index)
	task_group_line_edit.text = group_text
