extends Node



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


enum FileType {
	MAIN_SETTINGS,
	TASK_TRACKING_DATA,
	TASK_TRACKING_SETTINGS,
	}





var themes_initiated: bool = false

var json_extension: String = ".json"
var user_folder: String = "user://"
var settings_folder = "user://settings/"


var name_main_settings: String = "main_settings"

var filepath_main_settings: String = settings_folder + name_main_settings + json_extension

var month_strings: Array[String]

var main_settings_active: bool = false


# general use functions


func _init() -> void:
	var month_keys: Array = Month.keys()
	for month in month_keys:
		month_strings.append(month.capitalize())


func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(500, 500))




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
			save_filepath = TaskTrackingGlobal.task_tracker_folder + save_name_parameter + json_extension
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
