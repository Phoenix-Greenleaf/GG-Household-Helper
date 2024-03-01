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

enum CheckboxToggle {
	APPLY,
	INSPECT
}

enum FileType {
	MAIN_SETTINGS,
	TASK_TRACKING_DATA,
	TASK_TRACKING_SETTINGS,
	}

var active_settings_main: MainSettingsData
var active_data_task_tracking: TaskSetData
var active_settings_task_tracking: TaskSettingsData

var json_extension: String = ".json"
var user_folder: String = "user://"
var settings_folder = "user://settings/"
var task_tracker_folder = "user://task_tracker_data/"

var name_main_settings: String = "main_settings"
var name_task_tracking_data: String = "task_tracking_"
var name_task_tracking_settings: String = "task_tracking_settings"

var filepath_main_settings: String = settings_folder + name_main_settings + json_extension
var filepath_task_tracking_settings: String = (settings_folder
	+ name_task_tracking_settings + json_extension
)

var default_profile: Array = ["No Profile", Color.WHITE]
var month_strings: Array[String]

var task_tracking_editor_modes: Dictionary = {"Checkbox": 0, "Info": 1}
var task_tracking_current_checkbox_state: Checkbox = Checkbox.ACTIVE
var task_tracking_current_checkbox_profile: Array = default_profile
var task_tracking_focus_checkbox_state: int
var task_tracking_focus_checkbox_profile: Array
var task_tracking_current_toggled_section: Section = Section.YEARLY
var task_tracking_current_toggled_month: Month = Month.JANUARY
var task_tracking_current_toggled_editor_mode: int = task_tracking_editor_modes["Checkbox"]
var task_tracking_current_toggled_checkbox_mode: CheckboxToggle = CheckboxToggle.INSPECT
var task_tracking_task_group_dropdown_items: Array 
var task_tracking_user_profiles_dropdown_items: Array

var main_settings_active: bool = false


# general use functions


func _init() -> void:
	var month_keys: Array = Month.keys()
	for month in month_keys:
		month_strings.append(month.capitalize())


func _ready() -> void:
	connect_signals()
	load_settings_main()
	DisplayServer.window_set_min_size(Vector2i(500, 500))


func connect_signals() -> void:
	SignalBus._on_task_set_data_active_data_switched.connect(load_settings_main)
	SignalBus._on_task_editor_profile_selection_changed.connect(
		task_editor_update_user_profile_dropdown_items
	) #can we directly call?


func button_based_message(target: Node, message: String, time: int = 2,
	interfering_messages: Array = []
) -> void:
	if target.text == message:
		prints("Button message already active")
		return
	if interfering_messages.size() > 0:
		for cross_chatter in interfering_messages:
			if target.text == cross_chatter:
				prints("Not today pal")
				return
	var original_text = target.text
	target.text = message
	var timer := Timer.new()
	target.add_child(timer)
	timer.wait_time = time
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()
	target.text = original_text


func days_in_month_finder(month_in_question: String, year_in_question) -> int:
	match month_in_question: 
		"February":
			var leap_year_check = year_in_question % 4
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


func generate_filepath(save_name_parameter: String, current_file_type: FileType) -> String:
	var save_filepath: String
	match current_file_type:
		FileType.TASK_TRACKING_DATA:
			save_filepath = task_tracker_folder + save_name_parameter + json_extension
			return save_filepath
		_:
			prints("Generate_filepath error for FileType:", current_file_type)
			return "ERROR"


func directory_check(directory_to_check) -> void:
	if not DirAccess.dir_exists_absolute(directory_to_check):
		DirAccess.make_dir_absolute(directory_to_check)
		prints("Created directory:", directory_to_check)
	else:
		prints("Directory Exists")


func theme_variation_issue_workaround(correction_target: Node, theme_parameter: String) -> void:
	match correction_target.get_class():
		"SpinBox":
			var internal_line_edit: LineEdit = correction_target.get_line_edit()
			internal_line_edit.set_theme_type_variation(theme_parameter)
		"MenuButton", "OptionButton":
			var internal_popup_menu: PopupMenu = correction_target.get_popup()
			internal_popup_menu.set_theme_type_variation(theme_parameter)
		_:
			prints("theme_variation_issue_workaround cannot match class:",
				correction_target.get_class()
			)


# main settings


func create_settings_main() -> void:
	active_settings_main = MainSettingsData.new()
	active_settings_main.reset_settings_all_main()
	prints("New main settings data created")
	save_settings_main()


func save_settings_main() -> void:
	var json_data = active_settings_main.export_json_from_resouce()
	JsonSaveManager.save_data(filepath_main_settings, json_data)
	prints("Main settings data saved")


func load_settings_main() -> void:
	directory_check(settings_folder)
	if active_settings_main:
		prints("Main settings exist")
		return
	if not FileAccess.file_exists(filepath_main_settings):
		prints("Creating new main settings")
		create_settings_main()
		return
	prints("Loading main settings")
	active_settings_main = MainSettingsData.new()
	var json_data = JsonSaveManager.load_data(filepath_main_settings)
	active_settings_main.import_json_to_resource(json_data)


# task tracking settings


func create_settings_task_tracking() -> void:
	active_settings_task_tracking = TaskSettingsData.new()
	active_settings_task_tracking.reset_settings()
	prints("New task tracking settings data created")
	save_settings_task_tracking()


