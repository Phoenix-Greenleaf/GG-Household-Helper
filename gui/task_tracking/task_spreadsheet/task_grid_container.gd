extends GridContainer

@export var header_grid: GridContainer

const CHECKBOX_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/checkbox_cell.tscn")
const DELETE_TASK_DATA_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/delete_task_data_cell.tscn")
const DROPDOWN_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/dropdown_cell.tscn")
const MULTI_LINE_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/multi_line_cell.tscn")
const NUMBER_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/number_cell.tscn")
const TASK_CHECKBOX_CLEAR_BUTTON_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/task_checkbox_clear_button_cell.tscn")
const TEXT_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/text_cell.tscn")

var section_dropdown_items: Array
var time_of_day_dropdown_items: Array
var priority_dropdown_items: Array
var relevant_checkbox_addresses: Array

@onready var settings: TaskSettingsData



func _ready() -> void:
	ready_connections()
	get_dropdown_items_from_global()
	settings = TaskTrackingGlobal.active_settings
	run_auto_load()
	if SqlManager.active_database:
		reload_grid()


func ready_connections() -> void:
	TaskSignalBus._on_task_grid_column_count_changed.connect(set_grid_columns)
	TaskSignalBus._on_section_changed.connect(reload_grid)
	TaskSignalBus._on_month_changed.connect(reload_grid)
	TaskSignalBus._on_year_changed.connect(reload_grid)
	TaskSignalBus._on_task_grid_column_toggled.connect(reload_grid)
	TaskSignalBus._on_new_database_loaded.connect(reload_grid)
	TaskSignalBus._on_new_task_added.connect(populate_new_task_cells)


func get_dropdown_items_from_global() -> void:
	for item in DataGlobal.Section.keys():
		section_dropdown_items.append(item.capitalize())
	for item in DataGlobal.TimeOfDay.keys():
		time_of_day_dropdown_items.append(item.capitalize())
	for item in DataGlobal.Priority.keys():
		priority_dropdown_items.append(item.capitalize())


func run_auto_load() -> void:
	if settings.autoload_database_path:
		SqlManager.set_database_path_and_generate_name(settings.autoload_database_path)
		SqlManager.load_database()


func query_task_grid() -> void:
	var query_text: String = TaskTrackingGlobal.form_task_grid_query()
	var queried_data: Array[Dictionary] = SqlManager.query_data(query_text)
	prints("Task Grid Query Size:", queried_data.size())
	TaskTrackingGlobal.most_recent_query = queried_data


func populate_task_grid() -> void:
	if TaskTrackingGlobal.most_recent_query == []:
		prints("")
		prints("Empty query: No data to populate with.")
		prints("")
		return
	#prints("Populate Task Grid with:", TaskTrackingGlobal.most_recent_query)
	relevant_checkbox_addresses = current_section_checkbox_addresses()
	#prints("Relevant Checkboxes:", relevant_checkbox_addresses)
	var first_row: Dictionary = TaskTrackingGlobal.most_recent_query[0]
	populate_header(first_row)
	for data_row_iteration in TaskTrackingGlobal.most_recent_query:
		populate_task_row(data_row_iteration)
	apply_current_changes()
	TaskSignalBus._on_task_cells_resized_workaround_all_columns.emit()


func populate_header(first_row_param: Dictionary) -> void:
	TaskSignalBus._on_task_grid_populated.emit(first_row_param)


