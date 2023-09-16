extends Resource

class_name TaskData

@export var name: String

@export var section: DataGlobal.Section
@export var group: String
@export var previous_section: DataGlobal.Section
@export var previous_group: String

@export var assigned_user: Array
@export var time_of_day: DataGlobal.TimeOfDay
@export var priority: DataGlobal.Priority
@export var location: String
@export var time_unit: String
@export var units_per_cycle: int
@export var units_added_when_skipped: int
@export var last_completed: String
@export var task_year: int
@export var month_checkbox_dictionary: Dictionary
@export var description: String




func offbrand_init(name_parameter, section_parameter, group_parameter) -> void:
	name = name_parameter
	section = section_parameter
	group = group_parameter
	previous_section = section_parameter
	previous_group = group_parameter
	generate_month_dictionary()
	generate_all_checkboxes()



func generate_month_dictionary() -> void:
	if month_checkbox_dictionary:
		prints("Month Dictionary already exists")
		return
	for month in DataGlobal.month_strings:
		if month == "None":
			continue
		month_checkbox_dictionary[month] = []


func generate_all_checkboxes() -> void:
	match section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			for month_iteration in month_checkbox_dictionary:
				generate_month_checkboxes(month_iteration, 1)
		DataGlobal.Section.WEEKLY:
			for month_iteration in month_checkbox_dictionary:
				generate_month_checkboxes(month_iteration, 5)
		DataGlobal.Section.DAILY:
			for month_iteration in month_checkbox_dictionary:
				var days: int = DataGlobal.days_in_month_finder(month_iteration, task_year)
				generate_month_checkboxes(month_iteration, days)

func test_print_checkboxes() -> void:
	print()
	prints("Task data", name, "checkbox check:")
	for month_iteration in month_checkbox_dictionary:
		prints("Iteration:", month_iteration, month_checkbox_dictionary[month_iteration].size())

func generate_month_checkboxes(month, number: int) -> void:
		for iteration in number:
			var checkbox_iteration = CheckboxData.new()
			var checkbox_status = DataGlobal.Checkbox.ACTIVE
			var checkbox_assigned_user = DataGlobal.default_profile
			checkbox_iteration.update_checkbox_data(checkbox_status, checkbox_assigned_user)
			month_checkbox_dictionary[month].append(checkbox_iteration)


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
