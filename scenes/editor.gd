extends Control

@onready var menu_button:= $MainMargin/MainHBox/SideMenuVBox/MenuButton as MenuButton
@onready var current_date_label:= %CurrentDateLabel as Label
@onready var data_manager_center: CenterContainer = $DataManagerCenter
@onready var current_save_label: Label = %CurrentSaveLabel
@onready var task_spreadsheet_grid_container: GridContainer = %TaskSpreadsheetGridContainer
@onready var month_selection_menu_button: MenuButton = %MonthSelectionMenu
@onready var month_selection_menu_popup := month_selection_menu_button.get_popup()
@onready var save_warning_button: Button = %SaveWarningButton



var last_toggled_month : int = 1

var Weekday : Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var Month : Array = ["Month Index", "January", "February", "March", "April", "May", "June", "July",
		"August", "September", "October", "November", "December"]



func _ready() -> void:
	connection_cental()
	set_current_date_label()
	print_ready()
	if DataGlobal.current_tasksheet_data:
		update_current_tasksheet_label()


func connection_cental() -> void:
	connect_menu_button_popup()
	connect_month_menu()
	connect_data_manager()
	connect_other_signal_bus()

func connect_data_manager() -> void:
	SignalBus.data_manager_close.connect(close_data_manager_popup)
	data_manager_center.visible = false

func connect_other_signal_bus() -> void:
	SignalBus._on_current_tasksheet_data_changed.connect(update_current_tasksheet_label)
	SignalBus.trigger_save_warning.connect(save_warning_triggered)

func connect_month_menu() -> void:
	month_selection_menu_popup.connect("id_pressed", month_menu_button_actions)

func connect_menu_button_popup() -> void:
	var popup:= menu_button.get_popup()
	popup.connect("id_pressed", menu_button_actions)


func print_ready() -> void:
	print("========= Editor Scene Ready! =========")


func set_current_date_label() -> void:
	var current_date: Dictionary = Time.get_date_dict_from_system()
	var current_weekday: String =  Weekday[current_date["weekday"]] + " "
	var current_day: String = str(current_date["day"]) + ", "
	var current_month: String = Month[current_date["month"]] + ", "
	var current_year: String = str(current_date["year"])
	var current_label:= "Today: " + current_weekday + current_day + current_month + current_year
	current_date_label.set_text(current_label)


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


func update_current_tasksheet_label() -> void:
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	var new_label = title + ": " + str(year)
	current_save_label.text = new_label


func close_data_manager_popup() -> void:
	data_manager_center.visible = false


func section_enum_to_string() -> String:
	var section_enum: int = DataGlobal.current_toggled_section
	var section_keys: Array = DataGlobal.Section.keys()
	var current_section_key: String = section_keys[section_enum]
	return current_section_key.capitalize()


func month_menu_button_actions(id: int) -> void:
	var new_month : String = Month[id]
	var old_month : String = Month[last_toggled_month]
	prints("Switching from", old_month, "to", new_month)
	match id:
		1:
			month_menu_switch(1, "January")
		2:
			month_menu_switch(2, "February")
		3:
			month_menu_switch(3, "March")
		4:
			month_menu_switch(4, "April")
		5:
			month_menu_switch(5, "May")
		6:
			month_menu_switch(6, "June")
		7:
			month_menu_switch(7, "July")
		8:
			month_menu_switch(8, "August")
		9:
			month_menu_switch(9, "September")
		10:
			month_menu_switch(10, "October")
		11:
			month_menu_switch(11, "November")
		12:
			month_menu_switch(12, "December")
	SignalBus.emit_signal("_on_editor_month_changed")


func change_sections() -> void:
	SignalBus.emit_signal("_on_editor_section_changed")


func month_menu_switch(passed_id: int, month_text: String) -> void:
			month_selection_menu_button.text = month_text
			month_selection_menu_popup.set_item_disabled(passed_id, true)
			DataGlobal.current_toggled_month =  month_text
			month_selection_menu_popup.set_item_disabled(last_toggled_month, false)
			last_toggled_month = passed_id


func _on_yearly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed): #check to see if this toggle/if statement is needed
		if DataGlobal.current_toggled_section != DataGlobal.Section.YEARLY:
			DataGlobal.current_toggled_section = DataGlobal.Section.YEARLY
			change_sections()
			prints("Yearly Section Toggled")
		else:
			prints("Yearly Section ALREADY TOGGLED")


func _on_monthly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.MONTHLY:
			DataGlobal.current_toggled_section = DataGlobal.Section.MONTHLY
			change_sections()
			prints("Monthly Section Toggled")
		else:
			prints("Monthly Section ALREADY TOGGLED")


func _on_weekly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.WEEKLY:
			DataGlobal.current_toggled_section = DataGlobal.Section.WEEKLY
			change_sections()
			prints("Weekly Section Toggled")
		else:
			prints("Weekly Section ALREADY TOGGLED")


func _on_daily_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.DAILY:
			DataGlobal.current_toggled_section = DataGlobal.Section.DAILY
			change_sections()
			prints("Daily Section Toggled")
		else:
			prints("Daily Section ALREADY TOGGLED")


func change_editor_mode() -> void:
	SignalBus.emit_signal("_on_editor_mode_changed")


func _on_checkbox_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_mode != DataGlobal.editor_modes["Checkbox"]:
			DataGlobal.current_toggled_mode = DataGlobal.editor_modes["Checkbox"]
			change_editor_mode()
			prints("Checkbox Mode toggled")
		else:
			prints("Checkbox Mode ALREADY TOGGLED")


func _on_info_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_mode != DataGlobal.editor_modes["Info"]:
			DataGlobal.current_toggled_mode = DataGlobal.editor_modes["Info"]
			change_editor_mode()
			prints("Info Mode toggled")
		else:
			prints("Info Mode ALREADY TOGGLED")


func save_warning_triggered() -> void:
	save_warning_button.text = "DATA NEEDS SAVING"


func _on_save_warning_button_pressed() -> void:
	if save_warning_button.text == "Data Saved":
		DataGlobal.button_based_message(save_warning_button, "Already Saved!")
		return
	save_warning_button.text = "Data Saved"
	var data_manager : Node = data_manager_center.get_child(0)
	print(data_manager)
	data_manager.save_current_tasksheet()
