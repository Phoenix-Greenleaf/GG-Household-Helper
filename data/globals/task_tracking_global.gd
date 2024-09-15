extends Node

var active_data: TaskSetData #to be removed once old data import not needed

var active_settings: TaskSettingsData #still in the old format, for now

var data_folder = "user://task_tracker_data/"
var data_name: String = "task_tracking_" #to be removed once old data import not needed
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



# just around to load old data sets

func transer_old_data_to_database() -> void:
	var user_info_to_insert: Array = extract_user_info()
	SqlManager.add_data(user_info_table, user_info_to_insert)
	var sections_to_insert: Array = generate_sections(2024)
	SqlManager.add_data(sections_table, sections_to_insert)
	var task_info_to_insert: Array = extract_task_info()
	SqlManager.add_data(task_info_table, task_info_to_insert)



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
- store changes like the requests, so it directly replace loaded data




check all toggle options
create query
query data
use any matching "change" data
get and set column count
add elements
--header row
--info cells
--store reference data for edits and updates

on button edit:
	add changes to edit dictionary
	keep stored loaded value, to compare if changed back before saving


on task editor changes or reload:
	query for data
	load any applicable edits


clear changes button? undo and or redo changes button?
- changes menu, lists last undo, 



get stored update info
apply updates to db




search button, not on each little toggle


"""




"""

load data:
	- get list of availible databases
	- verify main tables exists in file
	- display name
	- query database - based on which data cells are active
	- load cells with data





loading cells:
	- bool toggles define the query and cell generation
	- create any needed id decoder dictionaries
	- initialize cells with data:
		- data for change-dictionary-creation
		- 
	- apply changes-dictionary if there is any changes
	- 
	- 
	- 


"""



"""
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



create database:
	- check new name vs existing db names, throw error if sames
	- create tables
	- create first user for unassigned entries
	- 
	- 


"""



"""
grid sync:
	- resize is useless for now
	- tie signal triggers to actions that would cause resize changes:
		- header button presses
		- data input / changes
	- unsure where to resize:
		- the grid cell
		- the size of the object in the cell
	- scroll seems ok so far


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


var section_column_toggled: bool = true
var month_column_toggled: bool = true
var year_column_toggled: bool = true
var checkboxes_column_toggled: bool = true
var scheduling_column_toggled: bool = true
var group_column_toggled: bool = true
var description_column_toggled: bool = true
var time_of_day_column_toggled: bool = true
var priority_column_toggled: bool = true
var location_column_toggled: bool = true
var task_removal_column_toggled: bool = true
#var assigned_to_column_toggled: bool = true
#var completed_by_column_toggled: bool = true
#var last_completed_column_toggled: bool = true


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
	if section_column_toggled:
		column_array.append(section)
	if month_column_toggled:
		column_array.append(month)
	if year_column_toggled:
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
		if current_toggled_section == DataGlobal.Section.DAILY:
			column_array.append(daily_scheduling_start)
			column_array.append(days_per_cycle)
			column_array.append(daily_scheduling_end)
		if current_toggled_section == DataGlobal.Section.WEEKLY:
			column_array.append(weekly_scheduling_start)
			column_array.append(weeks_per_cycle)
			column_array.append(weekly_scheduling_end)
		if current_toggled_section == DataGlobal.Section.MONTHLY:
			column_array.append(monthly_scheduling_start)
			column_array.append(months_per_cycle)
			column_array.append(monthly_scheduling_end)
	var joined_strings: String = ", ".join(column_array)
	column_select = column_select + joined_strings
	return column_select


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


func _on_description_button_pressed(cell_param: Button) -> void:
	pass
