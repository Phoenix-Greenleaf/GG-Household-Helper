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


var user_profiles: Array = [
	["Default", Color(1, 1, 0)],
	["Test 1", Color(0, 1, 0)],
	["Test 2", Color(1, 0, 0)],
	["Test 3", Color(0, 0, 1)],
	["Test Four", Color(1, 0, 1)],
]

var current_checkbox_state: int = Checkbox.COMPLETED
var current_checkbox_profile: Array = user_profiles[1]

