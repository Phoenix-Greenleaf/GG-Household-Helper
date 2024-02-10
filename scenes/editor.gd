extends Control

@onready var menu_button: MenuButton = %MenuButton
@onready var popup:= menu_button.get_popup()
@onready var current_date_label:= %CurrentDateLabel as Label
@onready var data_manager_center: CenterContainer = $DataManagerCenter
@onready var data_manager: PanelContainer = %DataManager
@onready var current_save_label: Label = %CurrentSaveLabel
@onready var task_spreadsheet_grid_container: GridContainer = %TaskSpreadsheetGridContainer
@onready var month_selection_menu_button: MenuButton = %MonthSelectionMenu
@onready var month_selection_menu_popup := month_selection_menu_button.get_popup()
@onready var save_warning_button: Button = %SaveWarningButton
@onready var add_task_button: Button = %AddTaskButton
@onready var multi_text_popup_center: CenterContainer = %MultiTextPopupCenter
@onready var text_edit: TextEdit = %TextEdit
@onready var yearly_button: Button = %YearlyButton
@onready var monthly_button: Button = %MonthlyButton
@onready var weekly_button: Button = %WeeklyButton
@onready var daily_button: Button = %DailyButton
@onready var checkbox_apply_toggle: Button = %CheckboxApplyToggle
@onready var checkbox_inspect_toggle: Button = %CheckboxInspectToggle
@onready var info_mode_button: Button = %InfoModeButton
@onready var checkbox_mode_button: Button = %CheckboxModeButton

var last_toggled_month: int = 1

var Weekday: Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var month_strings = DataGlobal.month_strings
var save_safety_nodes: Array
var quit_counter: int = 0
var quit_index: int = 8
var to_main_menu_index: int = 7
var to_task_menu_index: int = 6
var task_settings_index: int = 1


func _ready() -> void:
	DataGlobal.load_settings_task_tracking()
	connection_cental()
	set_current_date_label()
	set_buttons()
	print_ready()
	add_task_button.disabled = true
	popup.hide_on_item_selection = false
	multi_text_popup_center.visible = false
	if DataGlobal.active_data_task_tracking:
		update_current_tasksheet_label()
		add_task_button.disabled = false
		SignalBus._on_task_editor_section_changed.emit()
	SceneTransition.fade_from_black()




func connection_cental() -> void:
	connect_menu_button_popup()
	connect_month_menu()
	connect_data_manager()
	connect_other_signal_bus()
	get_save_safety_group_nodes()


func connect_data_manager() -> void:
	SignalBus._on_task_data_manager_close_manager_button_pressed.connect(close_data_manager_popup)
	data_manager_center.visible = false


func connect_other_signal_bus() -> void:
	SignalBus._on_task_set_data_active_data_switched.connect(update_current_tasksheet_label)
	SignalBus._on_task_set_data_modified.connect(save_warning_triggered)
	SignalBus._on_task_set_data_saved.connect(save_waring_reset)
	SignalBus._on_task_editor_data_manager_remote_open_pressed.connect(remote_open_data_manager)
	SignalBus._on_task_editor_save_button_pressed.connect(save_active_data)


func connect_month_menu() -> void:
	month_selection_menu_popup.connect("id_pressed", month_menu_button_actions)


func connect_menu_button_popup() -> void:
	popup.connect("id_pressed", menu_button_actions)


func get_save_safety_group_nodes() -> void: 
	save_safety_nodes = get_tree().get_nodes_in_group("save_safety")


func set_buttons() -> void:
	set_section_buttons()
	set_checkbox_mode_buttons()
	set_editor_mode_buttons()
	set_month_selection_menu()


func set_section_buttons() -> void:
	yearly_button.set_pressed_no_signal(false)
	monthly_button.set_pressed_no_signal(false)
	weekly_button.set_pressed_no_signal(false)
	daily_button.set_pressed_no_signal(false)
	match DataGlobal.task_tracking_current_toggled_section:
		DataGlobal.Section.YEARLY:
			yearly_button.set_pressed_no_signal(true)
		DataGlobal.Section.MONTHLY:
			monthly_button.set_pressed_no_signal(true)
		DataGlobal.Section.WEEKLY:
			weekly_button.set_pressed_no_signal(true)
		DataGlobal.Section.DAILY:
			daily_button.set_pressed_no_signal(true)