func save_settings_task_tracking() -> void:
	var json_data = active_settings_task_tracking.export_json_from_resouce()
	JsonSaveManager.save_data(filepath_task_tracking_settings, json_data)


func load_settings_task_tracking() -> void:
	if active_settings_task_tracking:
		prints("Task tracking settings exist")
		return
	if not FileAccess.file_exists(filepath_task_tracking_settings):
		prints("Creating new task tracking settings")
		create_settings_task_tracking()
		return
	prints("Loading task tracking settings")
	active_settings_task_tracking = TaskSettingsData.new()
	var json_data = JsonSaveManager.load_data(filepath_task_tracking_settings)
	active_settings_task_tracking.import_json_to_resource(json_data)


# data manager


func generate_task_set_filepath(task_set_name: String, task_set_year: int) -> String:
	var task_set_save_name: String = (name_task_tracking_data + task_set_name
		+ "_" + str(task_set_year)
	)
	var task_set_filepath: String = generate_filepath(task_set_save_name,
		FileType.TASK_TRACKING_DATA
	)
	return task_set_filepath


func create_data_task_set(task_set_name: String, task_set_year: int) -> void:
	var task_set_data := TaskSetData.new()
	task_set_data.task_set_title = task_set_name
	task_set_data.task_set_year = task_set_year
	directory_check(task_tracker_folder)
	active_data_task_tracking = task_set_data
	save_data_task_set()
	task_set_data_reloaded()


func clone_task_set_data(task_set_name: String, task_set_year: int) -> void:
	var task_set_data: TaskSetData = DataGlobal.active_data_task_tracking.duplicate(true)
	task_set_data.task_set_title = task_set_name
	task_set_data.task_set_year = task_set_year
	active_data_task_tracking = task_set_data
	task_set_data_reloaded()
	save_data_task_set()


func save_data_task_set() -> void:
	if not active_data_task_tracking:
		printerr("Nothing to save")
		return
	var task_set_name = active_data_task_tracking.task_set_title
	var task_set_year = active_data_task_tracking.task_set_year
	var task_set_filepath := generate_task_set_filepath(task_set_name, task_set_year)
	var json_for_save: Dictionary = active_data_task_tracking.export_json_from_resouce()
	JsonSaveManager.save_data(task_set_filepath, json_for_save)


func load_data_task_set(task_set_name: String, task_set_year: int) -> void:
	active_data_task_tracking = null #does this have any impact?
	active_data_task_tracking = TaskSetData.new()
	var task_set_filepath := generate_task_set_filepath(task_set_name, task_set_year)
	prints("task set filepath to load:", task_set_filepath)
	var json_data = JsonSaveManager.load_data(task_set_filepath)
	active_data_task_tracking.import_json_to_resource(json_data)


func task_set_data_reloaded() -> void:
	SignalBus._on_task_set_data_active_data_switched.emit()
	SignalBus._on_task_editor_profile_selection_changed.emit()
	SignalBus._on_task_editor_section_changed.emit()


# task tracking editor


func get_active_task_set_info() -> Array:
	var name_info := active_data_task_tracking.task_set_title
	var year_info := active_data_task_tracking.task_set_year
	return [name_info, year_info]


func get_task_sets_info() -> Array:
	var task_sets_info := []
	var existing_files = DirAccess.get_files_at(task_tracker_folder)
	for file in existing_files:
		var task_set_filepath = task_tracker_folder + file
		var json_import = JsonSaveManager.load_data(task_set_filepath)
		var file_resource = TaskSetData.new()
		file_resource.import_json_to_resource(json_import)
		var file_info = [file_resource.task_set_title, file_resource.task_set_year]
		task_sets_info.append(file_info)
	return task_sets_info


func task_editor_update_user_profile_dropdown_items() -> void:
	prints("Updating user profile dropdown.")
	task_tracking_user_profiles_dropdown_items.clear()
	task_tracking_user_profiles_dropdown_items.append(default_profile)
	for profile in active_data_task_tracking.user_profiles:
		task_tracking_user_profiles_dropdown_items.append(profile)
	SignalBus._on_task_editor_assigned_user_dropdown_items_changed.emit()


func task_editor_update_task_group_dropdown_items() -> void:
	task_tracking_task_group_dropdown_items.clear()
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY:
			for task_iteration in active_data_task_tracking.spreadsheet_year_data:
				task_editor_scan_task_for_group(task_iteration)
		DataGlobal.Section.MONTHLY:
			for task_iteration in active_data_task_tracking.spreadsheet_month_data:
				task_editor_scan_task_for_group(task_iteration)
		DataGlobal.Section.WEEKLY:
			for task_iteration in active_data_task_tracking.spreadsheet_week_data:
				task_editor_scan_task_for_group(task_iteration)
		DataGlobal.Section.DAILY:
			for task_iteration in active_data_task_tracking.spreadsheet_day_data:
				task_editor_scan_task_for_group(task_iteration)
	task_tracking_task_group_dropdown_items.sort()
	task_tracking_task_group_dropdown_items.insert(0, "None")
	SignalBus._on_task_editor_group_dropdown_items_changed.emit()


func task_editor_scan_task_for_group(scan_task: TaskData) -> void:
	if scan_task.group == "None":
		return
	if task_tracking_task_group_dropdown_items.has(scan_task.group):
		return
	task_tracking_task_group_dropdown_items.append(scan_task.group)


