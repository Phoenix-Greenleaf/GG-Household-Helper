extends Node

var active_data: TaskSetData
var active_settings: TaskSettingsData

var data_folder = "user://task_tracker_data/"
var data_name: String = "task_tracking_"
var settings_name: String = "task_tracking_settings"

var filepath_task_tracking_settings: String = (DataGlobal.settings_folder
	+ settings_name + DataGlobal.json_extension
)


@onready var current_checkbox_profile: Array = default_profile
var current_checkbox_state: Checkbox = Checkbox.ACTIVE
var focus_checkbox_state: int
var focus_checkbox_profile: Array
var current_toggled_section: DataGlobal.Section = DataGlobal.Section.MONTHLY
var current_toggled_month: DataGlobal.Month = DataGlobal.Month.JANUARY
var current_toggled_year: int = 1990
var current_toggled_checkbox_mode: CheckboxToggle = CheckboxToggle.INSPECT
var task_group_dropdown_items: Array 
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




func transer_old_data_to_database() -> void:
	var user_info_to_insert: Array = extract_user_info()
	SqlManager.add_data(user_info_table, user_info_to_insert)
	#prints(user_info_to_insert)
	
	var sections_to_insert: Array = generate_sections(2024)
	SqlManager.add_data(sections_table, sections_to_insert)
	#prints("")
	#prints("Sections to Insert")
	#prints(sections_to_insert)
	
	var task_info_to_insert: Array = extract_task_info()
	SqlManager.add_data(task_info_table, task_info_to_insert)
	#prints(task_info_to_insert)


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


func transfer_process_new_section() -> void:
	pass


func transfer_create_row_dictionary() -> void:
	pass


func transfer_create_rows_array() -> void:
	pass


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
	#prints("")
	#prints("User Info Extracted")
	#prints(all_user_info_data_rows)
	#prints("")
	return all_user_info_data_rows



func extract_task_info() -> Array:
	var all_task_info_data_rows: Array
	var current_users: Dictionary = query_user_info()
	var gathered_task_info: Array = extract_old_sections()
	for task_entry: TaskData in gathered_task_info:
		var name_assigned_to: String = task_entry.assigned_user[0]
		if name_assigned_to == "No Profile":
			name_assigned_to = SqlManager.unassigned_user_text
		var task_info_data_row: Dictionary = {
			task : task_entry.name,
			assigned_to : current_users[name_assigned_to],
			task_group : task_entry.group,
		}
		all_task_info_data_rows.append(task_info_data_row)
	return all_task_info_data_rows
			#assigned_to : ,
			#description : ,
			#time_of_day : ,
			#priority : ,
			#location : ,
			#last_completed : ,
			#daily_scheduling_start : ,
			#days_per_cycle : ,
			#daily_scheduling_end : ,
			#weekly_scheduling_start : ,
			#weeks_per_cycle : ,
			#weekly_scheduling_end : ,
			#monthly_scheduling_start : ,
			#months_per_cycle : ,
			#monthly_scheduling_end : ,


func query_user_info() -> Dictionary:
	var raw_user_query: Array = SqlManager.query_data(
		"select user_info_id, name from user_info"
	)
	var user_query: Dictionary
	for user_iteration in raw_user_query:
		user_query[user_iteration[name_]] = user_iteration[user_info_id]
	prints("")
	prints("User Query")
	prints(user_query)
	prints("")
	return user_query


func generate_sections(year_parameter: int) -> Array:
	var year_string := str(year_parameter)
	var all_section_data_rows: Array
	var monthly_section_row: Dictionary = {
		year : year_string,
		month : "all",
		section : "all",
	}
	all_section_data_rows.append(monthly_section_row)
	for month_iteration in SqlManager.month_strings:
		for section_iteration in SqlManager.section_strings:
			if month_iteration == "all" or section_iteration == "all" or section_iteration == "monthly":
				continue
			var section_data_row: Dictionary = {
				year : year_string,
				month : month_iteration,
				section : section_iteration,
			}
			all_section_data_rows.append(section_data_row)
	return all_section_data_rows


