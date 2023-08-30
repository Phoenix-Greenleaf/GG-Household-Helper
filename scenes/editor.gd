extends Control

@onready var menu_button:= $MainMargin/MainHBox/SideMenuVBox/MenuButton as MenuButton
@onready var current_date_label:= $MainMargin/MainHBox/NonSideVBox/TopMenuHBox/CurrentDateLabel as Label
@onready var data_manager_center: CenterContainer = $DataManagerCenter
@onready var current_save_label: Label = %CurrentSaveLabel


var Weekday : Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var Month : Array = ["Month Index", "January", "February", "March", "April", "May", "June", "July",
		"August", "September", "October", "November", "December"]


func _ready() -> void:
	connect_menu_button_popup()
	connect_data_manager()
	connect_other_signal_bus()
	set_current_date_label()
	print_ready()
	if DataGlobal.current_tasksheet_data:
		update_current_tasksheet_label()




func connect_data_manager() -> void:
	SignalBus.data_manager_close.connect(close_data_manager_popup)
	data_manager_center.visible = false


func set_current_date_label() -> void:
	var current_date: Dictionary = Time.get_date_dict_from_system()
	var current_weekday: String =  Weekday[current_date["weekday"]] + " "
	var current_day: String = str(current_date["day"]) + ", "
	var current_month: String = Month[current_date["month"]] + ", "
	var current_year: String = str(current_date["year"])
	var current_label:= "Today: " + current_weekday + current_day + current_month + current_year
	current_date_label.set_text(current_label)

func connect_menu_button_popup() -> void:
	var popup:= menu_button.get_popup()
	popup.connect("id_pressed", menu_button_actions)

func connect_other_signal_bus() -> void:
	SignalBus._on_current_tasksheet_data_changed.connect(update_current_tasksheet_label)


func print_ready() -> void:
	print("========= Editor Scene Ready! =========")

func menu_button_actions(id: int) -> void:
	match id:
		0:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		1:
			print("Save File Pressed")
		2:
			print("Change Logs Pressed")
		3:
			get_tree().quit()
		5:
			data_manager_center.visible = true

func close_data_manager_popup() -> void:
	data_manager_center.visible = false


func update_current_tasksheet_label() -> void:
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	var new_label = title + ": " + str(year)
	current_save_label.text = new_label
