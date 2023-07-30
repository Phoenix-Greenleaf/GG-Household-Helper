extends Control

@onready var menu_button = $MainMargin/MainHBox/SideMenuVBox/MenuButton
@onready var current_date_label = $MainMargin/MainHBox/NonSideVBox/TopMenuHBox/CurrentDateLabel


var Weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var Month = ["Month Index", "January", "February", "March", "April", "May", "June", "July",
		"August", "September", "October", "November", "December"]


func _ready() -> void:
	var popup = menu_button.get_popup()
	popup.connect("id_pressed", menu_button_actions)
	
	## i am sure date time will soon be its own script
	
	var current_date = Time.get_date_dict_from_system()
	var current_weekday =  Weekday[current_date["weekday"]] + " "
	var current_day = str(current_date["day"]) + ", "
	var current_month = Month[current_date["month"]] + ", "
	var current_year = str(current_date["year"])
	var current_label_text = "Today: " + current_weekday + current_day + current_month + current_year
	current_date_label.set_text(current_label_text)
	


func menu_button_actions(id):
	match id:
		0:
			get_tree().change_scene_to_file("res://scenes/screens/main_menu.tscn")
		1:
			print("Save File Pressed")
		2:
			print("Change Logs Pressed")
