extends Node

var active_data: TaskSetData #to be removed once old data import not needed

var active_settings: TaskSettingsData #still in the old format, for now

var data_folder = "user://task_tracker_data/"
var data_name: String = "task_tracking_" #to be removed once old data import not needed
var settings_name: String = "task_tracking_settings"

var filepath_task_tracking_settings: String = (DataGlobal.settings_folder
	+ settings_name + DataGlobal.json_extension
)


var current_toggled_section: DataGlobal.Section = DataGlobal.Section.MONTHLY:
	set(value):
		current_toggled_section = value
		TaskSignalBus._on_section_changed.emit()
var current_toggled_month: DataGlobal.Month = DataGlobal.Month.JANUARY:
	set(value):
		current_toggled_month = value
		TaskSignalBus._on_month_changed.emit()
var current_toggled_year: int = 1990:
	set(value):
		current_toggled_year = value
		TaskSignalBus._on_year_changed.emit()
var current_toggled_checkbox_mode: CheckboxToggle = CheckboxToggle.INSPECT:
	set(value):
		current_toggled_checkbox_mode = value
		TaskSignalBus._on_checkbox_mode_changed.emit()


@onready var current_checkbox_profile: Array = default_profile
var current_checkbox_state: Checkbox = Checkbox.ACTIVE
var focus_checkbox_state: int
var focus_checkbox_profile: Array
#var task_group_dropdown_items: Array 
var user_profiles_dropdown_items: Array


var default_profile: Array = ["No Profile", Color.WHITE]

enum Checkbox {
	INACTIVE, #blank
	ACTIVE, #white
	IN_PROGRESS, #faint color
	COMPLETED, #full color
	EXPIRED,  #black
}


enum CheckboxToggle {
	APPLY,
	INSPECT
}


func _ready() -> void:
	connect_signals()
	load_task_tracking_settings()



func connect_signals() -> void:
	TaskSignalBus._on_new_database_loaded.connect(generate_dropdown_item_arrays)
	TaskSignalBus._on_new_database_loaded.connect(generate_existing_years_index)
	TaskSignalBus._on_task_editing_lock_toggled.connect(remember_editing_lock)
	TaskSignalBus._on_task_editing_settings_changed.connect(save_task_tracking_settings)
	TaskSignalBus._on_data_cell_modified.connect(submit_change)


func remember_editing_lock(locked: bool) -> void:
	editing_locked = locked


func load_task_tracking_settings() -> void:
	DataGlobal.directory_check(DataGlobal.settings_folder)
	active_settings = TaskSettingsData.new()
	if not FileAccess.file_exists(filepath_task_tracking_settings):
		active_settings.reset_settings()
		save_task_tracking_settings()
		return
	var json_data = JsonSaveManager.load_data(filepath_task_tracking_settings)
	active_settings.import_json_to_resource(json_data)


func save_task_tracking_settings() -> void:
	var json_data = active_settings.export_json_from_resouce()
	JsonSaveManager.save_data(filepath_task_tracking_settings, json_data)

# just around to load old data sets

func transer_old_data_to_database() -> void:
	var user_info_to_insert: Array = extract_user_info()
	SqlManager.add_data(user_info_table, user_info_to_insert)
	generate_users_dropdown_items()
	#var sections_to_insert: Array = create_new_date_data(2024)
	#SqlManager.add_data(dates_table, sections_to_insert)
	var task_info_to_insert: Array = extract_task_info()
	SqlManager.add_data(task_info_table, task_info_to_insert)
	generate_task_group_dropdown_items()
	generate_location_dropdown_items()



func extract_old_sections() -> Array:
	var all_old_task_info: Array
	all_old_task_info = extract_target_old_section(active_data.spreadsheet_year_data)
	all_old_task_info.append_array(extract_target_old_section(active_data.spreadsheet_month_data))
	all_old_task_info.append_array(extract_target_old_section(active_data.spreadsheet_week_data))
	all_old_task_info.append_array(extract_target_old_section(active_data.spreadsheet_day_data))
	return all_old_task_info


