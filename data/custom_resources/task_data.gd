extends Resource

class_name TaskData

@export var name: String

@export var section: DataGlobal.Section
@export var group: String
@export var previous_section: DataGlobal.Section

@export var assigned_user: Array
@export var time_of_day: DataGlobal.TimeOfDay
@export var priority: DataGlobal.Priority
@export var location: String
@export var scheduling_start: int
@export var units_per_cycle: int
@export var task_year: int
@export var month_checkbox_dictionary: Dictionary
@export var description: String
@export var row_order: int

var scheduling_array: Array
var currently_scheduling: int



func export_json_from_resource() -> Dictionary:
	var json_data: Dictionary = {
		"name": name,
		"section": section,
		"group": group,
		"previous_section": previous_section,
		"assigned_user_name": assigned_user[0],
		"assigned_user_color": assigned_user[1].to_html(),
		"time_of_day": time_of_day,
		"priority": priority,
		"location": location,
		"scheduling_start": scheduling_start,
		"units_per_cycle": units_per_cycle,
		"task_year": task_year,
		"month_checkbox_dictionary": format_month_checkbox_dictionary(),
		"description": description,
		"row_order": row_order,
	}
	return json_data


func format_month_checkbox_dictionary() -> Dictionary:
	var month_checkbox_dictionary_export := {}
	for unformatted_month in month_checkbox_dictionary:
		var formatted_checkboxes := []
		for unformatted_checkbox in month_checkbox_dictionary[unformatted_month]:
			formatted_checkboxes.append(unformatted_checkbox.export_json_from_resouce())
		month_checkbox_dictionary_export[unformatted_month] = formatted_checkboxes
	return month_checkbox_dictionary_export


func import_json_to_resource(data_parameter: Dictionary) -> void:
	var imported_assigned_user_name: String = data_parameter.assigned_user_name
	var imported_assigned_user_color := Color.from_string(data_parameter.assigned_user_color,
		Color.BLACK
	)
	var imported_month_checkbox_dictionary := {}
	for imported_month in data_parameter.month_checkbox_dictionary:
		var imported_checkbox_array := []
		for imported_checkbox_iteration in data_parameter.month_checkbox_dictionary[imported_month]:
			var imported_checkbox = TaskCheckboxData.new()
			imported_checkbox.import_json_to_resource(imported_checkbox_iteration)
			imported_checkbox_array.append(imported_checkbox)
		imported_month_checkbox_dictionary[imported_month] = imported_checkbox_array
	name = data_parameter.name
	section = data_parameter.section
	group = data_parameter.group
	previous_section = data_parameter.previous_section
	assigned_user = [imported_assigned_user_name, imported_assigned_user_color]
	time_of_day = data_parameter.time_of_day
	priority = data_parameter.priority
	location = data_parameter.location
	scheduling_start = data_parameter.scheduling_start
	units_per_cycle = data_parameter.units_per_cycle
	task_year = data_parameter.task_year
	month_checkbox_dictionary = imported_month_checkbox_dictionary
	description = data_parameter.description
	import_row_order(data_parameter)


func import_row_order(data_parameter) -> void:
	if data_parameter.has("row_order"):
		row_order = data_parameter.row_order


func offbrand_init() -> void:
	generate_month_dictionary()
	generate_all_checkboxes()


func generate_month_dictionary() -> void:
	if month_checkbox_dictionary:
		prints("Month Dictionary already exists")
		return
	for month in DataGlobal.month_strings:
		var capital_month = month.capitalize()
		month_checkbox_dictionary[capital_month] = []


func generate_all_checkboxes() -> void:
	scheduling_array.clear()
	currently_scheduling = 1
	match section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			generate_schedule(12)
			for month_iteration in month_checkbox_dictionary:
				if month_iteration == "All":
					continue
				generate_month_checkboxes(month_iteration, 1)
		DataGlobal.Section.WEEKLY:
			generate_schedule(5)
			for month_iteration in month_checkbox_dictionary:
				if month_iteration == "All":
					continue
				generate_month_checkboxes(month_iteration, 5)
		DataGlobal.Section.DAILY:
			generate_schedule(31)
			for month_iteration in month_checkbox_dictionary:
				if month_iteration == "All":
					continue
				var days: int = DataGlobal.days_in_month_finder(month_iteration, task_year)
				generate_month_checkboxes(month_iteration, days)


func generate_month_checkboxes(month, number: int) -> void:
	if month_checkbox_dictionary[month].size() != 0:
		return
	for iteration in number:
		var checkbox_iteration = TaskCheckboxData.new()
		var checkbox_options = default_checkbox_option()
		var checkbox_status = checkbox_options[0]
		var checkbox_assigned_user = checkbox_options[1]
		checkbox_iteration.update_checkbox_data(checkbox_status, checkbox_assigned_user)
		month_checkbox_dictionary[month].append(checkbox_iteration)
	blackout_unscheduled(month)


