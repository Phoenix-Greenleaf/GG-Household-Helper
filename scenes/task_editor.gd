extends Control

@onready var current_date_label:= %CurrentDateLabel as Label
@onready var current_save_label: Label = %CurrentSaveLabel
@onready var save_warning_button: Button = %SaveWarningButton
@onready var add_task_button: Button = %AddTaskButton

var last_toggled_month: int = 1
var Weekday: Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var month_strings = DataGlobal.month_strings
var save_safety_nodes: Array
var quit_counter: int = 0


func _ready() -> void:
	#TaskTrackingGlobal.load_settings_task_tracking()
	connection_cental()
	set_current_date_label()
	SqlManager.load_database()
	#add_task_button.disabled = true
	#if SqlManager.database_is_active:
		#add_task_button.disabled = false
	print("========= Editor Scene Ready! =========")


func connection_cental() -> void:
	get_save_safety_group_nodes()



func get_save_safety_group_nodes() -> void: 
	save_safety_nodes = get_tree().get_nodes_in_group("save_safety")


func set_current_date_label() -> void:
	var current_date: Dictionary = Time.get_date_dict_from_system()
	var current_weekday: String =  Weekday[current_date["weekday"]] + " "
	var current_day: String = str(current_date["day"]) + ", "
	var current_month: String = month_strings[current_date["month"]] + ", "
	var current_year: String = str(current_date["year"])
	var current_label:= "Today: " + current_weekday + current_day + current_month + current_year
	current_date_label.set_text(current_label)


func section_enum_to_string() -> String:
	var section_enum: int = TaskTrackingGlobal.current_toggled_section
	var section_keys: Array = DataGlobal.Section.keys()
	var current_section_key: String = section_keys[section_enum]
	return current_section_key.capitalize()



func populate_menu_load_database() -> void:
	pass

func find_database_files() -> void:
	pass

func get_database_name() -> void:
	pass

func create_buttons_load_database() -> void:
	pass






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
