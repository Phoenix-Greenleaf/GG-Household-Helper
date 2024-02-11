extends PanelContainer

@export var saved_position: int
@export var saved_task: TaskData
@export var saved_profile: Array
@export var saved_state: DataGlobal.Checkbox
@export var saved_color: Color

@onready var top: ColorRect = %TopColorRect
@onready var bottom: ColorRect = %BottomColorRect
@onready var cell_checkbox_border_color_rect: ColorRect = %CellCheckboxBorderColorRect
@onready var cell_x: float
@onready var cell_y: float

var white := Color(1, 1, 1)
var black := Color(0, 0, 0)


func _ready() -> void:
	name = "CheckboxCell"

func update_active_data() -> void:
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			year_and_month_updater()
		DataGlobal.Section.WEEKLY, DataGlobal.Section.DAILY:
			day_and_week_updater()
	SignalBus._on_task_set_data_modified.emit()
	print_verbose("CheckboxCell", saved_task.name, saved_position, "func update_active_data emits '_on_task_set_data_modified'")


func year_and_month_updater() -> void: 
	var current_position = saved_position
	var current_month = DataGlobal.month_strings[current_position]
	var current_data: TaskCheckboxData = saved_task.month_checkbox_dictionary[current_month][0]
	current_data.checkbox_status = saved_state
	current_data.assigned_user = saved_profile
	prints("Active data for checkbox", current_month, "saved!")


func day_and_week_updater() -> void: 
	var current_month = DataGlobal.task_tracking_current_toggled_month
	var month_key = DataGlobal.Month.find_key(current_month).capitalize()
	var current_position = saved_position - 1 
	var current_data: TaskCheckboxData = saved_task.month_checkbox_dictionary[month_key][current_position]
	current_data.checkbox_status = saved_state
	current_data.assigned_user = saved_profile
	prints("Active data for checkbox", saved_position, "saved!")


func update_checkbox() -> void:
	saved_color = saved_profile[1]
	match saved_state:
		DataGlobal.Checkbox.ACTIVE:
			top.set_color(white)
			bottom.set_color(white)
			update_current_border(saved_color)
		DataGlobal.Checkbox.IN_PROGRESS:
			top.set_color(white)
			bottom.set_color(saved_color)
			update_current_border(white)
		DataGlobal.Checkbox.COMPLETED:
			top.set_color(saved_color)
			bottom.set_color(saved_color)
			update_current_border(white)
		DataGlobal.Checkbox.EXPIRED:
			top.set_color(black)
			bottom.set_color(black)
			update_current_border(saved_color)
		_:
			print("Checkbox_cell update color match failure!")


func update_current_border(color_parameter: Color) -> void:
	if color_parameter == Color(1, 1, 1):
		cell_checkbox_border_color_rect.update_border()
		return
	cell_checkbox_border_color_rect.update_border(color_parameter)


func _on_resized() -> void:
	cell_x = self.size.x
	cell_y = self.size.y
	if not cell_checkbox_border_color_rect:
		return
	cell_checkbox_border_color_rect.resize_border(cell_x, cell_y)

