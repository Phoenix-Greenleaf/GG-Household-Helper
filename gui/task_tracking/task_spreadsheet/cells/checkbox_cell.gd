extends PanelContainer

var saved_task_id: String
var saved_column: String
var saved_status: String
var saved_currently_assigned: String
var saved_completed_by: String
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



func _ready() -> void:
	name = "CheckboxCell"


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
	var user_id_for_color: String
	if saved_completed_by == "1":
		user_id_for_color = saved_currently_assigned
	else:
		user_id_for_color = saved_completed_by
	#if user_id_for_color == "<null>":
		#user_id_for_color = "1"
		#prints("Color update", TaskTrackingGlobal.current_users_id)
	var current_user: String = TaskTrackingGlobal.current_users_id.find_key(int(user_id_for_color))
	var current_color: String = TaskTrackingGlobal.current_users_color[current_user]
	var error_color: Color = Color.DARK_MAGENTA
	saved_color = Color.from_string(current_color, error_color)


func update_current_border(color_parameter: Color) -> void:
	if color_parameter == Color(1, 1, 1):
		cell_checkbox_border_color_rect.update_border()
		return
	cell_checkbox_border_color_rect.update_border(color_parameter)


func set_checkbox_cell(
	task_id_param: String,
	column_param: String,
	status_param: String,
	assigned_param: String,
	completed_param: String,
) -> void:
	defaulted_status = false
	defaulted_assigned_to = false
	defaulted_completed_by = false
	saved_task_id = task_id_param
	saved_column = column_param
	saved_status = status_param
	if status_param == "" or status_param == "<null>":
		saved_status = "active"
		defaulted_status = true
	saved_currently_assigned = assigned_param
	if assigned_param == "" or assigned_param == "<null>":
		saved_currently_assigned = "1"
		defaulted_assigned_to = true
	saved_completed_by = completed_param
	if completed_param == "" or completed_param == "<null>":
		saved_completed_by = "1"
		defaulted_completed_by = true
	update_cell()



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
