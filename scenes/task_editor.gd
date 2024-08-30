extends Control

@onready var menu_button: MenuButton = %MenuButton

@onready var current_date_label:= %CurrentDateLabel as Label
@onready var data_manager_center: CenterContainer = $DataManagerCenter
@onready var data_manager: PanelContainer = %DataManager
@onready var current_save_label: Label = %CurrentSaveLabel
@onready var task_spreadsheet_grid_container: GridContainer = %TaskSpreadsheetGridContainer
@onready var month_selection_menu_button: MenuButton = %MonthSelectionMenu

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
@onready var header_scroll_container: ScrollContainer = %HeaderScrollContainer
@onready var spreadsheet_scroll_container: ScrollContainer = %SpreadsheetScrollContainer
@onready var header_grid_container: GridContainer = %HeaderGridContainer

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
	add_task_button.disabled = true
	multi_text_popup_center.visible = false
	if DataGlobal.active_data_task_tracking:
		update_current_tasksheet_label()
		add_task_button.disabled = false
		SignalBus._on_task_editor_section_changed.emit()
	print("========= Editor Scene Ready! =========")


func connection_cental() -> void:
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
	SignalBus._on_task_editor_save_button_pressed.connect(save_active_data)


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


func _on_cancel_multi_text_button_pressed() -> void:
	multi_text_popup_center.visible = false
	text_edit.clear()
