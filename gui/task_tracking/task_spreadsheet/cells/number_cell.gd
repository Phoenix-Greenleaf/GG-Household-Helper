extends SpinBox

var saved_task_id: String
var saved_column: String
var saved_number: int


func _ready() -> void:
	name = "NumberCell"


func set_number_cell(task_id_param: String, column_param: String, number_param: String) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	saved_number = number_param.to_int()
	value = number_param.to_int()
	"""
	set some number ranges based on column
	"""






		"year", "daily_scheduling_start", "days_per_cycle", "daily_scheduling_end",\
					"weekly_scheduling_start", "weeks_per_cycle", "weekly_scheduling_end",\
					"monthly_scheduling_start", "months_per_cycle", "monthly_scheduling_end":
