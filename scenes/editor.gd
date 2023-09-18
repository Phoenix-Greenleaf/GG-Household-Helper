extends Control

@onready var menu_button:= $MainMargin/MainHBox/SideMenuVBox/MenuButton as MenuButton
@onready var popup:= menu_button.get_popup()
@onready var current_date_label:= %CurrentDateLabel as Label
@onready var data_manager_center: CenterContainer = $DataManagerCenter
@onready var current_save_label: Label = %CurrentSaveLabel
@onready var task_spreadsheet_grid_container: GridContainer = %TaskSpreadsheetGridContainer
@onready var month_selection_menu_button: MenuButton = %MonthSelectionMenu
@onready var month_selection_menu_popup := month_selection_menu_button.get_popup()
@onready var save_warning_button: Button = %SaveWarningButton
@onready var add_task_button: Button = %AddTaskButton

var last_toggled_month: int = 1

var Weekday: Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var month_strings = DataGlobal.month_strings
var save_safety_nodes: Array
var quit_counter: int = 0
var quit_index: int = 7
var to_main_menu_index: int = 6
var to_task_menu_index: int = 5


func _ready() -> void:
	connection_cental()
	set_current_date_label()
	print_ready()
	add_task_button.disabled = true
	popup.hide_on_item_selection = false
	if DataGlobal.current_tasksheet_data:
		update_current_tasksheet_label()
		add_task_button.disabled = false


func connection_cental() -> void:
	connect_menu_button_popup()
	connect_month_menu()
	connect_data_manager()
	connect_other_signal_bus()
	get_save_safety_group_nodes()


func connect_data_manager() -> void:
	SignalBus.data_manager_close.connect(close_data_manager_popup)
	data_manager_center.visible = false


func connect_other_signal_bus() -> void:
	SignalBus._on_current_tasksheet_data_changed.connect(update_current_tasksheet_label)
	SignalBus.trigger_save_warning.connect(save_warning_triggered)
	SignalBus.reset_save_warning.connect(save_waring_reset)


func connect_month_menu() -> void:
	month_selection_menu_popup.connect("id_pressed", month_menu_button_actions)


func connect_menu_button_popup() -> void:
	popup.connect("id_pressed", menu_button_actions)


func get_save_safety_group_nodes() -> void: 
	save_safety_nodes = get_tree().get_nodes_in_group("save_safety")


func print_ready() -> void:
	print("========= Editor Scene Ready! =========")


func set_current_date_label() -> void:
	var current_date: Dictionary = Time.get_date_dict_from_system()
	var current_weekday: String =  Weekday[current_date["weekday"]] + " "
	var current_day: String = str(current_date["day"]) + ", "
	var current_month: String = month_strings[current_date["month"]] + ", "
	var current_year: String = str(current_date["year"])
	var current_label:= "Today: " + current_weekday + current_day + current_month + current_year
	current_date_label.set_text(current_label)


func menu_button_actions(id: int) -> void:
	match id:
		0:
			menu_to_main_menu_with_save_protection()
		1:
			print("Save File Pressed")
			popup.hide()
		2:
			print("Change Logs Pressed")
			popup.hide()
		3:
			menu_quit_with_save_protection()
		5:
			data_manager_center.visible = true
			popup.hide()
		6:
			menu_to_task_menu_with_save_protection()


func menu_quit_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(quit_index, "Not Saved!")
			1:
				popup.set_item_text(quit_index, "Confirm Quit")
			2:
				get_tree().quit()
		quit_counter += 1
	else:
		get_tree().quit()


func menu_to_main_menu_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(to_main_menu_index, "Not Saved!")
			1:
				popup.set_item_text(to_main_menu_index, "Confirm Quit")
			2:
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		quit_counter += 1
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func menu_to_task_menu_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(to_task_menu_index, "Not Saved!")
			1:
				popup.set_item_text(to_task_menu_index, "Confirm Quit")
			2:
				get_tree().change_scene_to_file("res://scenes/task_tracking_menu.tscn")
		quit_counter += 1
	else:
		get_tree().change_scene_to_file("res://scenes/task_tracking_menu.tscn")


func update_current_tasksheet_label() -> void:
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	var new_label = title + ": " + str(year)
	current_save_label.text = new_label
	SignalBus.reset_save_warning.emit()


func close_data_manager_popup() -> void:
	data_manager_center.visible = false


func section_enum_to_string() -> String:
	var section_enum: int = DataGlobal.current_toggled_section
	var section_keys: Array = DataGlobal.Section.keys()
	var current_section_key: String = section_keys[section_enum]
	return current_section_key.capitalize()


