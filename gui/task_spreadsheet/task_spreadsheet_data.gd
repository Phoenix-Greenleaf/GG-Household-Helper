extends Resource

class_name TaskSpreadsheetData

@export var task_year : int
@export var task_data: Array[TaskData]


func _init(task_year_parameter: int = 1990) -> void:
	task_year = task_year_parameter
	prints("Spreadsheet Date:", task_year)


func initialization_test():
	var test_task = TaskData.new(
		"Sheet Test Default",
		DataGlobal.Section.WEEKLY,
		"Sheet Test Group",
		DataGlobal.user_profiles[0],
		DataGlobal.TimeOfDay.AFTERNOON,
		DataGlobal.Priority.HIGH_PRIORITY,
		"Behind You",
		"week",
		2,
		1,
		"1990-12-25",
		task_year,
		)
	test_task.print_task_data()
