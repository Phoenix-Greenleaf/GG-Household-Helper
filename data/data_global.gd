extends Node

enum Checkbox {
	INACTIVE, #blank
	ACTIVE, #white
	IN_PROGRESS, #faint color
	COMPLETED, #full color
	EXPIRED,  #black
}

enum Section {
	YEARLY,
	MONTHLY,
	WEEKLY,
	DAILY,
}

enum Month {
	NONE,
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


enum CheckboxToggle {
	APPLY,
	INSPECT
}


var default_profile: Array = ["No Profile", Color(1, 1, 1)]

var user_profiles: Array = [
	["Old Default", Color(1, 1, 0)],
	["Test 1", Color(0, 1, 0)],
	["Test 2", Color(1, 0, 0)],
	["Test 3", Color(0, 0, 1)],
	["Test Four", Color(1, 0, 1)],
]

var editor_modes: Dictionary = {"Checkbox": 0, "Info": 1}
var month_strings : Array[String]

var current_profile_data #waiting on that data/type
var current_tasksheet_data : TaskSpreadsheetData

var current_checkbox_state: int = Checkbox.COMPLETED
var current_checkbox_profile: Array = user_profiles[1]
var focus_checkbox_state: int
var focus_checkbox_profile: Array

var current_toggled_section : Section = Section.YEARLY
var current_toggled_month : String = "January"
var current_toggled_editor_mode : int = editor_modes["Checkbox"]
var current_toggled_checkbox_mode : CheckboxToggle = CheckboxToggle.INSPECT


func _init() -> void:
	var month_keys : Array = Month.keys()
	for month in month_keys:
		month_strings.append(month.capitalize())


func button_based_message(target: Node, message: String, time: int = 2) -> void:
	if target.text == message:
		prints("Not today pal")
		return
	var original_text = target.text
	target.text = message
	var timer := Timer.new()
	target.add_child(timer)
	timer.wait_time = time
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()
	target.text = original_text


func days_in_month_finder(month_in_question: String, year_in_question) -> int:
	match month_in_question: 
		"February":
			var leap_year_check = year_in_question % 4
			if leap_year_check == 0:
				return 29
			else:
				return 28
		"April", "June", "September", "November":
			return 30
		"January", "March", "May", "July", "August", "October", "December":
			return 31
		_:
			print("Days_in_month_finder match error")
			return 6