func month_menu_button_actions(id: int) -> void:
	var new_month: String = month_strings[id]
	var old_month: String = month_strings[last_toggled_month]
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
	SignalBus._on_editor_month_changed.emit()


func month_menu_switch(passed_id: int, month_text: String) -> void:
			month_selection_menu_button.text = month_text
			month_selection_menu_popup.set_item_disabled(passed_id, true)
			DataGlobal.current_toggled_month =  month_text
			month_selection_menu_popup.set_item_disabled(last_toggled_month, false)
			last_toggled_month = passed_id


func _on_yearly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.YEARLY:
			DataGlobal.current_toggled_section = DataGlobal.Section.YEARLY
			SignalBus._on_editor_section_changed.emit()
			prints("Yearly Section Toggled")
		else:
			prints("Yearly Section ALREADY TOGGLED")


func _on_monthly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.MONTHLY:
			DataGlobal.current_toggled_section = DataGlobal.Section.MONTHLY
			SignalBus._on_editor_section_changed.emit()
			prints("Monthly Section Toggled")
		else:
			prints("Monthly Section ALREADY TOGGLED")


func _on_weekly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.WEEKLY:
			DataGlobal.current_toggled_section = DataGlobal.Section.WEEKLY
			SignalBus._on_editor_section_changed.emit()
			prints("Weekly Section Toggled")
		else:
			prints("Weekly Section ALREADY TOGGLED")


func _on_daily_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_section != DataGlobal.Section.DAILY:
			DataGlobal.current_toggled_section = DataGlobal.Section.DAILY
			SignalBus._on_editor_section_changed.emit()
			prints("Daily Section Toggled")
		else:
			prints("Daily Section ALREADY TOGGLED")


func _on_checkbox_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_editor_mode != DataGlobal.editor_modes["Checkbox"]:
			DataGlobal.current_toggled_editor_mode = DataGlobal.editor_modes["Checkbox"]
			SignalBus._on_editor_mode_changed.emit()
			prints("Checkbox Mode toggled")
		else:
			prints("Checkbox Mode ALREADY TOGGLED")


func _on_info_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.current_toggled_editor_mode != DataGlobal.editor_modes["Info"]:
			DataGlobal.current_toggled_editor_mode = DataGlobal.editor_modes["Info"]
			SignalBus._on_editor_mode_changed.emit()
			prints("Info Mode toggled")
		else:
			prints("Info Mode ALREADY TOGGLED")


func save_warning_triggered() -> void:
	print("Save Warning TRIGGERED")
	save_warning_button.text = "DATA NEEDS SAVING!"


func save_waring_reset() -> void:
	print("Save Warning RESET")
	save_warning_button.text = "Data Saved"
	if add_task_button.disabled == true:
		add_task_button.disabled = false


func _on_save_warning_button_pressed() -> void:
	if save_warning_button.text == "Data Saved":
		DataGlobal.button_based_message(save_warning_button, "Already Saved!")
		return
	elif save_warning_button.text == "Already Saved!":
		print("For real please stop")
		return
	elif save_warning_button.text == "No Data Loaded!":
		print("Nothing to save, love")
		return
	else:
		save_active_data()


func save_active_data() -> void:
		save_warning_button.text = "Data Saved"
		var data_manager: Node = data_manager_center.get_child(0)
		data_manager.save_current_tasksheet()
		SignalBus.reset_save_warning.emit()


func _on_menu_button_pressed() -> void:
	popup.set_item_text(quit_index, "Quit")
	popup.set_item_text(to_main_menu_index, "Main Menu")
	popup.set_item_text(to_task_menu_index, "Task Tracking Menu")
	quit_counter = 0


func _on_checkbox_apply_toggle_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		return
	if DataGlobal.current_toggled_checkbox_mode != DataGlobal.CheckboxToggle.APPLY:
		DataGlobal.current_toggled_checkbox_mode = DataGlobal.CheckboxToggle.APPLY
		SignalBus._on_checkbox_mode_changed.emit()
		prints("Apply Mode toggled")
	else:
		prints("Apply Mode ALREADY TOGGLED")


func _on_checkbox_inspect_toggle_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		return
	if DataGlobal.current_toggled_checkbox_mode != DataGlobal.CheckboxToggle.INSPECT:
		DataGlobal.current_toggled_checkbox_mode = DataGlobal.CheckboxToggle.INSPECT
		SignalBus._on_checkbox_mode_changed.emit()
		prints("Inspect Mode toggled")
	else:
		prints("Inspect Mode ALREADY TOGGLED")
