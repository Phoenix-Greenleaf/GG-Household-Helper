extends Resource

class_name TaskSpreadsheetData

@export var spreadsheet_year : int
@export var spreadsheet_title : String
@export var spreadsheet_filepath : String

@export var spreadsheet_year_data: Array[TaskData]
@export var spreadsheet_month_data: Array[TaskData]
@export var spreadsheet_week_data: Array[TaskData]
@export var spreadsheet_day_data: Array[TaskData]

@export var spreadsheet_year_groups: Array[String]
@export var spreadsheet_month_groups: Array[String]
@export var spreadsheet_week_groups: Array[String]
@export var spreadsheet_day_groups: Array[String]

#func add_new_task() -> void:
#	var task := TaskData.new()
	