func populate_task_row(row_data_param: Dictionary) -> void:
	var column_keys: Array = row_data_param.keys()
	var current_id: String
	for column_iteration: String in column_keys:
		var current_value: String = str(row_data_param[column_iteration])
		match column_iteration:
			"task_info_id":
				current_id = current_value
			"task_name":
				create_text_cell(current_id, column_iteration, current_value)
			"year":
				create_number_cell(current_id, column_iteration, current_value, 1000, 3000)
			"daily_scheduling_start", "days_per_cycle", "daily_scheduling_end":
				create_number_cell(current_id, column_iteration, current_value, 0, 31)
			"weekly_scheduling_start", "weeks_per_cycle", "weekly_scheduling_end":
				create_number_cell(current_id, column_iteration, current_value, 0, 5)
			"monthly_scheduling_start", "months_per_cycle", "monthly_scheduling_end":
				create_number_cell(current_id, column_iteration, current_value, 0, 12)
			"description":
				create_multi_line_cell(current_id, column_iteration, current_value)
			"task_group":
				create_dropdown_cell(current_id, column_iteration, current_value, TaskTrackingGlobal.current_task_group_items)
			"location":
				create_dropdown_cell(current_id, column_iteration, current_value, TaskTrackingGlobal.current_location_items)
			"assigned_to":
				#prints("Current Users Id:")
				#prints(TaskTrackingGlobal.current_users_id)
				#prints("Current Value:", current_value)
				#prints("Type:", type_string(typeof(current_value)))
				var current_user_name: String = TaskTrackingGlobal.current_users_id.find_key(int(current_value))
				create_dropdown_cell(current_id, column_iteration, current_user_name, TaskTrackingGlobal.current_users_keys)
			"time_of_day":
				create_dropdown_cell(current_id, column_iteration, current_value, time_of_day_dropdown_items)
			"priority":
				create_dropdown_cell(current_id, column_iteration, current_value, priority_dropdown_items)
			"month":
				create_dropdown_cell(current_id, column_iteration, current_value, DataGlobal.month_strings)
			"section":
				create_dropdown_cell(current_id, column_iteration, current_value, section_dropdown_items)
			"days_in_month":
				pass
			_:
				#prints("Populate task wildcard:", column_iteration, current_value)
				if not relevant_checkbox_addresses.has(column_iteration):
					prints("Error populating: Column:", column_iteration, "Value:", current_value)
					continue
				populate_checkbox(current_id, column_iteration, current_value)


func populate_checkbox(current_id, column_iteration, current_value) -> void:
	var checkbox_status: String
	var checkbox_currently_assigned: String
	if column_iteration.ends_with("_status"):
		checkbox_status = current_value
		return
	if column_iteration.ends_with("_currently_assigned"):
		checkbox_currently_assigned = current_value
		return
	if column_iteration.ends_with("_completed_by"):
		column_iteration = column_iteration.replace("_completed_by", "")
		create_checkbox_cell(current_id, column_iteration, checkbox_status, checkbox_currently_assigned, current_value)


func current_section_checkbox_addresses() -> Array:
	match TaskTrackingGlobal.current_toggled_section:
		DataGlobal.Section.DAILY:
			return SqlManager.daily_checkbox_addresses
		DataGlobal.Section.WEEKLY:
			return SqlManager.weekly_checkbox_addresses
		DataGlobal.Section.MONTHLY:
			return SqlManager.monthly_checkbox_addresses
		_:
			return ["Error"]


func set_grid_columns(column_param: int) -> void:
	columns = column_param


func reload_grid() -> void:
	clear_grid_children()
	query_task_grid()
	populate_task_grid()
	check_for_editing_lock()


func clear_grid_children() -> void:
	var children = self.get_children()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()


func check_for_editing_lock() -> void:
	if not TaskTrackingGlobal.editing_locked:
		return
	TaskSignalBus._on_task_editing_lock_toggled.emit(true)


func create_text_cell(task_id_param, column_param: String, text_param: String) -> void:
	var cell: LineEdit = TEXT_CELL.instantiate()
	add_child(cell)
	cell.set_text_cell(task_id_param, column_param, text_param)


func create_number_cell(task_id_param, column_param: String, number_param: String, min_param: int, max_param: int) -> void:
	var cell: SpinBox = NUMBER_CELL.instantiate()
	add_child(cell)
	cell.set_number_cell(task_id_param, column_param, number_param, min_param, max_param)


func create_multi_line_cell(task_id_param, column_param: String, multi_text_parameter: String) -> void:
	var cell: Button = MULTI_LINE_CELL.instantiate()
	add_child(cell)
	cell.set_multi_line_cell(task_id_param, column_param, multi_text_parameter)


