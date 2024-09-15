extends GridContainer



const CHECKBOX_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/checkbox_cell.tscn")
const DELETE_TASK_DATA_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/delete_task_data_cell.tscn")
const DROPDOWN_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/dropdown_cell.tscn")
const MULTI_LINE_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/multi_line_cell.tscn")
const NUMBER_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/number_cell.tscn")
const TASK_CHECKBOX_CLEAR_BUTTON_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/task_checkbox_clear_button_cell.tscn")
const TEXT_CELL = preload("res://gui/task_tracking/task_spreadsheet/cells/text_cell.tscn")




var blank_counter: int = 0
var section_dropdown_items: Array
var time_of_day_dropdown_items: Array
var priority_dropdown_items: Array
var current_text_edit_cell: MultiLineCell




func _ready() -> void:



	TaskTrackingGlobal.load_settings_task_tracking()
	ready_connections()
	get_dropdown_items_from_global()
	auto_load_database()
	TaskTrackingGlobal.task_editor_update_user_profile_dropdown_items()
	SqlManager.load_database 



func ready_connections() -> void:
	pass


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
		var auto_load_path: String = task_settings.default_database_path
		var auto_load_name: String = SqlManager.get_database_name_from_path(auto_load_path)
		SqlManager.set_database_name_and_path(auto_load_name, auto_load_path)



func reload_grid() -> void:
	clear_grid_children()



func clear_grid_children() -> void:
	var children = self.get_children()
	for current_kiddo in children:
		self.remove_child(current_kiddo)
		current_kiddo.queue_free()



func create_text_cell(text: String, current_type: String, column_group: String = "") -> void:
	var cell: LineEdit = TEXT_CELL.instantiate()
	self.add_child(cell)
	pass




func create_dropdown_cell(
	dropdown_items: Array,
	selected_item,
	current_type: String,
	column_group: String = ""
) -> void:
	var cell: OptionButton = DROPDOWN_CELL.instantiate()
	self.add_child(cell)
	pass



func create_multi_line_cell(multi_text_parameter: String, column_group: String = "") -> void:
	var cell: Button = MULTI_LINE_CELL.instantiate()
	self.add_child(cell)
	pass



func create_number_cell(number: int, current_type: String, column_group: String = "") -> void:
	var cell: SpinBox = NUMBER_CELL.instantiate()
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