#func query_sections() -> Dictionary:
	#var raw_section_query: Array = SqlManager.query_data(
		#"select sections_id, month, section from sections"
	#)
	#var section_query: Dictionary
	#for section_string in SqlManager.section_strings:
		#section_query[section_string] = dictionary_of_month_strings()
	#for section_iteration in raw_section_query:
		#var iteration_section: String = section_iteration[section]
		#var iteration_month: String = section_iteration[month]
		#var section_address: Array = section_query[iteration_section][iteration_month]
		#section_address.append(section_iteration[sections_id])
	#prints("")
	#prints("Section Query")
	#prints(section_query)
	#prints("")
	#return section_query

#func dictionary_of_month_strings() -> Dictionary:
	#var month_strings: Dictionary
	#for month_iteration in SqlManager.month_strings:
		#month_strings[month_iteration] = []
	#return month_strings



#
#
##section_tasks(section_parameter: DataGlobal.Section) -> void:
	#var event_count: int = 0
	#var event_units: String = ""
	#var event_section_title: String = ""
	#}
	#match section_parameter:
		#DataGlobal.Section.MONTHLY:
			#event_count = 12
			#event_units = "month"
			#event_section_title = monthly_tasks_table
		#DataGlobal.Section.WEEKLY:
			#event_count = 5
			#event_units = "week"
			#event_section_title = weekly_tasks_table
		#DataGlobal.Section.DAILY:
			#event_count = 31
			#event_units = "day"
			#event_section_title = daily_tasks_table
	#data_columns = section_tasks_standard_data()
	#add_columns_section_event_info(event_count, event_units, data_columns)
	#create_new_table_with_primary_id(event_section_title, data_columns)
#
#
##section_tasks_standard_data() -> Dictionary:
	#var standard_data: Dictionary = {
		#task : {data_type:int_, foreign_key:table_column_address(task_info_table, task_info_id)},
		#section : {data_type:int_, foreign_key:table_column_address(sections_table, sections_id)},
	#}
	#return standard_data
#




"""

--reformat and redirect info
-only care about:
	-task
	-section

tables:
	-sections
	-task_info
	-user info

-daily_tasks
-weekly_tasks
-monthly_tasks
-event_info




submit changes to db
check db in external editor


"""

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



#func _ready() -> void:
	#connect_signals()


#func connect_signals() -> void:
	#TaskSignalBus._on_profile_selection_changed.connect(
		#task_editor_update_user_profile_dropdown_items
	#)


#
#func create_settings_task_tracking() -> void:
	#active_settings = TaskSettingsData.new()
	#active_settings.reset_settings()
	#prints("New task tracking settings data created")
	#save_settings_task_tracking()
#
#
#func save_settings_task_tracking() -> void:
	#var json_data = active_settings.export_json_from_resouce()
	#JsonSaveManager.save_data(filepath_task_tracking_settings, json_data)
#
#
#func load_settings_task_tracking() -> void:
	#if active_settings:
		#prints("Task tracking settings exist")
		#return
	#if not FileAccess.file_exists(filepath_task_tracking_settings):
		#prints("Creating new task tracking settings")
		#create_settings_task_tracking()
		#return
	#prints("Loading task tracking settings")
	#active_settings = TaskSettingsData.new()
	#var json_data = JsonSaveManager.load_data(filepath_task_tracking_settings)
	#active_settings.import_json_to_resource(json_data)
#
#
## data manager
#
#
#func create_data_task_set(task_set_name: String, task_set_year: int) -> void:
	#var task_set_data := TaskSetData.new()
	#task_set_data.task_set_title = task_set_name
	#task_set_data.task_set_year = task_set_year
	#DataGlobal.directory_check(data_folder)
	#active_data = task_set_data
	#save_data_task_set()
	#task_set_data_reloaded()
#
#
#func clone_task_set_data(task_set_name: String, task_set_year: int) -> void:
	#var task_set_data: TaskSetData = DataGlobal.active_data.duplicate(true)
	#task_set_data.task_set_title = task_set_name
	#task_set_data.task_set_year = task_set_year
	#active_data = task_set_data
	#task_set_data_reloaded()
	#save_data_task_set()
#
#
#func save_data_task_set() -> void:
	#if not active_data:
		#printerr("Nothing to save")
		#return
	#var task_set_name = active_data.task_set_title
	#var task_set_year = active_data.task_set_year
	#var task_set_filepath := generate_task_set_filepath(task_set_name, task_set_year)
	#var json_for_save: Dictionary = active_data.export_json_from_resouce()
	#JsonSaveManager.save_data(task_set_filepath, json_for_save)
