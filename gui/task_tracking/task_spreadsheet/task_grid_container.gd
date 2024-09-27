extends GridContainer



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




func _ready() -> void:
	ready_connections()
	get_dropdown_items_from_global()
	if not SqlManager.database_is_active:
		SqlManager.load_database()
	query_task_grid()
	populate_task_grid()



func ready_connections() -> void:
	TaskSignalBus._on_task_grid_column_count_changed.connect(set_grid_columns)
	TaskSignalBus._on_section_changed.connect(reload_grid)
	TaskSignalBus._on_month_changed.connect(reload_grid)
	TaskSignalBus._on_year_changed.connect(reload_grid)


func get_dropdown_items_from_global() -> void:
	for item in DataGlobal.Section.keys():
		section_dropdown_items.append(item.capitalize())
	for item in DataGlobal.TimeOfDay.keys():
		time_of_day_dropdown_items.append(item.capitalize())
	for item in DataGlobal.Priority.keys():
		priority_dropdown_items.append(item.capitalize())


#func auto_load_database() -> void:
	#var task_settings = TaskTrackingGlobal.active_settings
	#if task_settings.enable_auto_load_default_data:
		#var auto_load_path: String = task_settings.autoload_database_path
		#var auto_load_name: String = SqlManager.get_database_name_from_path(auto_load_path)
		#if SqlManager.database_name == auto_load_name:
			#prints("Database already open, no need to auto-load.")
			#return
		#SqlManager.set_database_name_and_path(auto_load_name, auto_load_path)


func query_task_grid() -> void:
	var query_text: String = TaskTrackingGlobal.form_task_grid_query()
	var queried_data: Array[Dictionary] = SqlManager.query_data(query_text)
	TaskTrackingGlobal.most_recent_query = queried_data


func populate_task_grid() -> void:
	if TaskTrackingGlobal.most_recent_query == []:
		prints("")
		prints("Empty query: No data to populate with.")
		prints("")
		return
	#prints("Populate Task Grid with:", TaskTrackingGlobal.most_recent_query)
	var first_row: Dictionary = TaskTrackingGlobal.most_recent_query[0]
	TaskSignalBus._on_task_grid_populated.emit(first_row)
	for data_row_iteration in TaskTrackingGlobal.most_recent_query:
		populate_task_row(data_row_iteration)


func populate_task_row(row_data_param: Dictionary) -> void:
	var column_keys: Array = row_data_param.keys()
	var current_id: String
	var checkbox_status: String
	var checkbox_currently_assigned: String
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
				create_dropdown_cell(current_id, column_iteration, current_user_name, TaskTrackingGlobal.current_users_keys, int(current_value))
			"time_of_day":
				create_dropdown_cell(current_id, column_iteration, current_value, time_of_day_dropdown_items)
			"priority":
				create_dropdown_cell(current_id, column_iteration, current_value, priority_dropdown_items)
			"month":
				create_dropdown_cell(current_id, column_iteration, current_value, DataGlobal.month_strings)
			"section":
				create_dropdown_cell(current_id, column_iteration, current_value, section_dropdown_items)
			_:
				if column_iteration.ends_with("_status"):
					checkbox_status = current_value
				elif column_iteration.ends_with("_currently_assigned"):
					checkbox_currently_assigned = current_value
				elif column_iteration.ends_with("_completed_by"):
					create_checkbox_cell(current_id, column_iteration, checkbox_status, checkbox_currently_assigned, current_value)
				else:
					prints("Error populating: Column:", column_iteration, "Value:", current_value)


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


func create_text_cell(task_id_param: String, column_param: String, text_param: String) -> void:
	var cell: LineEdit = TEXT_CELL.instantiate()
	add_child(cell)
	cell.set_text_cell(task_id_param, column_param, text_param)


func create_number_cell(task_id_param: String, column_param: String, number_param: String, min_param: int, max_param: int) -> void:
	var cell: SpinBox = NUMBER_CELL.instantiate()
	add_child(cell)
	cell.set_number_cell(task_id_param, column_param, number_param, min_param, max_param)


func create_multi_line_cell(task_id_param: String, column_param: String, multi_text_parameter: String) -> void:
	var cell: Button = MULTI_LINE_CELL.instantiate()
	add_child(cell)
	cell.set_multi_line_cell(task_id_param, column_param, multi_text_parameter)


func create_dropdown_cell(
	task_id_param: String,
	column_param: String,
	dropdown_param: String,
	dropdown_items: Array,
	user_id_param: int = -1,
) -> void:
	var cell: OptionButton = DROPDOWN_CELL.instantiate()
	add_child(cell)
	cell.set_dropdown_cell(task_id_param, column_param, dropdown_param, dropdown_items, user_id_param)



"""

"_status"
"_currently_assigned"
"_completed_by"

task
year
month

"""





func create_checkbox_cell(
	task_id_param: String,
	column_param: String,
	status_param: String,
	assigned_param: String,
	completed_param: String,
) -> void:
	var cell: PanelContainer = CHECKBOX_CELL.instantiate()
	add_child(cell)
	cell



func old_create_checkbox_cell(state: TaskTrackingGlobal.Checkbox, user_profile: Array,
	cell_position: int, column_group: String = ""
) -> void:
	pass


func delete_task_row(target_task: TaskData) -> void:
	pass







"""
trigger on loading db
query for uniques in category
set to array

ongoing, add any new entries to change dictionary / array





"""
