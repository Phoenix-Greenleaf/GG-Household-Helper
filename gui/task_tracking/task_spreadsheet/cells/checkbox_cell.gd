extends PanelContainer

var saved_task_id: String
var saved_column: String
var saved_status: String
var saved_currently_assigned: String
var saved_completed_by: String
var saved_color: Color
var white: Color = Color.WHITE
var black: Color = Color.BLACK

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
		"ACTIVE":
			top_color_rect.set_color(white)
			bottom_color_rect.set_color(white)
			update_current_border(saved_color)
		"IN_PROGRESS":
			top_color_rect.set_color(white)
			bottom_color_rect.set_color(saved_color)
			update_current_border(white)
		"COMPLETED":
			top_color_rect.set_color(saved_color)
			bottom_color_rect.set_color(saved_color)
			update_current_border(white)
		"EXPIRED":
			top_color_rect.set_color(black)
			bottom_color_rect.set_color(black)
			update_current_border(saved_color)
		_:
			print("Checkbox_cell update color match failure!")


func update_color() -> void:
	var user_id_for_color: String
	if saved_completed_by == "":
		user_id_for_color = saved_currently_assigned
	else:
		user_id_for_color = saved_completed_by
	for user_iteration in TaskTrackingGlobal.current_users:
		if user_id_for_color != user_iteration[0]:
			continue
		saved_color = Color.from_string(user_iteration[1], Color.DARK_MAGENTA)
		return


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
	saved_task_id = task_id_param
	saved_column = column_param
	saved_status = status_param
	saved_currently_assigned = assigned_param
	saved_completed_by = completed_param
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