func set_checkbox_mode_buttons() -> void:
	checkbox_apply_toggle.set_pressed_no_signal(false)
	checkbox_inspect_toggle.set_pressed_no_signal(false)
	match DataGlobal.task_tracking_current_toggled_checkbox_mode:
		DataGlobal.CheckboxToggle.APPLY:
			checkbox_apply_toggle.set_pressed_no_signal(true)
		DataGlobal.CheckboxToggle.INSPECT:
			checkbox_inspect_toggle.set_pressed_no_signal(true)


func set_editor_mode_buttons() -> void:
	info_mode_button.set_pressed_no_signal(false)
	checkbox_mode_button.set_pressed_no_signal(false)
	match DataGlobal.task_tracking_current_toggled_editor_mode:
		1: #"Info"
			info_mode_button.set_pressed_no_signal(true)
		0: #"Checkbox"
			checkbox_mode_button.set_pressed_no_signal(true)


func set_month_selection_menu() -> void:
	var selected_month = DataGlobal.task_tracking_current_toggled_month
	month_selection_menu_button.text = DataGlobal.month_strings[selected_month]
	month_selection_menu_popup.set_item_disabled(selected_month, true)

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
			save_active_data()
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
		8:
			save_active_data()
			popup.visible = false
			SceneTransition.fade_to_black("res://scenes/task_tracking_settings.tscn")


func menu_quit_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(quit_index, "Not Saved!")
			1:
				popup.set_item_text(quit_index, "Confirm Quit")
			2:
				popup.visible = false
				SceneTransition.fade_quit()
		quit_counter += 1
	else:
		popup.visible = false
		SceneTransition.fade_quit()


func menu_to_main_menu_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(to_main_menu_index, "Not Saved!")
			1:
				popup.set_item_text(to_main_menu_index, "Confirm Quit")
			2:
				popup.visible = false
				SceneTransition.fade_to_black("res://scenes/main_menu.tscn")
		quit_counter += 1
	else:
		popup.visible = false
		SceneTransition.fade_to_black("res://scenes/main_menu.tscn")


func menu_to_task_menu_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(to_task_menu_index, "Not Saved!")
			1:
				popup.set_item_text(to_task_menu_index, "Confirm Quit")
			2:
				popup.visible = false
				SceneTransition.fade_to_black("res://scenes/task_tracking_menu.tscn")
		quit_counter += 1
	else:
		popup.visible = false
		SceneTransition.fade_to_black("res://scenes/task_tracking_menu.tscn")


func update_current_tasksheet_label() -> void:
	var title = DataGlobal.active_data_task_tracking.task_set_title
	var year = DataGlobal.active_data_task_tracking.task_set_year
	var new_label = title + ": " + str(year)
	current_save_label.text = new_label
	SignalBus._on_task_set_data_saved.emit()


func close_data_manager_popup() -> void:
	data_manager_center.visible = false


func section_enum_to_string() -> String:
	var section_enum: int = DataGlobal.task_tracking_current_toggled_section
	var section_keys: Array = DataGlobal.Section.keys()
	var current_section_key: String = section_keys[section_enum]
	return current_section_key.capitalize()


func month_menu_button_actions(id: int) -> void:
	var new_month: String = month_strings[id]
	var old_month: String = month_strings[last_toggled_month]
	prints("Switching from", old_month, "to", new_month)
	match id:
		1:
			month_menu_switch(1, DataGlobal.Month.JANUARY)
		2:
			month_menu_switch(2, DataGlobal.Month.FEBRUARY)
		3:
			month_menu_switch(3, DataGlobal.Month.MARCH)
		4:
			month_menu_switch(4, DataGlobal.Month.APRIL)
		5:
			month_menu_switch(5, DataGlobal.Month.MAY)
		6:
			month_menu_switch(6, DataGlobal.Month.JUNE)
		7:
			month_menu_switch(7, DataGlobal.Month.JULY)
		8:
			month_menu_switch(8, DataGlobal.Month.AUGUST)
		9:
			month_menu_switch(9, DataGlobal.Month.SEPTEMBER)
		10:
			month_menu_switch(10, DataGlobal.Month.OCTOBER)
		11:
			month_menu_switch(11, DataGlobal.Month.NOVEMBER)
		12:
			month_menu_switch(12, DataGlobal.Month.DECEMBER)
	SignalBus._on_task_editor_month_changed.emit()


