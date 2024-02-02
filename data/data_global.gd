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


var default_profile: Array = ["No Profile", Color(1, 1, 1)]

var editor_modes: Dictionary = {"Checkbox": 0, "Info": 1}
var month_strings: Array[String]

var current_tasksheet_data: TaskSpreadsheetData
var settings_file: SettingsData

var current_checkbox_state: int = Checkbox.ACTIVE
var current_checkbox_profile: Array = default_profile
var focus_checkbox_state: int
var focus_checkbox_profile: Array

var current_toggled_section: Section = Section.YEARLY
var current_toggled_month: Month = Month.JANUARY
var current_toggled_editor_mode: int = editor_modes["Checkbox"]
var current_toggled_checkbox_mode: CheckboxToggle = CheckboxToggle.INSPECT

#var user_folder := "user://"
var settings_save_name := "Settings"
@onready var settings_filepath: String = JsonSaveManager.generate_filepath(settings_save_name, JsonSaveManager.FileType.SETTINGS)
@onready var settings_filetype: JsonSaveManager.FileType = JsonSaveManager.FileType.SETTINGS
#var json_extension := ".json"
#var settings_filepath: String = user_folder + settings_save_name + json_extension

func _init() -> void:
	var month_keys: Array = Month.keys()
	for month in month_keys:
		month_strings.append(month.capitalize())


func _ready() -> void:
	prints("DataGlobal ready function")
	SignalBus._on_settings_changed.connect(save_settings)
	SignalBus._on_current_tasksheet_data_changed.connect(load_settings)
	load_settings()
	DisplayServer.window_set_min_size(Vector2i(500, 500))


func button_based_message(target: Node, message: String, time: int = 2) -> void:
#	prints("Sending:", message, "to", target.name, "to replace:", target.text)
	if target.text == message:
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


func load_settings() -> void:
	if settings_file:
		prints("Settings exist")
		return
	if not FileAccess.file_exists(settings_filepath):
		prints("Creating new settings")
		create_settings()
		return
	prints("Loading settings")
	settings_file = SettingsData.new()
	var raw_data = JsonSaveManager.load_data(settings_save_name, settings_filetype)
	settings_file.import_json_to_resource(raw_data)
	SignalBus.remote_task_settings_reload.emit()


func create_settings() -> void:
	settings_file = SettingsData.new()
	settings_file.reset_all_default_settings()
	prints("New settings data created")
	save_settings()


func save_settings() -> void:
	var json_data = settings_file.export_json_from_resouce()
	JsonSaveManager.save_data(settings_save_name, settings_filetype, json_data)


