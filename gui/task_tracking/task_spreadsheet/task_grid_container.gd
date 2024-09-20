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
	TaskTrackingGlobal.load_settings_task_tracking()
	ready_connections()
	get_dropdown_items_from_global()
	auto_load_database()
	SqlManager.load_database
	populate_task_grid()



func ready_connections() -> void:
	TaskSignalBus._on_task_grid_column_count_changed.connect(set_grid_columns)


func get_dropdown_items_from_global() -> void:
	for item in DataGlobal.Section.keys():
		section_dropdown_items.append(item.capitalize())
	for item in DataGlobal.TimeOfDay.keys():
		time_of_day_dropdown_items.append(item.capitalize())
	for item in DataGlobal.Priority.keys():
		priority_dropdown_items.append(item.capitalize())


func auto_load_database() -> void:
	var task_settings = TaskTrackingGlobal.active_settings
	if task_settings.enable_auto_load_default_data:
		var auto_load_path: String = task_settings.autoload_database_path
		var auto_load_name: String = SqlManager.get_database_name_from_path(auto_load_path)
		if SqlManager.database_name == auto_load_name:
			prints("Database already open, no need to auto-load.")
			return
		SqlManager.set_database_name_and_path(auto_load_name, auto_load_path)


func populate_task_grid() -> void:
	var data_to_load: Array = query_for_task_grid()
	var first_row: Dictionary = data_to_load[0]
	TaskSignalBus._on_task_grid_populated.emit(first_row)
	for data_row_iteration in data_to_load:
		populate_task_row(data_row_iteration)


func query_for_task_grid() -> Array:
	SqlManager.query_data(TaskTrackingGlobal.form_task_grid_query())


func populate_task_row(row_data_param: Dictionary) -> void:
	var column_keys: Array = row_data_param.keys()
	var current_id: String
	for column_iteration in column_keys:
		var current_value: String = row_data_param[column_iteration]
		match column_iteration:
			"task_info_id":
				current_id = current_value
			"task", "task_group", "location":
				create_text_cell(current_id, column_iteration, current_value)
			"year", "daily_scheduling_start", "days_per_cycle", "daily_scheduling_end",\
					"weekly_scheduling_start", "weeks_per_cycle", "weekly_scheduling_end",\
					"monthly_scheduling_start", "months_per_cycle", "monthly_scheduling_end":
				create_number_cell(current_id, column_iteration, current_value)
			#"description":
				#
			#"assigned_to":
				#
			#"time_of_day":
				#
			#"priority":
				#
			#"month":
				#
			#"section":
				
				
			_:
				prints("Error populating rows.")


func set_grid_columns(column_param: int) -> void:
	columns = column_param


func reload_grid() -> void:
	clear_grid_children()


func clear_grid_children() -> void:
	var children = self.get_children()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()


func create_text_cell(task_id_param: String, column_param: String, text_param: String) -> void:
	var cell: LineEdit = TEXT_CELL.instantiate()
	add_child(cell)
	cell.set_text_cell(task_id_param, column_param, text_param)


func create_number_cell(task_id_param: String, column_param: String, number_param: String) -> void:
	var cell: SpinBox = NUMBER_CELL.instantiate()
	add_child(cell)
	cell.set_number_cell(task_id_param, column_param, number_param)


func create_multi_line_cell(task_id_param: String, column_param: String, multi_text_parameter: String) -> void:
	var cell: Button = MULTI_LINE_CELL.instantiate()
	add_child(cell)
	cell.set_multi_line_cell(task_id_param, column_param, multi_text_parameter)










func create_dropdown_cell(
	dropdown_items: Array,
	selected_item,
	current_type: String,
	column_group: String = ""
) -> void:
	var cell: OptionButton = DROPDOWN_CELL.instantiate()
	self.add_child(cell)
	pass


func create_checkbox_cell(state: TaskTrackingGlobal.Checkbox, user_profile: Array,
	cell_position: int, column_group: String = ""
) -> void:
	var cell: PanelContainer = CHECKBOX_CELL.instantiate()
	self.add_child(cell)
	pass


func delete_task_row(target_task: TaskData) -> void:
	pass




func get_all_column_dropdown_options() -> void:
	pass


func get_target_column_dropdown_options(target_param: String) -> void:
	pas





"""
trigger on loading db
query for uniques in category
set to array

ongoing, add any new entries to change dictionary / array





"""