func default_checkbox_option() -> Array:
	var status: TaskTrackingGlobal.Checkbox = TaskTrackingGlobal.Checkbox.ACTIVE
	var user: Array = TaskTrackingGlobal.default_profile
	match TaskTrackingGlobal.active_settings_task_tracking.current_new_checkbox_option:
		TaskSettingsData.NewCheckboxOption.ACTIVE:
			pass
		TaskSettingsData.NewCheckboxOption.EXPIRED:
			status = TaskTrackingGlobal.Checkbox.EXPIRED
		TaskSettingsData.NewCheckboxOption.ASSIGNED:
			if assigned_user:
				user = assigned_user
	return [status, user]


func blackout_unscheduled(month_parameter) -> void:
	if scheduling_start == 0:
		prints("No scheduling")
		return
	for data_iteration in month_checkbox_dictionary[month_parameter]:
		if currently_scheduling in scheduling_array:
			currently_scheduling += 1
			continue
		data_iteration.checkbox_status = TaskTrackingGlobal.Checkbox.EXPIRED
		data_iteration.assigned_user = TaskTrackingGlobal.default_profile
		currently_scheduling += 1


func generate_schedule(schedule_length: int) -> void:
	if scheduling_start == 0:
		return
	var schedule_iteration = scheduling_start
	if units_per_cycle < 1:
		units_per_cycle = 1
	while schedule_iteration <= schedule_length:
		scheduling_array.append(schedule_iteration)
		schedule_iteration += units_per_cycle


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


func clear_self_checkboxes() -> void:
	prints("Clearing Self Checkboxes")
	match TaskTrackingGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			for month_iteration in month_checkbox_dictionary:
				month_checkbox_dictionary[month_iteration].clear()
		DataGlobal.Section.WEEKLY, DataGlobal.Section.DAILY:
			match DataGlobal.task_tracking_current_toggled_month:
				DataGlobal.Month.JANUARY:
					month_checkbox_dictionary["January"].clear()
				DataGlobal.Month.FEBRUARY:
					month_checkbox_dictionary["February"].clear()
				DataGlobal.Month.MARCH:
					month_checkbox_dictionary["March"].clear()
				DataGlobal.Month.APRIL:
					month_checkbox_dictionary["April"].clear()
				DataGlobal.Month.MAY:
					month_checkbox_dictionary["May"].clear()
				DataGlobal.Month.JUNE:
					month_checkbox_dictionary["June"].clear()
				DataGlobal.Month.JULY:
					month_checkbox_dictionary["July"].clear()
				DataGlobal.Month.AUGUST:
					month_checkbox_dictionary["August"].clear()
				DataGlobal.Month.SEPTEMBER:
					month_checkbox_dictionary["September"].clear()
				DataGlobal.Month.OCTOBER:
					month_checkbox_dictionary["October"].clear()
				DataGlobal.Month.NOVEMBER:
					month_checkbox_dictionary["November"].clear()
				DataGlobal.Month.DECEMBER:
					month_checkbox_dictionary["December"].clear()
	generate_all_checkboxes()


func section_transfer() -> void:
	if section == previous_section:
		return
	prints("Transfering from", DataGlobal.Section.keys()[previous_section],
		"to", DataGlobal.Section.keys()[section]
	)
	match previous_section:
		DataGlobal.Section.YEARLY:
			TaskTrackingGlobal.active_data.spreadsheet_year_data.erase(self)
		DataGlobal.Section.MONTHLY:
			TaskTrackingGlobal.active_data.spreadsheet_month_data.erase(self)
		DataGlobal.Section.WEEKLY:
			TaskTrackingGlobal.active_data.spreadsheet_week_data.erase(self)
		DataGlobal.Section.DAILY:
			TaskTrackingGlobal.active_data.spreadsheet_day_data.erase(self)
	match section:
		DataGlobal.Section.YEARLY:
			TaskTrackingGlobal.active_data.spreadsheet_year_data.append(self)
		DataGlobal.Section.MONTHLY:
			TaskTrackingGlobal.active_data.spreadsheet_month_data.append(self)
		DataGlobal.Section.WEEKLY:
			TaskTrackingGlobal.active_data.spreadsheet_week_data.append(self)
		DataGlobal.Section.DAILY:
			TaskTrackingGlobal.active_data.spreadsheet_day_data.append(self)
	for month_iteration in month_checkbox_dictionary:
		month_checkbox_dictionary[month_iteration].clear()
	previous_section = section
	generate_all_checkboxes()
	TaskSignalBus._on_grid_reload_pressed.emit()