func create_dropdown_cell(
	task_id_param,
	column_param: String,
	dropdown_param: String,
	dropdown_items: Array,
) -> void:
	var cell: OptionButton = DROPDOWN_CELL.instantiate()
	add_child(cell)
	cell.set_dropdown_cell(task_id_param, column_param, dropdown_param, dropdown_items)


func create_checkbox_cell(
	task_id_param,
	column_param: String,
	status_param: String,
	assigned_param: String,
	completed_param: String,
) -> void:
	var cell: PanelContainer = CHECKBOX_CELL.instantiate()
	add_child(cell)
	cell.set_checkbox_cell(task_id_param, column_param, status_param, int(assigned_param), int(completed_param))


func editor_undo() -> void:
	var undone_task: Array = TaskTrackingGlobal.undo_active_changes()
	TaskSignalBus._on_data_cell_remote_updated.emit(undone_task[0], undone_task[1], undone_task[2])


func editor_redo() -> void:
	var redone_task: Array = TaskTrackingGlobal.redo_active_changes()
	TaskSignalBus._on_data_cell_remote_updated.emit(redone_task[0], redone_task[1], redone_task[3])


func apply_current_changes() -> void:
	populate_changed_new_data()
	apply_changed_existing_data()
	apply_all_checkbox_data()


"""
func submit_changed_data_to_database() -> void:
	var rows_to_update_count: int = changed_existing_data.size()
	var update_row_keys: Array = changed_existing_data.keys()
	var update_row_values: Array = changed_existing_data.values()
	for update_row_iteration in rows_to_update_count:
		var update_row_id: String = update_row_keys[update_row_iteration]
		var update_row_data: Dictionary = update_row_values[update_row_iteration]
		#var update_row_complete_data: Dictionary = {"task_info_id":update_row_id}
		#update_row_complete_data.merge(update_partial_data)
		var update_condition: String = "where " + task_info_id + " = " + update_row_id
		SqlManager.update_existing_data(task_info_table, update_condition, update_row_data)
	clear_changed_existing_data_with_failsafe()
	SqlManager.add_new_data(task_info_table, changed_new_data)
	clear_changed_new_data_with_failsafe()
"""



func populate_changed_new_data() -> void:
	if TaskTrackingGlobal.changed_new_data.is_empty():
		return
	var new_data_size: int = TaskTrackingGlobal.changed_new_data.size()
	for new_data_id in new_data_size:
		var iteration_data: Dictionary = TaskTrackingGlobal.changed_new_data[new_data_id]
		populate_new_task_cells(new_data_id, iteration_data)


func apply_changed_existing_data() -> void:
	if TaskTrackingGlobal.changed_existing_data.is_empty():
		return
	for id_key_iteration in TaskTrackingGlobal.changed_existing_data:
		var cell_id: String = id_key_iteration
		var row_data: Dictionary = TaskTrackingGlobal.changed_existing_data[id_key_iteration]
		for column_key_iteration in row_data:
			var column_name: String = column_key_iteration
			var new_value = row_data[column_key_iteration]
			TaskSignalBus._on_data_cell_remote_updated.emit(cell_id, column_name, new_value)


#changed_existing_checkbox_data
#changed_new_checkbox_data


func apply_all_checkbox_data() -> void:
	apply_checkbox_data(TaskTrackingGlobal.changed_existing_checkbox_data)
	apply_checkbox_data(TaskTrackingGlobal.changed_new_checkbox_data)


func apply_checkbox_data(data_to_apply: Dictionary) -> void:
	var data_keys = data_to_apply.keys()
	var data_values = data_to_apply.values()
	for checkbox_iteration in data_to_apply.size():
		var current_address = data_keys[checkbox_iteration]
		var current_id = current_address[0]
		var column_name: String = current_address[1]
		var checkbox_data: Dictionary = data_values[checkbox_iteration]
		TaskSignalBus._on_data_cell_remote_updated.emit(current_id, column_name, checkbox_data)


