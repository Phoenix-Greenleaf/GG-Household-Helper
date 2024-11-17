extends PanelContainer

var saved_task_id: String
var saved_new_data_id: int
var saved_column: String
var saved_status: String
var saved_currently_assigned: int
var saved_completed_by: int
var saved_color: Color
var white: Color = Color.WHITE
var black: Color = Color.BLACK

var defaulted_status: bool = false
var defaulted_assigned_to: bool = false
var defaulted_completed_by: bool = false

@onready var top_color_rect: ColorRect = %TopColorRect
@onready var bottom_color_rect: ColorRect = %BottomColorRect
@onready var cell_checkbox_border_color_rect: ColorRect = %CellCheckboxBorderColorRect
@onready var cell_x: float
@onready var cell_y: float
@onready var checkbox_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Checkbox)



 #call cell_modified when edited
func _ready() -> void:
	name = "CheckboxCell"
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)
	TaskSignalBus._on_data_cell_remote_updated.connect(remote_update)
	focus_entered.connect(checkbox_focused)


func update_cell() -> void:
	update_color()
	update_checkbox()


func update_checkbox() -> void:
	match saved_status:
		"active":
			top_color_rect.set_color(white)
			bottom_color_rect.set_color(white)
			update_current_border(saved_color)
		"in_progress":
			top_color_rect.set_color(white)
			bottom_color_rect.set_color(saved_color)
			update_current_border(white)
		"completed":
			top_color_rect.set_color(saved_color)
			bottom_color_rect.set_color(saved_color)
			update_current_border(white)
		"expired":
			top_color_rect.set_color(black)
			bottom_color_rect.set_color(black)
			update_current_border(saved_color)
		_:
			print("Checkbox_cell update color match failure!", saved_status)


func update_color() -> void:
	var user_id_for_color: int
	if saved_completed_by == 1:
		user_id_for_color = saved_currently_assigned
	else:
		user_id_for_color = saved_completed_by
	var current_user: String = TaskTrackingGlobal.current_users_id.find_key(user_id_for_color)
	var current_color: String = TaskTrackingGlobal.current_users_color[current_user]
	var error_color: Color = Color.DARK_MAGENTA
	saved_color = Color.from_string(current_color, error_color)


func update_current_border(color_parameter: Color) -> void:
	if color_parameter == Color(1, 1, 1):
		cell_checkbox_border_color_rect.update_border()
		return
	cell_checkbox_border_color_rect.update_border(color_parameter)


func set_checkbox_cell(
	task_id_param,
	column_param: String,
	status_param: String,
	assigned_param: int,
	completed_param: int,
) -> void:
	defaulted_status = false
	defaulted_assigned_to = false
	defaulted_completed_by = false
	if type_string(typeof(task_id_param)) == "String":
		saved_task_id = task_id_param
	if type_string(typeof(task_id_param)) == "int":
		saved_new_data_id = task_id_param
	saved_column = column_param
	saved_status = status_param
	if status_param == "" or status_param == "<null>":
		saved_status = "active"
		defaulted_status = true
	saved_currently_assigned = assigned_param
	if assigned_param == 0:  # or assigned_param == "<null>"
		saved_currently_assigned = 1
		defaulted_assigned_to = true
	saved_completed_by = completed_param
	if completed_param == 0:       #or completed_param == "<null>":
		saved_completed_by = 1
		defaulted_completed_by = true
	update_cell()


func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(get_combined_minimum_size().x, self)


func sync_size(size_param: float) -> void:
	var min_size: Vector2 = Vector2(size_param, 0)
	custom_minimum_size = min_size


func cell_modified(new_status: String, new_currently_assigned: int, new_completed_by: int) -> void:
	var current_id
	if not saved_task_id.is_empty():
		current_id = saved_task_id
	if saved_new_data_id:
		current_id = saved_new_data_id
	var original_values: Array = [saved_status, saved_currently_assigned, saved_completed_by]
	var new_values: Array = [new_status, new_currently_assigned, new_completed_by]
	TaskSignalBus._on_checkbox_cell_modified.emit(current_id, saved_column, original_values, new_values)
	saved_status = new_status
	saved_currently_assigned = new_currently_assigned
	saved_completed_by = new_completed_by
	update_cell()
	#cell_id, column_name: String, original_value, new_value


func remote_update(cell_id, column_name: String, new_values: Dictionary) -> void:
	if column_name != saved_column:
		return
	match type_string(typeof(cell_id)):
		"String":
			if cell_id != saved_task_id:
				return
		"int":
			if cell_id != saved_new_data_id:
				return
	saved_status = new_values[column_name.to_lower() + "_status"]
	saved_currently_assigned = new_values[column_name.to_lower() + "_currently_assigned"]
	saved_completed_by = new_values[column_name.to_lower() + "_completed_by"]
	update_cell()


		#var target_new_data: Dictionary = changed_new_checkbox_data.get_or_add(cell_id, {})
		#target_new_data["column_name"] = column_name
		#target_new_data[column_name.to_lower() + "_status"] = new_value[0]
		#target_new_data[column_name.to_lower() + "_currently_assigned"] = new_value[1]
		#target_new_data[column_name.to_lower() + "_completed_by"] = new_value[2]
		#target_new_data["year"] = str(current_toggled_year)
		#target_new_data["month"] = month_enum_strings[current_toggled_month]


"""

INACTIVE
ACTIVE
IN_PROGRESS
COMPLETED
EXPIRED


SqlManager.daily_checkbox_addresses
SqlManager.weekly_checkbox_addresses
SqlManager.monthly_checkbox_addresses

"""

func checkbox_focused() -> void: #change you to clicked not focused? isnt focus used for arrow key navigation
	match TaskTrackingGlobal.current_toggled_checkbox_mode:
		TaskTrackingGlobal.CheckboxToggle.INSPECT:
			#focus_inspect_checkbox()
			pass
		TaskTrackingGlobal.CheckboxToggle.APPLY:
			focus_apply_checkbox()



func focus_apply_checkbox() -> void:
	var assigned_id: int = saved_currently_assigned
	var completed_id: int = saved_completed_by
	if TaskTrackingGlobal.current_checkbox_state == TaskTrackingGlobal.Checkbox.COMPLETED:
		completed_id = TaskTrackingGlobal.current_checkbox_profile_id
	else:
		assigned_id = TaskTrackingGlobal.current_checkbox_profile_id
	if (
		saved_status == get_status_string(TaskTrackingGlobal.current_checkbox_state)
		and saved_currently_assigned == assigned_id
		and saved_completed_by == completed_id
	):
		return
	cell_modified(
		get_status_string(TaskTrackingGlobal.current_checkbox_state),
		assigned_id,
		completed_id,
	)


func get_status_string(status_param: int) -> String:
	var current_status: String = checkbox_enum_strings[status_param]
	return current_status.to_lower()


#func focus_inspect_checkbox() -> void:

	#TaskSignalBus._on_checkbox_inspection.emit(inspected_id)
