extends Resource
class_name TaskData

@export var task_id: int
@export var task: String
@export var section: Section
@export var month: Month
@export var year: int
@export var group: String
@export var task_description: String
@export var responsible_parties: String
@export var time_of_day: TimeOfDay
@export var priority: Priority
@export var location: String
@export var cycle: Array
@export var days_when_skipped: int
@export var last_completed: int 

var checkbox_data: Array

var section_keys: Array = Section.keys()
var month_keys: Array = Month.keys()

enum Checkbox {
	NOT_ASSIGNED,
	ASSIGNED,
	IN_PROGRESS,
	COMPLETED,
	EXPIRED,
}

enum Section {
	YEARLY,
	MONTHLY,
	WEEKLY,
	DAILY,
}

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

enum TimeOfDay {
	ANY,
	FIRST_THING,
	MORNING,
	AFTERNOON,
	EVENING,
	LAST_THING,
}

enum Priority {
	NO_PRIORITY,
	LOW_PRIORITY,
	NORMAL_PRIORITY,
	HIGH_PRIORITY,
	MAX_PRIORITY_OVERRIDE,
}

func _init(year_init: int, section_init: Section, _month_init: Month = Month.ALL) -> void:
	year = year_init
	section = section_init
	month = _month_init
	
	var section_label: String = section_keys[section]
	var month_label: String = month_keys[month]
	section_label = section_label.capitalize()
	month_label = month_label.capitalize()
	print( "Task Init: ", year, " ", month_label, " ", section_label)
	
	match section:
		Section.YEARLY:
			print("Yearly")
		Section.MONTHLY:
			print("Monthly")
		Section.WEEKLY:
			print("Weekly")
		Section.DAILY:
			print("Daily")
		_:
			print("Some kind of oops")
	
	