func extract_target_old_section(target_section: Array) -> Array:
	var section_tasks: Array
	for task_info in target_section:
		if task_info is not TaskData:
			printerr("Extraction hit a non-TaskData entry, send help")
		section_tasks.append(task_info)
	return section_tasks


func extract_user_info() -> Array:
	var all_user_info_data_rows: Array
	for user_entry in active_data.user_profiles:
		var user_color: String = user_entry[1].to_html()
		var user_name: String = user_entry[0]
		var user_info_data_row: Dictionary = {
			name_ : user_name,
			color_ : user_color
		}
		all_user_info_data_rows.append(user_info_data_row)
	return all_user_info_data_rows



func extract_task_info() -> Array:
	var all_task_info_data_rows: Array
	var gathered_task_info: Array = extract_old_sections()
	for task_entry: TaskData in gathered_task_info:
		var name_assigned_to: String = task_entry.assigned_user[0]
		if name_assigned_to == "No Profile":
			name_assigned_to = SqlManager.unassigned_user_text
		var task_info_data_row: Dictionary = {
			task_name : task_entry.name,
			assigned_to : current_users_id[name_assigned_to],
			section : section_enum_strings[task_entry.section],
			task_group : task_entry.group,
		}
		#
		all_task_info_data_rows.append(task_info_data_row)
	return all_task_info_data_rows


func query_user_info() -> void:
	var raw_user_query: Array = SqlManager.query_data("select user_info_id, name, color from user_info")
	var user_id: Dictionary
	var user_color: Dictionary
	for user_iteration in raw_user_query:
		user_id[user_iteration[name_]] = user_iteration[user_info_id]
		user_color[user_iteration[name_]] = user_iteration[color_]
	current_users_id = user_id
	current_users_color = user_color
	current_users_keys = current_users_id.keys()


func create_new_date_data(year_parameter: int) -> Array: #needed anymore?
	var year_string := str(year_parameter)
	var all_section_data_rows: Array
	var monthly_section_row: Dictionary = {
		year : year_string,
		month : "all",
	}
	all_section_data_rows.append(monthly_section_row)
	for month_iteration in SqlManager.month_strings:
			if month_iteration == "all":
				continue
			var section_data_row: Dictionary = {
				year : year_string,
				month : month_iteration,
			}
			all_section_data_rows.append(section_data_row)
	return all_section_data_rows


func load_data_task_set(task_set_name: String, task_set_year: int) -> void:
	active_data = null #does this have any impact?
	active_data = TaskSetData.new()
	var task_set_filepath := generate_task_set_filepath(task_set_name, task_set_year)
	prints("task set filepath to load:", task_set_filepath)
	var json_data = JsonSaveManager.load_data(task_set_filepath)
	active_data.import_json_to_resource(json_data)
	prints("load_data_task_set complete!")


func generate_task_set_filepath(task_set_name: String, task_set_year: int) -> String:
	var task_set_save_name: String = (data_name + task_set_name
		+ "_" + str(task_set_year)
	)
	var task_set_filepath: String = DataGlobal.generate_filepath(task_set_save_name,
		DataGlobal.FileType.TASK_TRACKING_DATA
	)
	return task_set_filepath


