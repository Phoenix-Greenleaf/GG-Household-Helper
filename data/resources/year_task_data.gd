extends Resource
class_name YearTaskData

@export var year_task_data_name: String
@export var year: int

var yearly_data: Array
var monthly_data: Array
var month_data_bundle: Array

@export var column_header: Array = [
	"Task",
	"Section",
	"Group",
	"Task Description",
	"Responsible Parties",
	"Time of Day",
	"Priority",
	"Location",
	"Days in Cycle",
	"Last Completed",
	"Days when skipping?",
]

enum Month {
	ALL,
	JANUARY,
	FEBRUARY,
	MARCH,
	APRIL,
	MAY,
	JUNE,
	JULY,
	AUGUST,
	SEPTEMBER,
	OCTOBER,
	NOVEMBER,
	DECEMBER,
}

enum Section {
	YEARLY,
	MONTHLY,
	WEEKLY,
	DAILY,
}

# call the data , store the data
func _init(year_init: int = 1990, name_init:= "blank") -> void:
	year = year_init
	year_task_data_name = name_init
	print("YTD Init ", year, " ", year_task_data_name)
	
	var section_keys: Array = Section.keys()
	for section_loop in Section.values():
		var section_label: String = section_keys[section_loop]
		section_label = section_label.capitalize()
		print("YTD Loop: ", section_label)
		TaskData.new(year_init, section_loop)
