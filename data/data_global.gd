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






# Test Data


var column_header: Array = [
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

var task_one: Array = [
	"Task 1",
	"Yearly",
	"Group 1",
]

var task_two: Array = [
	"Task 2",
	"Weekly",
	"Group 2",
]

var task_three: Array = [
	"Task 3",
	"Weekly",
	"Group 3",
]

var task_four: Array = [
	"Task 4",
	"Daily",
	"Group 3",
]


var test_data_array: Array = [column_header, task_one, task_two, task_three, task_four]

func print_test_array():
	print("Test Data Array:")
	for row in test_data_array.size():
		print(test_data_array[row])
