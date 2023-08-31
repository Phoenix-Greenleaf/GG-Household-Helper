extends Resource

class_name TaskData

@export var name : String

@export var section = DataGlobal.Section
@export var group : String

@export var assigned_user : Array
@export var time_of_day = DataGlobal.TimeOfDay
@export var priority = DataGlobal.Priority
@export var location : String
@export var time_unit : String
@export var units_per_cycle : int
@export var units_added_when_skipped : int
@export var last_completed : String
@export var task_year : int
@export var month_checkbox_dictionary : Dictionary




func offbrand_init() -> void:
	generate_months_from_global()
	generate_all_checkboxes()



func generate_months_from_global() -> void:
	if month_checkbox_dictionary:
		prints("Month Dictionary already exists")
		return
	var months_from_global = DataGlobal.Month.keys()
	for entry in months_from_global:
		entry = entry.capitalize()
		month_checkbox_dictionary[entry] = []
	prints("Generated months from global!")


func generate_all_checkboxes() -> void:
	for month_iteration in month_checkbox_dictionary:
		if month_iteration == "None":
			continue
		match section:
			DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
				generate_month_checkboxes(month_iteration, 1)
			DataGlobal.Section.WEEKLY:
				generate_month_checkboxes(month_iteration, 5)
			DataGlobal.Section.DAILY:
				var days : int = days_in_month_finder(month_iteration)
				generate_month_checkboxes(month_iteration, days)


func generate_month_checkboxes(month, number: int) -> void:
		for iteration in number:
			var checkbox_iteration = CheckboxData.new()
			month_checkbox_dictionary[month].append(checkbox_iteration)


func days_in_month_finder(month_in_question: String) -> int:
	match month_in_question: 
		"February":
			var leap_year_check = task_year % 4
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


func print_task_data() -> void:
	prints("Data for task:", name)
	prints("Section:", enum_uno_reverse(section, DataGlobal.Section))
	prints("Group:", group)
	prints("User:", assigned_user[0])
	prints("Time of day:", enum_uno_reverse(time_of_day, DataGlobal.TimeOfDay))
	prints("Priority:", enum_uno_reverse(priority, DataGlobal.Priority))
	prints("Location:", location)
	prints("Time Unit:", time_unit)
	prints("Units per cycle:", units_per_cycle)
	prints("Units added when skipped:", units_added_when_skipped)
	prints("ISO of last completion:", last_completed)
	prints("Year:", task_year)
	prints("Checkbox count by month:")
	for month_iteration in month_checkbox_dictionary:
		if month_iteration == "None":
			continue
		prints(month_iteration, ":", month_checkbox_dictionary[month_iteration].size())


func enum_uno_reverse(target_value: int, target_enum: Dictionary) -> String:
	var enum_keys = target_enum.keys()
	var enum_text = enum_keys[target_value]
	enum_text = enum_text.capitalize()
	return enum_text