"""
SQL SCIENCE

schedule-incompatibility warning (mixing sections)
search button, not on each little toggle

column order?
all month toggle? all item toggle?



=== edit logs ===
- buttons store referance info and call functio when pressed
- new edits overwrite old edits
- any data changes, load data then apply edits
- saving commits changes to database, epties logs
- save protection based on change log size == 0
- undo and redo changes?
- store changes like the requests, so it directly replace loaded data


on button edit:
	add changes to edit dictionary
	keep stored loaded value, to compare if changed back before saving


on task editor changes or reload:
	query for data
	load any applicable edits


clear changes button? undo and or redo changes button?
- changes menu, lists last undo, 


load data:
	- get list of availible databases
	- verify main tables exists in file
	- display name
	- query database - based on which data cells are active
	- load cells with data


order by?
group by?


any adding info:
	- check if duplicate
	- give error and do not add


create task:
	- grab relevant info
	- fill in any important blanks
	- create

create user:
	- just add


create year: 
	- add year

create sections: 
	- generate with new year

create daily/weekly/monthly


create events:
	- load default status if event empty
	- create data when actually modified


data changes:
	- make dictionary of any changes
	- new changes should override old change dictionary
	- changes held in global memory, displayed info is just temporary
	- have cells track important info for making change dictionary
	- any display changes load unchanged info from database, then applies any relevant changes
	- can cells call out to check for changes, based on being on screen? to prevent uneeded changes?
	- will previous solution also need a 'just became screen visible' feature to check for updates?


save data:
	- get name
	- submit changes dictionary to database



create database:
	- check new name vs existing db names, throw error if sames
	- create tables
	- create first user for unassigned entries

"""

var existing_years_index: Array
var current_task_group_items: Array
var current_location_items: Array
var current_users_id: Dictionary
var current_users_color: Dictionary
var current_users_keys: Array


var month_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Month)
var section_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Section)
var time_of_day_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.TimeOfDay)
var priority_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Priority)

var last_changed_id
var last_changed_column: String

@onready var id: String = SqlManager.id
@onready var name_: String = SqlManager.name_
@onready var color_: String = SqlManager.color_
@onready var status: String = SqlManager.status
@onready var completed_by: String = SqlManager.completed_by
@onready var last_completed: String = SqlManager.last_completed
@onready var task: String = SqlManager.task
@onready var task_name: String = SqlManager.task_name
@onready var task_group: String = SqlManager.task_group
@onready var assigned_to: String = SqlManager.assigned_to
@onready var description: String = SqlManager.description
@onready var time_of_day: String = SqlManager.time_of_day
@onready var priority: String = SqlManager.priority
@onready var location: String = SqlManager.location
@onready var year: String = SqlManager.year
@onready var month: String = SqlManager.month
@onready var section: String = SqlManager.section
@onready var daily_scheduling_start: String = SqlManager.daily_scheduling_start
@onready var days_per_cycle: String = SqlManager.days_per_cycle
@onready var daily_scheduling_end: String = SqlManager.daily_scheduling_end
@onready var weekly_scheduling_start: String = SqlManager.weekly_scheduling_start
@onready var weeks_per_cycle: String = SqlManager.weeks_per_cycle
@onready var weekly_scheduling_end: String = SqlManager.weekly_scheduling_end
@onready var monthly_scheduling_start: String = SqlManager.monthly_scheduling_start
@onready var months_per_cycle: String = SqlManager.months_per_cycle
@onready var monthly_scheduling_end: String = SqlManager.monthly_scheduling_end

@onready var program_info_table: String = SqlManager.program_info_table
@onready var task_info_table: String = SqlManager.task_info_table
#@onready var dates_table: String = SqlManager.dates_table
@onready var user_info_table: String = SqlManager.user_info_table
@onready var monthly_tasks_table: String = SqlManager.monthly_tasks_table
@onready var weekly_tasks_table: String = SqlManager.weekly_tasks_table
@onready var daily_tasks_table: String = SqlManager.daily_tasks_table
#@onready var event_info_table: String = SqlManager.event_info_table
@onready var changelog_table: String = SqlManager.changelog_table

@onready var task_info_id: String = SqlManager.task_info_id
@onready var dates_id: String = SqlManager.dates_id
@onready var user_info_id: String = SqlManager.user_info_id
@onready var monthly_tasks_id: String = SqlManager.monthly_tasks_id
@onready var weekly_tasks_id: String = SqlManager.weekly_tasks_id
@onready var daily_tasks_id: String = SqlManager.daily_tasks_id
@onready var event_info_id: String = SqlManager.event_info_id

@onready var table_for_query = SqlManager.dates_table


