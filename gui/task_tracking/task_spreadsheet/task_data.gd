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
@export var scheduling_start: int
@export var units_per_cycle: int
@export var task_year: int
@export var month_checkbox_dictionary: Dictionary
@export var description: String

var scheduling_array: Array
var currently_scheduling: int


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
	apply_scheduling()


func generate_month_checkboxes(month, number: int) -> void:
		for iteration in number:
			var checkbox_iteration = CheckboxData.new()
			var checkbox_options = new_checkbox_option()
			var checkbox_status = checkbox_options[0]
			var checkbox_assigned_user = checkbox_options[1]
			checkbox_iteration.update_checkbox_data(checkbox_status, checkbox_assigned_user)
			month_checkbox_dictionary[month].append(checkbox_iteration)


func new_checkbox_option() -> Array:
	var settings: SettingsData = DataGlobal.settings_file
	var status: DataGlobal.Checkbox = DataGlobal.Checkbox.ACTIVE
	var user: Array = DataGlobal.default_profile
	match settings.task_current_new_checkbox_option:
		settings.NEW_CHECKBOX_OPTION.ACTIVE:
			pass
		settings.NEW_CHECKBOX_OPTION.EXPIRED:
			status = DataGlobal.Checkbox.EXPIRED
		settings.NEW_CHECKBOX_OPTION.ASSIGNED:
			if assigned_user:
				user = assigned_user
	return [status, user]


func apply_scheduling() -> void:
	scheduling_array.clear()
	currently_scheduling = 1
	if scheduling_start == 0:
		return
	match section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			generate_schedule(12)
			for month_iteration in month_checkbox_dictionary:
				blackout_unscheduled(month_iteration)
		DataGlobal.Section.WEEKLY:
			generate_schedule(5)
			for month_iteration in month_checkbox_dictionary:
				blackout_unscheduled(month_iteration)
		DataGlobal.Section.DAILY:
			generate_schedule(31)
			for month_iteration in month_checkbox_dictionary:
				blackout_unscheduled(month_iteration)


func blackout_unscheduled(month_parameter) -> void:
	for data_iteration in month_checkbox_dictionary[month_parameter]:
		if currently_scheduling in scheduling_array:
			currently_scheduling += 1
			continue
		data_iteration.checkbox_status = DataGlobal.Checkbox.EXPIRED
		data_iteration.assigned_user = DataGlobal.default_profile
		currently_scheduling += 1


func generate_schedule(schedule_length: int) -> void:
	var schedule_iteration = scheduling_start
	if units_per_cycle < 1:
		units_per_cycle = 1
	while schedule_iteration <= schedule_length:
		scheduling_array.append(schedule_iteration)
		schedule_iteration += units_per_cycle
	prints("Schedule:", scheduling_array)


func print_task_data() -> void:
	prints("\nPrinting Task Data:")
	prints("Data for task:", name)
	prints("Section:", enum_uno_reverse(section, DataGlobal.Section))
	prints("Group:", group)
	prints("Assigned User:", assigned_user[0])
	prints("Time of day:", enum_uno_reverse(time_of_day, DataGlobal.TimeOfDay))
	prints("Priority:", enum_uno_reverse(priority, DataGlobal.Priority))
	prints("Location:", location)
	prints("Scheduling Start:", scheduling_start)
	prints("Units per cycle:", units_per_cycle)
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