func month_menu_switch(passed_id: int, passed_month: DataGlobal.Month) -> void:
			var month_keys = DataGlobal.Month.keys()
			month_selection_menu_button.text = month_keys[passed_id].capitalize()
			month_selection_menu_popup.set_item_disabled(passed_id, true)
			DataGlobal.task_tracking_current_toggled_month = passed_month
			month_selection_menu_popup.set_item_disabled(last_toggled_month, false)
			last_toggled_month = passed_id


func _on_yearly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.task_tracking_current_toggled_section != DataGlobal.Section.YEARLY:
			DataGlobal.task_tracking_current_toggled_section = DataGlobal.Section.YEARLY
			SignalBus._on_task_editor_section_changed.emit()
			prints("Yearly Section Toggled")
		else:
			prints("Yearly Section ALREADY TOGGLED")


func _on_monthly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.task_tracking_current_toggled_section != DataGlobal.Section.MONTHLY:
			DataGlobal.task_tracking_current_toggled_section = DataGlobal.Section.MONTHLY
			SignalBus._on_task_editor_section_changed.emit()
			prints("Monthly Section Toggled")
		else:
			prints("Monthly Section ALREADY TOGGLED")


func _on_weekly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.task_tracking_current_toggled_section != DataGlobal.Section.WEEKLY:
			DataGlobal.task_tracking_current_toggled_section = DataGlobal.Section.WEEKLY
			SignalBus._on_task_editor_section_changed.emit()
			prints("Weekly Section Toggled")
		else:
			prints("Weekly Section ALREADY TOGGLED")


func _on_daily_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.task_tracking_current_toggled_section != DataGlobal.Section.DAILY:
			DataGlobal.task_tracking_current_toggled_section = DataGlobal.Section.DAILY
			SignalBus._on_task_editor_section_changed.emit()
			prints("Daily Section Toggled")
		else:
			prints("Daily Section ALREADY TOGGLED")


func _on_checkbox_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.task_tracking_current_toggled_editor_mode != DataGlobal.task_tracking_editor_modes["Checkbox"]:
			DataGlobal.task_tracking_current_toggled_editor_mode = DataGlobal.task_tracking_editor_modes["Checkbox"]
			SignalBus._on_task_editor_mode_changed.emit()
			prints("Checkbox Mode toggled")
		else:
			prints("Checkbox Mode ALREADY TOGGLED")


func _on_info_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if DataGlobal.task_tracking_current_toggled_editor_mode != DataGlobal.task_tracking_editor_modes["Info"]:
			DataGlobal.task_tracking_current_toggled_editor_mode = DataGlobal.task_tracking_editor_modes["Info"]
			SignalBus._on_task_editor_mode_changed.emit()
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
	if DataGlobal.active_data_task_tracking:
		save_warning_button.text = "Data Saved"
		DataGlobal.save_data_task_set()
		SignalBus._on_task_set_data_saved.emit()


func _on_menu_button_pressed() -> void:
	popup.set_item_text(quit_index, "Quit")
	popup.set_item_text(to_main_menu_index, "Main Menu")
	popup.set_item_text(to_task_menu_index, "Task Tracking Menu")
	quit_counter = 0


func _on_checkbox_apply_toggle_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		return
	if DataGlobal.task_tracking_current_toggled_checkbox_mode != DataGlobal.CheckboxToggle.APPLY:
		DataGlobal.task_tracking_current_toggled_checkbox_mode = DataGlobal.CheckboxToggle.APPLY
		SignalBus._on_task_editor_checkbox_mode_changed.emit()
		prints("Apply Mode toggled")
	else:
		prints("Apply Mode ALREADY TOGGLED")


func _on_checkbox_inspect_toggle_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		return
	if DataGlobal.task_tracking_current_toggled_checkbox_mode != DataGlobal.CheckboxToggle.INSPECT:
		DataGlobal.task_tracking_current_toggled_checkbox_mode = DataGlobal.CheckboxToggle.INSPECT
		SignalBus._on_task_editor_checkbox_mode_changed.emit()
		prints("Inspect Mode toggled")
	else:
		prints("Inspect Mode ALREADY TOGGLED")


func _on_cancel_multi_text_button_pressed() -> void:
	multi_text_popup_center.visible = false
	text_edit.clear()


func remote_open_data_manager() -> void:
	data_manager_center.visible = true