func populate_new_task_cells(new_task_id: int, new_task_data: Dictionary) -> void:
	var section_string: String = TaskTrackingGlobal.section_enum_strings[TaskTrackingGlobal.current_toggled_section]
	if new_task_data["section"] != section_string:
		return
	var column_keys: Array = new_task_data.keys()
	generate_new_task_add_header()
	populate_new_task_name(new_task_id, "task_name", str(new_task_data["task_name"]))
	populate_new_task_section(new_task_id, "section", section_string)
	populate_new_task_assigned_to(new_task_id, new_task_data, "assigned_to", column_keys)
	populate_new_task_location(new_task_id, new_task_data, "location", column_keys)
	populate_new_task_priority(new_task_id, new_task_data, "", column_keys)
	populate_new_task_time_of_day(new_task_id, new_task_data, "", column_keys)
	populate_new_task_description(new_task_id, new_task_data, "", column_keys)
	populate_new_task_group(new_task_id, new_task_data, "task_group", column_keys)
	populate_new_task_scheduling(new_task_id, new_task_data, "", column_keys)
	populate_new_task_checkboxes(new_task_id, new_task_data, "", column_keys)


func populate_new_task_name(new_task_id: int, column_iteration: String, current_value) -> void:
	create_text_cell(new_task_id, column_iteration, current_value)


func populate_new_task_section(new_task_id: int, column_iteration: String, current_value) -> void:
	if TaskTrackingGlobal.section_column_toggled:
		create_dropdown_cell(new_task_id, column_iteration, current_value, section_dropdown_items)


func populate_new_task_assigned_to(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.assigned_to_column_toggled:
		var current_value: String
		if column_keys.has(column_iteration):
			current_value = str(new_task_data[column_iteration])
		else:
			current_value = "0"
		var current_user_name: String = TaskTrackingGlobal.current_users_id.find_key(int(current_value))
		create_dropdown_cell(new_task_id, column_iteration, current_user_name, TaskTrackingGlobal.current_users_keys)


func populate_new_task_location(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.location_column_toggled:
		var current_value: String
		if column_keys.has(column_iteration):
			current_value = str(new_task_data[column_iteration])
		else:
			current_value = "0"
		create_dropdown_cell(new_task_id, column_iteration, current_value, TaskTrackingGlobal.current_location_items)


func populate_new_task_group(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.group_column_toggled:
		var current_value: String
		if column_keys.has(column_iteration):
			current_value = str(new_task_data[column_iteration])
		else:
			current_value = ""
		create_dropdown_cell(new_task_id, column_iteration, current_value, TaskTrackingGlobal.current_task_group_items)


func populate_new_task_scheduling(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.scheduling_column_toggled:
		var current_value: String
		match TaskTrackingGlobal.current_toggled_section:
			DataGlobal.Section.DAILY:
				column_iteration = "daily_scheduling_start"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "0"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 31)
				column_iteration = "days_per_cycle"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "0"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 31)
				column_iteration = "daily_scheduling_end"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "31"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 31)
			DataGlobal.Section.WEEKLY:
				column_iteration = "weekly_scheduling_start"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "0"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 5)
				column_iteration = "weeks_per_cycle"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "0"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 5)
				column_iteration = "weekly_scheduling_end"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "5"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 5)
			DataGlobal.Section.MONTHLY:
				column_iteration = "monthly_scheduling_start"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "0"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 12)
				column_iteration = "months_per_cycle"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "0"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 12)
				column_iteration = "monthly_scheduling_end"
				if column_keys.has(column_iteration):
					current_value = str(new_task_data[column_iteration])
				else:
					current_value = "12"
				create_number_cell(new_task_id, column_iteration, current_value, 0, 12)
			#"year":
				#create_number_cell(new_task_id, column_iteration, current_value, 1000, 3000)
			#"month":
				#create_dropdown_cell(new_task_id, column_iteration, current_value, DataGlobal.month_strings)