var section_column_toggled: bool = true:
	set(value):
		section_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var scheduling_column_toggled: bool = true:
	set(value):
		scheduling_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var group_column_toggled: bool = true:
	set(value):
		group_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var description_column_toggled: bool = true:
	set(value):
		description_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var time_of_day_column_toggled: bool = true:
	set(value):
		time_of_day_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var priority_column_toggled: bool = true:
	set(value):
		priority_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var location_column_toggled: bool = true:
	set(value):
		location_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var assigned_to_column_toggled: bool = true:
	set(value):
		assigned_to_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var task_removal_column_toggled: bool = true:
	set(value):
		task_removal_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var year_column_toggled: bool = true:
	set(value):
		year_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var month_column_toggled: bool = true:
	set(value):
		month_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)
var checkboxes_column_toggled: bool = true:
	set(value):
		checkboxes_column_toggled = value
		TaskSignalBus._on_task_grid_column_toggled.emit()
		prints("section_column_toggled:", value)

var editing_locked: bool = false

var most_recent_query: Array[Dictionary]
var changed_existing_data: Dictionary
var changed_new_data: Array[Dictionary]
var active_changes: Array
var undone_changes: Array





func generate_existing_years_index() -> void:
	if SqlManager.database_name == "":
		return
	existing_years_index.clear()
	var existing_years: Array = SqlManager.get_unique_elements_from_column("daily_tasks, weekly_tasks, monthly_tasks", "daily_tasks.year, weekly_tasks.year, monthly_tasks.year")
	for unique_year in existing_years: #only needed if int needed
		existing_years_index.append(int(unique_year))


func form_task_grid_query() -> String:
	var new_query_parts: PackedStringArray
	new_query_parts.append(create_column_select_string())
	prints("")
	prints("Column Select String:")
	prints(new_query_parts[0])
	new_query_parts.append(create_from_statment_string(task_info_table))
	prints("From Statement String:")
	prints(new_query_parts[1])
	new_query_parts.append(create_join_statement_string())
	prints("Join Statement String:")
	prints(new_query_parts[2])
	new_query_parts.append(create_condition_string())
	prints("Condition String:")
	prints(new_query_parts[3])
	return " ".join(new_query_parts)


func create_from_statment_string(database_parameter: String) -> String:
	return "from " + database_parameter


func create_join_statement_string() -> String:
	var join_parts: Array
	var join_users_to_assigned_tasks: String = SqlManager.join_tables("left join", task_info_table, assigned_to, user_info_table, user_info_id)
	join_parts.append(join_users_to_assigned_tasks)
	if not checkboxes_column_toggled:
		return join_parts[0]
	var join_checkbox_to_tasks = SqlManager.join_tables("left join", task_info_table, task_info_id, get_section_task_table(), task)
	join_parts.append(join_checkbox_to_tasks)
	return " ".join(join_parts)


func get_section_task_table() -> String:
	match current_toggled_section:
		DataGlobal.Section.ALL, DataGlobal.Section.MONTHLY:
			return monthly_tasks_table
		DataGlobal.Section.WEEKLY:
			return weekly_tasks_table
		DataGlobal.Section.DAILY:
			return daily_tasks_table
		_:
			printerr("Error getting section task table!")
			return monthly_tasks_table


func create_column_select_string() -> String:
	var column_select: String = "select "
	var column_array: PackedStringArray = []
	gather_task_info_columns(column_array)
	gather_checkbox_info_columns(column_array)
	var joined_strings: String = ", ".join(column_array)
	column_select = column_select + joined_strings
	return column_select


func gather_task_info_columns(column_array_param: PackedStringArray) -> void:
	column_array_param.append(task_info_id)
	column_array_param.append(task_name)
	if section_column_toggled:
		column_array_param.append(section)
	if assigned_to_column_toggled:
		column_array_param.append(assigned_to)
	if location_column_toggled:
		column_array_param.append(location)
	if priority_column_toggled:
		column_array_param.append(priority)
	if time_of_day_column_toggled:
		column_array_param.append(time_of_day)
	if description_column_toggled:
		column_array_param.append(description)
	if group_column_toggled:
		column_array_param.append(task_group)
	if scheduling_column_toggled:
		match current_toggled_section:
			DataGlobal.Section.DAILY:
				column_array_param.append(daily_scheduling_start)
				column_array_param.append(days_per_cycle)
				column_array_param.append(daily_scheduling_end)
			DataGlobal.Section.WEEKLY:
				column_array_param.append(weekly_scheduling_start)
				column_array_param.append(weeks_per_cycle)
				column_array_param.append(weekly_scheduling_end)
			DataGlobal.Section.MONTHLY:
				column_array_param.append(monthly_scheduling_start)
				column_array_param.append(months_per_cycle)
				column_array_param.append(monthly_scheduling_end)


