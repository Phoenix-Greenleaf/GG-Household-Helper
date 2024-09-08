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
#func generate_task_set_filepath(task_set_name: String, task_set_year: int) -> String:
	#var task_set_save_name: String = (data_name + task_set_name
		#+ "_" + str(task_set_year)
	#)
	#var task_set_filepath: String = DataGlobal.generate_filepath(task_set_save_name,
		#DataGlobal.FileType.TASK_TRACKING_DATA
	#)
	#return task_set_filepath
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
#func load_data_task_set(task_set_name: String, task_set_year: int) -> void:
	#active_data = null #does this have any impact?
	#active_data = TaskSetData.new()
	#var task_set_filepath := generate_task_set_filepath(task_set_name, task_set_year)
	#prints("task set filepath to load:", task_set_filepath)
	#var json_data = JsonSaveManager.load_data(task_set_filepath)
	#active_data.import_json_to_resource(json_data)
	#prints("load_data_task_set complete!")
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



var id := "id"
var name_ := "name"
var color_ := "color"
var status := "status"
var completed_by := "completed_by"
var last_completed := "last_completed"
var task := "task"
var group := "group"
var assigned_to := "assigned_to"
var description := "description"
var time_of_day := "time_of_day"
var priority := "priority"
var location := "location"
var year := "year"
var month := "month"
var section := "section"
var daily_scheduling_start := "daily_scheduling_start"
var days_per_cycle := "days_per_cycle"
var daily_scheduling_end := "daily_scheduling_end"
var weekly_scheduling_start := "weekly_scheduling_start"
var weeks_per_cycle := "weeks_per_cycle"
var weekly_scheduling_end := "weekly_scheduling_end"
var monthly_scheduling_start := "monthly_scheduling_start"
var months_per_cycle := "months_per_cycle"
var monthly_scheduling_end := "monthly_scheduling_end"








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

var task_info_id: String = SqlManager.table_id(SqlManager.task_info_table)
var sections_id: String = SqlManager.table_id(SqlManager.sections_table)
var user_info_id: String = SqlManager.table_id(SqlManager.user_info_table)
var monthly_tasks_id: String = SqlManager.table_id(SqlManager.monthly_tasks_table)
var weekly_tasks_id: String = SqlManager.table_id(SqlManager.weekly_tasks_table)
var daily_tasks_id: String = SqlManager.table_id(SqlManager.daily_tasks_table)
var event_info_id: String = SqlManager.table_id(SqlManager.event_info_table)





var table_for_query = SqlManager.sections_table

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
		column_array.append(group)
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


func join_string() -> String:
	var join_string: String = ""
	
	return join_string


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