func populate_new_task_priority(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.priority_column_toggled:
		var current_value: String
		column_iteration = "priority"
		if column_keys.has(column_iteration):
			current_value = str(new_task_data[column_iteration])
		else:
			current_value = "0"
		create_dropdown_cell(new_task_id, column_iteration, current_value, priority_dropdown_items)


func populate_new_task_time_of_day(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.time_of_day_column_toggled:
		var current_value: String
		column_iteration = "time_of_day"
		if column_keys.has(column_iteration):
			current_value = str(new_task_data[column_iteration])
		else:
			current_value = "0"
		create_dropdown_cell(new_task_id, column_iteration, current_value, time_of_day_dropdown_items)


func populate_new_task_description(new_task_id: int, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.description_column_toggled:
		var current_value: String
		column_iteration = "description"
		if column_keys.has(column_iteration):
			current_value = str(new_task_data[column_iteration])
		else:
			current_value = ""
		create_multi_line_cell(new_task_id, column_iteration, current_value)


func populate_new_task_checkboxes(new_task_id, new_task_data: Dictionary, column_iteration: String, column_keys: Array) -> void:
	if TaskTrackingGlobal.checkboxes_column_toggled:
		var current_value: String
		var checkbox_status: String
		var checkbox_currently_assigned: String
		match TaskTrackingGlobal.current_toggled_section:
			DataGlobal.Section.DAILY:
				for checkbox_column_iteration in SqlManager.daily_checkbox_addresses:
					if column_keys.has(column_iteration):
						current_value = str(new_task_data[column_iteration])
					else:
						current_value = ""
					process_checkbox_new_data_cells(new_task_id, checkbox_column_iteration, current_value, checkbox_status, checkbox_currently_assigned)
			DataGlobal.Section.WEEKLY:
				for checkbox_column_iteration in SqlManager.weekly_checkbox_addresses:
					if column_keys.has(column_iteration):
						current_value = str(new_task_data[column_iteration])
					else:
						current_value = ""
					process_checkbox_new_data_cells(new_task_id, checkbox_column_iteration, current_value, checkbox_status, checkbox_currently_assigned)
			DataGlobal.Section.MONTHLY:
				for checkbox_column_iteration in SqlManager.monthly_checkbox_addresses:
					if column_keys.has(column_iteration):
						current_value = str(new_task_data[column_iteration])
					else:
						current_value = ""
					process_checkbox_new_data_cells(new_task_id, checkbox_column_iteration, current_value, checkbox_status, checkbox_currently_assigned)


func generate_new_task_add_header() -> void:
	if header_grid.get_child_count() != 0:
		prints("Generate New Task Header protection: Header already exists!")
		return
	var column_array: PackedStringArray = []
	TaskTrackingGlobal.gather_task_info_columns(column_array)
	TaskTrackingGlobal.gather_checkbox_info_columns(column_array)
	var prepped_header_data: Dictionary
	for iteration in column_array:
		prepped_header_data[iteration] = ""
	populate_header(prepped_header_data)


func process_checkbox_new_data_cells(
	current_id,
	column_iteration: String,
	current_value,
	checkbox_status,
	checkbox_currently_assigned
) -> void:
	if column_iteration.ends_with("_status"):
		checkbox_status = current_value
		return
	if column_iteration.ends_with("_currently_assigned"):
		checkbox_currently_assigned = current_value
		return
	if column_iteration.ends_with("_completed_by"):
		column_iteration = column_iteration.replace("_completed_by", "")
		create_checkbox_cell(current_id, column_iteration, checkbox_status, checkbox_currently_assigned, current_value)



"""

				populate_checkbox(new_task_id, column_iteration, current_value)


signal _on_data_cell_remote_updated(cell_id, column_name: String, new_value)

"just" combine those two monster: populate row's cell gen plus query's column toggle.
NOPE just genarate the empty checkboxes, and update shortly after







func populate_task_row(row_data_param: Dictionary) -> void:

[cell_id, column_name, original_value, new_value]
#_on_data_cell_remote_updated(cell_id, column_name: String, new_value)


TaskSignalBus._on_data_cell_remote_updated.emit()



"_status"
"_currently_assigned"
"_completed_by"

task
year
month


func delete_task_row(target_task: TaskData) -> void:


submit_change
submit_changed_data_to_database
undo_active_changes
redo_active_changes


trigger on loading db
query for uniques in category
set to array

ongoing, add any new entries to change dictionary / array





"""
