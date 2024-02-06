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
var active_data_task_tracking: TaskSpreadsheetData
var active_settings_task_tracking: TaskSettingsData

var json_extension: String = ".json"
var user_folder: String = "user://"
var settings_folder = "user://settings/"
var task_tracker_folder = "user://task_tracker_data/"

var name_main_settings: String = "main_settings"
var name_task_tracking_data: String = "task_tracking_"
var name_task_tracking_settings: String = "task_tracking_settings"

var filepath_main_settings: String = settings_folder + name_main_settings + json_extension
var filepath_task_tracking_settings: String = settings_folder + name_task_tracking_settings + json_extension

var default_profile: Array = ["No Profile", Color.WHITE]
var month_strings: Array[String]

var task_tracking_editor_modes: Dictionary = {"Checkbox": 0, "Info": 1}
var task_tracking_current_checkbox_state: int = Checkbox.ACTIVE
var task_tracking_current_checkbox_profile: Array = default_profile
var task_tracking_focus_checkbox_state: int
var task_tracking_focus_checkbox_profile: Array
var task_tracking_current_toggled_section: Section = Section.YEARLY
var task_tracking_current_toggled_month: Month = Month.JANUARY
var task_tracking_current_toggled_editor_mode: int = task_tracking_editor_modes["Checkbox"]
var task_tracking_current_toggled_checkbox_mode: CheckboxToggle = CheckboxToggle.INSPECT



func _init() -> void:
	var month_keys: Array = Month.keys()
	for month in month_keys:
		month_strings.append(month.capitalize())


func _ready() -> void:
	SignalBus._on_settings_changed.connect(save_settings_main)
	SignalBus._on_current_tasksheet_data_changed.connect(load_settings_main)
	load_settings_main()
	DisplayServer.window_set_min_size(Vector2i(500, 500))


func button_based_message(target: Node, message: String, time: int = 2, interfering_messages: Array = []) -> void:
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


func create_settings_main() -> void:
	active_settings_main = MainSettingsData.new()
	active_settings_main.reset_settings()
	prints("New main settings data created")
	save_settings_main()


func save_settings_main() -> void:
	var json_data = active_settings_main.export_json_from_resouce()
	JsonSaveManager.save_data(filepath_main_settings, json_data)
	prints("Main settings data saved")


func load_settings_main() -> void:
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
	SignalBus.remote_task_settings_reload.emit()


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
	SignalBus.remote_task_settings_reload.emit()


