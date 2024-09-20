extends PanelContainer

@export var saved_position: int
@export var saved_task: TaskData
@export var saved_profile: Array
@export var saved_state: TaskTrackingGlobal.Checkbox
@export var saved_color: Color

@onready var top: ColorRect = %TopColorRect
@onready var bottom: ColorRect = %BottomColorRect
@onready var cell_checkbox_border_color_rect: ColorRect = %CellCheckboxBorderColorRect
@onready var cell_x: float
@onready var cell_y: float

var white := Color(1, 1, 1)
var black := Color(0, 0, 0)
var first_row_flag: bool = false
var column_pair: String


func _ready() -> void:
	name = "CheckboxCell"

func update_active_data() -> void:
	match TaskTrackingGlobal.current_toggled_section:
		DataGlobal.Section.MONTHLY:
			year_and_month_updater()
		DataGlobal.Section.WEEKLY, DataGlobal.Section.DAILY:
			day_and_week_updater()
	TaskSignalBus._on_data_set_modified.emit()


func year_and_month_updater() -> void: 
	var current_position = saved_position
	var current_month = DataGlobal.month_strings[current_position]
	var current_data: TaskCheckboxData = saved_task.month_checkbox_dictionary[current_month][0]
	current_data.checkbox_status = saved_state
	current_data.assigned_user = saved_profile
	prints("Active data for checkbox", current_month, "saved!")


func day_and_week_updater() -> void: 
	var current_month = TaskTrackingGlobal.current_toggled_month
	var month_key = DataGlobal.Month.find_key(current_month).capitalize()
	var current_position = saved_position - 1 
	var current_data: TaskCheckboxData
	current_data = saved_task.month_checkbox_dictionary[month_key][current_position]
	current_data.checkbox_status = saved_state
	current_data.assigned_user = saved_profile
	prints("Active data for checkbox", saved_position, "saved!")


func update_checkbox() -> void:
	saved_color = saved_profile[1]
	match saved_state:
		TaskTrackingGlobal.Checkbox.ACTIVE:
			top.set_color(white)
			bottom.set_color(white)
			update_current_border(saved_color)
		TaskTrackingGlobal.Checkbox.IN_PROGRESS:
			top.set_color(white)
			bottom.set_color(saved_color)
			update_current_border(white)
		TaskTrackingGlobal.Checkbox.COMPLETED:
			top.set_color(saved_color)
			bottom.set_color(saved_color)
			update_current_border(white)
		TaskTrackingGlobal.Checkbox.EXPIRED:
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



#func create_checkbox_cell(state: TaskTrackingGlobal.Checkbox, user_profile: Array,
	#cell_position: int, column_group: String = ""
#) -> void:
	#var cell: PanelContainer = checkbox_cell.instantiate()
	#self.add_child(cell)
	#cell.saved_position = cell_position
	#cell.saved_task = current_task
	#cell.saved_profile = user_profile 
	#cell.saved_state = state
	#cell.update_checkbox()
	#add_cell_to_groups(cell, column_group)
	#set_first_row_flag(cell)