func gather_checkbox_info_columns(column_array_param: PackedStringArray) -> void:
	if not checkboxes_column_toggled:
		return
	#if month_column_toggled: #not needed, since month/year is editor setting?
		#column_array_param.append(month)
	#if year_column_toggled:
		#column_array_param.append(year)
	var current_section_info: Array
	match current_toggled_section:
		DataGlobal.Section.DAILY:
			column_array_param.append_array(SqlManager.daily_checkbox_addresses)
		DataGlobal.Section.WEEKLY:
			column_array_param.append_array(SqlManager.weekly_checkbox_addresses)
		DataGlobal.Section.MONTHLY:
			column_array_param.append_array(SqlManager.monthly_checkbox_addresses)


func create_condition_string() -> String:
	var condition_start: String = "where "
	var condition_array: PackedStringArray = [section_condition()]
	add_checkbox_conditions(condition_array)
	var condition_string = condition_start + join_condition_array(condition_array)
	return condition_string


func section_condition() -> String:
	var current_condition: String = section + " = '" + section_enum_strings[current_toggled_section] + "'"
	return current_condition


func add_checkbox_conditions(data_param: PackedStringArray) -> void:
	if not checkboxes_column_toggled:
		return
	data_param.append(year_condition())
	if current_toggled_month != DataGlobal.Month.ALL:
		data_param.append(month_condition())


func year_condition() -> String:
	var null_string: String = "' or " + year + " is null)"
	var current_condition: String = "(" + year + " = '" + str(current_toggled_year) + null_string
	return current_condition


func month_condition() -> String:
	var null_string: String = "' or " + month + " is null)"
	var current_condition: String = "(" + month + " = '" + month_enum_strings[current_toggled_month] + null_string
	return current_condition


func join_condition_array(strings_to_join: PackedStringArray) -> String:
	var joined_strings: String
	if strings_to_join.size() > 1:
		joined_strings = " and ".join(strings_to_join)
	else:
		joined_strings = strings_to_join[0]
	return joined_strings


func generate_dropdown_item_arrays() -> void:
	generate_task_group_dropdown_items()
	generate_location_dropdown_items()
	generate_users_dropdown_items()


func generate_task_group_dropdown_items() -> void:
	current_task_group_items = SqlManager.get_unique_elements_from_column(task_info_table, task_group)


func generate_location_dropdown_items() -> void:
	current_location_items.append("No Location")
	current_location_items.append_array(SqlManager.get_unique_elements_from_column(task_info_table, location))


func generate_users_dropdown_items() -> void:
	query_user_info()


#func create_task_data() -> Dictionary:
	#var new_task_data: Dictionary = {
		#"task_name":
	#}
	#TaskTrackingGlobal.group_column_toggled
	#TaskTrackingGlobal.assigned_to_column_toggled
	#TaskTrackingGlobal.scheduling_column_toggled
	#return new_task_data



"""
"task_group":
"assigned_to":
"daily_scheduling_start", "days_per_cycle", "daily_scheduling_end":
"weekly_scheduling_start", "weeks_per_cycle", "weekly_scheduling_end":
"monthly_scheduling_start", "months_per_cycle", "monthly_scheduling_end":


"task_info_id":
"year":
"description":
"location":

"time_of_day":
"priority":
"month":
"section":
"days_in_month":

"""