#
#
#
#
#func task_set_data_reloaded() -> void:
	#TaskSignalBus._on_active_data_set_switched.emit()
	#TaskSignalBus._on_profile_selection_changed.emit()
	#TaskSignalBus._on_section_changed.emit()
#
#
## task tracking editor
#
#
#func get_active_task_set_info() -> Array:
	#var name_info := active_data.task_set_title
	#var year_info := active_data.task_set_year
	#return [name_info, year_info]
#
#
#func get_task_sets_info() -> Array:
	#var task_sets_info := []
	#var existing_files = DirAccess.get_files_at(data_folder)
	#for file in existing_files:
		#var task_set_filepath = data_folder + file
		#var json_import = JsonSaveManager.load_data(task_set_filepath)
		#var file_resource = TaskSetData.new()
		#file_resource.import_json_to_resource(json_import)
		#var file_info = [file_resource.task_set_title, file_resource.task_set_year]
		#task_sets_info.append(file_info)
	#return task_sets_info
#
#
#func task_editor_update_user_profile_dropdown_items() -> void:
	#prints("Updating user profile dropdown.")
	#user_profiles_dropdown_items.clear()
	#user_profiles_dropdown_items.append(default_profile)
	#for profile in active_data.user_profiles:
		#user_profiles_dropdown_items.append(profile)
	#TaskSignalBus._on_assigned_user_dropdown_items_changed.emit()
#
#
#func task_editor_update_task_group_dropdown_items() -> void:
	#task_group_dropdown_items.clear()
	#match TaskTrackingGlobal.current_toggled_section:
		#DataGlobal.Section.YEARLY:
			#for task_iteration in active_data.spreadsheet_year_data:
				#task_editor_scan_task_for_group(task_iteration)
		#DataGlobal.Section.MONTHLY:
			#for task_iteration in active_data.spreadsheet_month_data:
				#task_editor_scan_task_for_group(task_iteration)
		#DataGlobal.Section.WEEKLY:
			#for task_iteration in active_data.spreadsheet_week_data:
				#task_editor_scan_task_for_group(task_iteration)
		#DataGlobal.Section.DAILY:
			#for task_iteration in active_data.spreadsheet_day_data:
				#task_editor_scan_task_for_group(task_iteration)
	#task_group_dropdown_items.sort()
	#task_group_dropdown_items.insert(0, "None")
	#TaskSignalBus._on_group_dropdown_items_changed.emit()
#
#
#func task_editor_scan_task_for_group(scan_task: TaskData) -> void:
	#if scan_task.group == "None":
		#return
	#if task_group_dropdown_items.has(scan_task.group):
		#return
	#task_group_dropdown_items.append(scan_task.group)








"""
sql science

task - forever on
(order)

all month toggle
schedule-incompatibility warning (mixing sections)


=== edit logs ===
- buttons store referance info and call functio when pressed
- new edits overwrite old edits
- any data changes, load data then apply edits
- saving commits changes to database, epties logs
- save protection based on change log size == 0
- undo and redo changes?





query data
add any data changes
get and set column count
add elements
--header row
--info cells
--store reference data for edits and updates


search button, not on each little toggle


"""
var month_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Month)
var section_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Section)
var time_of_day_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.TimeOfDay)
var priority_enum_strings: Array = DataGlobal.enum_to_strings(DataGlobal.Priority)



@onready var id: String = SqlManager.id
@onready var name_: String = SqlManager.name_
@onready var color_: String = SqlManager.color_
@onready var status: String = SqlManager.status
@onready var completed_by: String = SqlManager.completed_by
@onready var last_completed: String = SqlManager.last_completed
@onready var task: String = SqlManager.task
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








var checkboxes_column_toggled: bool = true
var scheduling_column_toggled: bool = true
#var completed_by_column_toggled: bool = true
#var last_completed_column_toggled: bool = true
var group_column_toggled: bool = true
#var assigned_to_column_toggled: bool = true
var description_column_toggled: bool = true
var time_of_day_column_toggled: bool = true
var priority_column_toggled: bool = true
var location_column_toggled: bool = true
#var task_removal_column_toggled: bool = true


