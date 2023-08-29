extends Resource

class_name TaskSpreadsheetData

@export var spreadsheet_year : int
@export var spreadsheet_title : String
@export var spreadsheet_data: Array[TaskData]


func _init(
	spreadsheet_year_parameter: int = 1990,
	spreadsheet_title_parameter: String = "Default Name",
	) -> void:
	spreadsheet_year = spreadsheet_year_parameter
	spreadsheet_title = spreadsheet_title_parameter
	prints("Spreadsheet initialized:", spreadsheet_year, spreadsheet_title)


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
		spreadsheet_year,
		)
	test_task.print_task_data()