func submit_new_task(task_data: Dictionary) -> void:
	var new_id: int = changed_new_data.size()
	changed_new_data.append(task_data)
	TaskSignalBus._on_new_task_added.emit(new_id, task_data)
	TaskSignalBus._on_data_modified.emit()


func submit_change(cell_id, column_name: String, original_value, new_value) -> void:
	#prints("Change detected:", cell_id, column_name)
	if column_name == last_changed_column:
		#if typeof(cell_id) == typeof(last_changed_id):
		if cell_id == last_changed_id:
			active_changes.pop_back()
	active_changes.append([cell_id, column_name, original_value, new_value])
	match type_string(typeof(cell_id)):
		"String":
			var target_existing_data: Dictionary = changed_existing_data.get_or_add(cell_id, {})
			target_existing_data[column_name] = new_value
		"int":
			var target_new_data: Dictionary = changed_new_data[cell_id]
			target_new_data[column_name] = new_value
	last_changed_id = cell_id
	TaskSignalBus._on_data_modified.emit()


func undo_active_changes() -> Array:
	if active_changes.is_empty():
		prints("Nothing to Undo")
		return []
	var undo_action: Array = active_changes.pop_back()
	undone_changes.append(undo_action)
	return undo_action


func redo_active_changes() -> Array:
	if undone_changes.is_empty():
		prints("Nothing to Redo")
		return []
	var redo_action: Array = undone_changes.pop_back()
	active_changes.append(redo_action)
	return redo_action


func submit_changed_data_to_database() -> void:
	submit_existing_changed_data_to_database()
	submit_new_changed_data_to_database()


func submit_existing_changed_data_to_database() -> void:
	if changed_existing_data.is_empty():
		return
	var rows_to_update_count: int = changed_existing_data.size()
	var update_row_keys: Array = changed_existing_data.keys()
	var update_row_values: Array = changed_existing_data.values()
	for update_row_iteration in rows_to_update_count:
		var update_row_id: String = update_row_keys[update_row_iteration]
		var update_row_data: Dictionary = update_row_values[update_row_iteration]
		#var update_row_complete_data: Dictionary = {"task_info_id":update_row_id}
		#update_row_complete_data.merge(update_partial_data)
		var update_condition: String = "where " + task_info_id + " = " + update_row_id
		SqlManager.update_existing_data(task_info_table, update_condition, update_row_data)
	clear_changed_existing_data_with_failsafe()
	prints("Existing changed data submitted to database.")


func submit_new_changed_data_to_database() -> void:
	if changed_new_data.is_empty():
		return
	var rows_to_add_count: int = changed_new_data.size()
	for new_row_iteration in rows_to_add_count:
		var row_data: Dictionary = changed_new_data[new_row_iteration]
		SqlManager.add_new_data(task_info_table, row_data)
	clear_changed_new_data_with_failsafe()
	prints("New changed data submitted to database.")


func clear_changed_existing_data_with_failsafe() -> void:
	if SqlManager.active_database.error_message != "not an error":
		printerr("Error updating existing data: ", SqlManager.active_database.error_message)
		return
	changed_existing_data.clear()


func clear_changed_new_data_with_failsafe() -> void:
	if SqlManager.active_database.error_message != "not an error":
		printerr("Error adding new data: ", SqlManager.active_database.error_message)
		return
	changed_new_data.clear()


func section_scheduling_start() -> String:
	match current_toggled_section:
		DataGlobal.Section.DAILY:
			return "daily_scheduling_start"
		DataGlobal.Section.WEEKLY:
			return "weekly_scheduling_start"
		_:
			return "monthly_scheduling_start"


func section_units_per_cycle() -> String:
	match current_toggled_section:
		DataGlobal.Section.DAILY:
			return "days_per_cycle"
		DataGlobal.Section.WEEKLY:
			return "weeks_per_cycle"
		_:
			return "months_per_cycle"


func section_scheduling_end() -> String:
	match current_toggled_section:
		DataGlobal.Section.DAILY:
			return "daily_scheduling_end"
		DataGlobal.Section.WEEKLY:
			return "weekly_scheduling_end"
		_:
			return "monthly_scheduling_end"