@onready var task_info_table: String = SqlManager.task_info_table
@onready var sections_table: String = SqlManager.sections_table
@onready var user_info_table: String = SqlManager.user_info_table
@onready var monthly_tasks_table: String = SqlManager.monthly_tasks_table
@onready var weekly_tasks_table: String = SqlManager.weekly_tasks_table
@onready var daily_tasks_table: String = SqlManager.daily_tasks_table
@onready var event_info_table: String = SqlManager.event_info_table

@onready var task_info_id: String = SqlManager.task_info_id
@onready var sections_id: String = SqlManager.sections_id
@onready var user_info_id: String = SqlManager.user_info_id
@onready var monthly_tasks_id: String = SqlManager.monthly_tasks_id
@onready var weekly_tasks_id: String = SqlManager.weekly_tasks_id
@onready var daily_tasks_id: String = SqlManager.daily_tasks_id
@onready var event_info_id: String = SqlManager.event_info_id





@onready var table_for_query = SqlManager.sections_table

func form_query() -> String:
	var new_query: String = ""
	
	return new_query


func create_column_select_string() -> String:
	var column_select: String = "select "
	var column_array: PackedStringArray = []
	column_array.append(task_info_id)
	column_array.append(task)
	column_array.append(section)
	column_array.append(month)
	column_array.append(year)
	if location_column_toggled:
		column_array.append(location)
	if priority_column_toggled:
		column_array.append(priority)
	if time_of_day_column_toggled:
		column_array.append(time_of_day)
	if description_column_toggled:
		column_array.append(description)
	if group_column_toggled:
		column_array.append(task_group)
	if checkboxes_column_toggled:
		column_array.append(assigned_to)
		column_array.append(completed_by)
		column_array.append(name_)
	if scheduling_column_toggled:
		if current_toggled_section == DataGlobal.Section.ALL or current_toggled_section == DataGlobal.Section.DAILY:
			column_array.append(daily_scheduling_start)
			column_array.append(days_per_cycle)
			column_array.append(daily_scheduling_end)
		if current_toggled_section == DataGlobal.Section.ALL or current_toggled_section == DataGlobal.Section.WEEKLY:
			column_array.append(weekly_scheduling_start)
			column_array.append(weeks_per_cycle)
			column_array.append(weekly_scheduling_end)
		if current_toggled_section == DataGlobal.Section.ALL or current_toggled_section == DataGlobal.Section.MONTHLY:
			column_array.append(monthly_scheduling_start)
			column_array.append(months_per_cycle)
			column_array.append(monthly_scheduling_end)
	var joined_strings: String = ", ".join(column_array)
	column_select = column_select + joined_strings
	return column_select


#func add_string(original_parameter: String, adding_parameter: String) -> String:
	#var new_string: String = original_parameter + adding_parameter
	#return new_string


#func join_string() -> String:
	#var join_string: String = ""
	#
	#
#task_info_table
##sections_table
#user_info_table
#monthly_tasks_table
#weekly_tasks_table
#daily_tasks_table
#event_info_table
	#
	#return join_string


func create_condition_string() -> String:
	var condition_string: String = "where "
	var condition_array: PackedStringArray = []
	condition_array.append(year_condition())
	condition_array.append(section_condition())
	if current_toggled_month != DataGlobal.Month.ALL:
		condition_array.append(month_condition())
	var joined_strings: String = " and ".join(condition_array)
	condition_string = condition_string + joined_strings
	return condition_string


func year_condition() -> String:
	var current_condition: String = year + " = " + str(current_toggled_year)
	return current_condition


func month_condition() -> String:
	var current_condition: String = month + " = " + month_enum_strings[current_toggled_month]
	return current_condition


func section_condition() -> String:
	var current_condition: String = section + " = " + section_enum_strings[current_toggled_section]
	return current_condition

"""
order by?
group by?
"""



"""
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
	- 
	- 
	- 


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


load data:
	- get list of availible databases
	- verify main tables exists in file
	- display name
	- query database - based on which data cells are active
	- load cells with data

create database:
	- check new name vs existing db names, throw error if sames
	- create tables
	- 
	- 
	- 


"""
