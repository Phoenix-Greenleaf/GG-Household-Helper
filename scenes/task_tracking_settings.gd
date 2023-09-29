extends PanelContainer

@onready var auto_load_check_button: CheckButton = %AutoLoadCheckButton
@onready var default_data_display_button: Button = %DefaultDataDisplayButton
@onready var set_active_button: Button = %SetActiveButton
@onready var set_expired_button: Button = %SetExpiredButton
@onready var set_assigned_button: Button = %SetAssignedButton
@onready var deletion_safety_check_button: CheckButton = %DeletionSafetyCheckButton
@onready var remove_profile_button: Button = %RemoveProfileButton
@onready var purge_profile_data_button: Button = %PurgeProfileDataButton
@onready var delete_task_sheet_button: Button = %DeleteTaskSheetButton
@onready var reset_default_settings_button: Button = %ResetDefaultSettingsButton
@onready var deletion_background_panel_container: PanelContainer = %DeletionBackgroundPanelContainer
@onready var deletion_grid_container: GridContainer = %DeletionGridContainer
@onready var description_preview_length_spin_box: SpinBox = %DescriptionPreviewLengthSpinBox
@onready var reset_checkboxes_button: Button = %ResetCheckboxesButton
@onready var reset_checkboxes_section_option_button: OptionButton = %ResetCheckboxesSectionOptionButton
@onready var reset_checkboxes_month_option_button: OptionButton = %ResetCheckboxesMonthOptionButton

@onready var data_manager: PanelContainer = $DataManager
@onready var settings = DataGlobal.settings_file

var task_new_checkbox_options_button_group: ButtonGroup = preload("res://data/setting_parts/task_new_checkbox_options_button_group.tres")

var scanned_profiles: Array
var current_data: TaskSpreadsheetData
var new_checkbox_options := DataGlobal.settings_file.NEW_CHECKBOX_OPTION
var tasksheet_folder = "user://task_data/"


func _ready() -> void:
	establish_connections()
	disarm_danger_buttons()
	load_all_settings()
	deletion_background_panel_container.visible = false


func establish_connections() -> void:
	task_new_checkbox_options_button_group.pressed.connect(_on_task_new_checkbox_options_button_group_pressed)
	SignalBus.remote_task_settings_reload.connect(reload_settings)
	

func disarm_danger_buttons() -> void:
		settings.task_enable_deletion_buttons = false


func load_all_settings() -> void:
	load_auto_load_setting()
	load_default_task_data()
	load_new_checkbox_setting()
	load_deletion_armed_setting()
	load_description_preview_length()
	load_reset_current_checkbox_options()
	reset_buttons()


func load_auto_load_setting() -> void:
	if not settings.task_enable_auto_load_default_data:
		auto_load_check_button.button_pressed = false
		auto_load_check_button.text = "Auto Load Default Data (Off)"
	if settings.task_enable_auto_load_default_data:
		auto_load_check_button.button_pressed = true
		auto_load_check_button.text = "Auto Load Default Data (On!)"


func load_default_task_data() -> void:
	if settings.task_default_data:
		var task_name = settings.task_default_data.spreadsheet_title
		var task_year = str(settings.task_default_data.spreadsheet_year)
		default_data_display_button.text = "Current Default: " + task_name + " " + task_year
		default_data_display_button.set_pressed_no_signal(true)
		default_data_display_button.disabled = false
	if not settings.task_default_data:
		default_data_display_button.text = "Data Not Set"
		default_data_display_button.set_pressed_no_signal(false)
		default_data_display_button.disabled = true
		auto_load_check_button.button_pressed = false
		auto_load_check_button.text = "Auto Load Default Data (Off)"


func load_new_checkbox_setting() -> void:
	set_active_button.set_pressed_no_signal(false)
	set_expired_button.set_pressed_no_signal(false)
	set_assigned_button.set_pressed_no_signal(false)
	match settings.task_current_new_checkbox_option:
		new_checkbox_options.ACTIVE:
			set_active_button.set_pressed_no_signal(true)
		new_checkbox_options.EXPIRED:
			set_expired_button.set_pressed_no_signal(true)
		new_checkbox_options.ASSIGNED:
			set_assigned_button.set_pressed_no_signal(true)


func load_deletion_armed_setting() -> void:
	if settings.task_enable_deletion_buttons:
		deletion_safety_check_button.text = "Danger Buttons ARMED"
		deletion_safety_check_button.set_pressed_no_signal(true)
		remove_profile_button.disabled = false
		purge_profile_data_button.disabled = false
		delete_task_sheet_button.disabled = false
		reset_checkboxes_button.disabled = false
		reset_checkboxes_section_option_button.disabled = false
		reset_checkboxes_month_option_button.disabled = false
	if not settings.task_enable_deletion_buttons:
		deletion_safety_check_button.text = "Danger Buttons Disarmed"
		deletion_safety_check_button.set_pressed_no_signal(false)
		remove_profile_button.disabled = true
		purge_profile_data_button.disabled = true
		delete_task_sheet_button.disabled = true
		reset_checkboxes_button.disabled = true
		reset_checkboxes_section_option_button.disabled = true
		reset_checkboxes_month_option_button.disabled = true


func load_description_preview_length() -> void:
	description_preview_length_spin_box.set_value_no_signal(settings.task_description_preview_length)


func reset_buttons() -> void:
	reset_default_settings_button.text = "Reset Default Settings"


func _on_menu_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_menu.tscn")


func _on_sheets_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/editor.tscn")


func _on_regen_profiles_button_pressed() -> void:
	full_scan()
	DataGlobal.current_tasksheet_data.user_profiles.clear()
	for scan_iteration in scanned_profiles:
		DataGlobal.current_tasksheet_data.user_profiles.append(scan_iteration)
	data_manager.save_current_tasksheet()
	SignalBus.reload_profiles_triggered.emit()


func full_scan() -> void:
	scanned_profiles = []
	current_data = DataGlobal.current_tasksheet_data
	scan_section(current_data.spreadsheet_year_data)
	scan_section(current_data.spreadsheet_month_data)
	scan_section(current_data.spreadsheet_week_data)
	scan_section(current_data.spreadsheet_day_data)


func scan_section(target_section) -> void: 
	for task_iteration in target_section:
		for month_iteration in task_iteration.month_checkbox_dictionary:
			var checkbox_array = task_iteration.month_checkbox_dictionary[month_iteration]
			for checkbox_iteration in checkbox_array:
				var profile_iteration: Array = checkbox_iteration.assigned_user
				if scanned_profiles.has(profile_iteration):
					continue
				if profile_iteration == DataGlobal.default_profile:
					continue
				scanned_profiles.append(profile_iteration)
				prints(profile_iteration[0], "added to Scan Array")


func full_purge(profile_to_purge) -> void:
	current_data = DataGlobal.current_tasksheet_data
	purge_section(current_data.spreadsheet_year_data, profile_to_purge)
	purge_section(current_data.spreadsheet_month_data, profile_to_purge)
	purge_section(current_data.spreadsheet_week_data, profile_to_purge)
	purge_section(current_data.spreadsheet_day_data, profile_to_purge)
	prints("Purge complete")


func purge_section(target_section, target_profile) -> void:
	for task_iteration in target_section:
		if task_iteration.assigned_user == target_profile:
			task_iteration.assigned_user = DataGlobal.default_profile
		for month_iteration in task_iteration.month_checkbox_dictionary:
			var checkbox_array = task_iteration.month_checkbox_dictionary[month_iteration]
			for checkbox_iteration in checkbox_array:
				var profile_iteration: Array = checkbox_iteration.assigned_user
				if profile_iteration == target_profile:
					checkbox_iteration.assigned_user = DataGlobal.default_profile
					checkbox_iteration.checkbox_status = DataGlobal.Checkbox.ACTIVE


func _on_auto_load_check_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		DataGlobal.settings_file.task_enable_auto_load_default_data = false
		reload_settings()
		return
	if not DataGlobal.settings_file.task_default_data:
		prints("Default data is needed to enable auto-load")
		DataGlobal.button_based_message(default_data_display_button, "Auto-load requires Default Data")
		auto_load_check_button.set_pressed_no_signal(false)
		return
	DataGlobal.settings_file.task_enable_auto_load_default_data = true
	reload_settings()


func _on_reset_default_settings_button_pressed() -> void:
	if reset_default_settings_button.text == "Reset Default Settings":
		reset_default_settings_button.text = "Confirm Settings Reset"
		return
	DataGlobal.settings_file.reset_task_tracking_settings()
	reload_settings()


func _on_set_default_data_button_pressed() -> void:
	if not DataGlobal.current_tasksheet_data:
		prints("No data to set as default")
		DataGlobal.button_based_message(default_data_display_button, "No Data to set as Default!")
		return
	DataGlobal.settings_file.task_default_data = DataGlobal.current_tasksheet_data
	reload_settings()


func _on_task_new_checkbox_options_button_group_pressed(pressed_button: Button) -> void:
	match pressed_button.name:
		"SetActiveButton":
			DataGlobal.settings_file.task_current_new_checkbox_option = settings.NEW_CHECKBOX_OPTION.ACTIVE
		"SetExpiredButton":
			DataGlobal.settings_file.task_current_new_checkbox_option = settings.NEW_CHECKBOX_OPTION.EXPIRED
		"SetAssignedButton":
			DataGlobal.settings_file.task_current_new_checkbox_option = settings.NEW_CHECKBOX_OPTION.ASSIGNED
	reload_settings()


func reload_settings() -> void:
	SignalBus._on_settings_changed.emit()
	load_all_settings()


func _on_deletion_safety_check_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		DataGlobal.settings_file.task_enable_deletion_buttons = false
	if button_pressed:
		DataGlobal.settings_file.task_enable_deletion_buttons = true
	reload_settings()


func _on_deletion_back_button_pressed() -> void:
	deletion_background_panel_container.visible = false
	var deletion_children = deletion_grid_container.get_children()
	for child_iteration in deletion_children:
		deletion_grid_container.remove_child(child_iteration)
		child_iteration.queue_free()


func _on_remove_profile_button_pressed() -> void:
	if not DataGlobal.current_tasksheet_data:
		prints("Remove Profile Error: No data to load profiles from")
		DataGlobal.button_based_message(remove_profile_button, "Error: No data to load profiles from!")
		return
	deletion_background_panel_container.visible = true
	for profile_iteration in DataGlobal.current_tasksheet_data.user_profiles:
		create_profile_deathrow_button(profile_iteration, "profile")


func _on_delete_task_sheet_button_pressed() -> void:
	deletion_background_panel_container.visible = true
	var existing_files = DirAccess.get_files_at(tasksheet_folder)
	for file in existing_files:
		var filepath_for_loading = tasksheet_folder + file
		var file_resource: TaskSpreadsheetData = ResourceLoader.load(filepath_for_loading)
		create_sheet_data_deathrow_button(file_resource, filepath_for_loading)


func create_sheet_data_deathrow_button(target_sheet_data: TaskSpreadsheetData, sheet_data_path: String) -> void:
	var deathrow_button : Button = Button.new()
	var type: String = "sheet data"
	deletion_grid_container.add_child(deathrow_button)
	var loaded_name: String = target_sheet_data.spreadsheet_title
	var loaded_year := str(target_sheet_data.spreadsheet_year)
	deathrow_button.text = loaded_name + "\n" + loaded_year
	deathrow_button.pressed.connect(_on_deathrow_button_pressed.bind(deathrow_button, type, sheet_data_path))
	


func create_profile_deathrow_button(target_profile: Array, type: String) -> void:
	var deathrow_button : Button = Button.new()
	deletion_grid_container.add_child(deathrow_button)
	deathrow_button.text = target_profile[0]
	deathrow_button.add_theme_color_override("font_color", target_profile[1])
	deathrow_button.pressed.connect(_on_deathrow_button_pressed.bind(deathrow_button, type, target_profile))


func _on_deathrow_button_pressed(pressed_button: Button, remove_type: String, target) -> void:
	prints("Deathrow button pressed")
	pressed_button.queue_free()
	match remove_type:
		"profile":
			DataGlobal.current_tasksheet_data.user_profiles.erase(target)
			data_manager.save_current_tasksheet()
		"profile data":
			full_purge(target)
			data_manager.save_current_tasksheet()
		"sheet data":
			var file_resource: TaskSpreadsheetData = ResourceLoader.load(target)
			if DataGlobal.settings_file.task_default_data == file_resource:
				DataGlobal.settings_file.task_default_data = null
			if DataGlobal.current_tasksheet_data == file_resource:
				DataGlobal.current_tasksheet_data = null
			reload_settings()
			OS.move_to_trash(ProjectSettings.globalize_path(target))
			


func _on_purge_profile_data_button_pressed() -> void:
	if not DataGlobal.current_tasksheet_data:
		prints("Purge Profile Data Error: No data to load profiles from")
		DataGlobal.button_based_message(purge_profile_data_button, "Error: No data to load profiles from!")
		return
	deletion_background_panel_container.visible = true
	full_scan()
	for scanned_profile_iteration in scanned_profiles:
		create_profile_deathrow_button(scanned_profile_iteration, "profile data")


func _on_description_preview_length_spin_box_value_changed(value: float) -> void:
	var int_value = value as int
	prints("Preview Length:", int_value)
	DataGlobal.settings_file.task_description_preview_length = int_value
	reload_settings()


func _on_unload_current_data_button_pressed() -> void:
	DataGlobal.current_tasksheet_data = null
	DataGlobal.current_checkbox_profile = DataGlobal.default_profile
	DataGlobal.current_checkbox_state = DataGlobal.Checkbox.ACTIVE
	if DataGlobal.settings_file.task_enable_auto_load_default_data:
		DataGlobal.settings_file.task_enable_auto_load_default_data = false
	reload_settings()


func _on_reset_checkboxes_button_pressed() -> void:
	if reset_checkboxes_button.text == "Reset Current Checkboxes":
		DataGlobal.button_based_message(reset_checkboxes_button, "CONFIRM Clear and Reset?", 5)
		return
	if reset_checkboxes_button.text == "CONFIRM Clear and Reset?":
		reset_checkboxes_button.text = "Reset Current Checkboxes"
		regen_all_checkboxes()
		data_manager.save_current_tasksheet()
		DataGlobal.button_based_message(reset_checkboxes_button, "RESET SUCCESSFUL!")



func regen_all_checkboxes() -> void:
	prints("Checkbox Regen Signal recieved")
	regen_section_checkboxes(DataGlobal.current_tasksheet_data.spreadsheet_year_data)
	regen_section_checkboxes(DataGlobal.current_tasksheet_data.spreadsheet_month_data)
	regen_section_checkboxes(DataGlobal.current_tasksheet_data.spreadsheet_week_data)
	regen_section_checkboxes(DataGlobal.current_tasksheet_data.spreadsheet_day_data)


func regen_section_checkboxes(section) -> void:
	for task_data in section:
		var month_checkbox_dictionary = task_data.month_checkbox_dictionary
		for month_iteration in month_checkbox_dictionary:
			task_data.month_checkbox_dictionary[month_iteration].clear()
		task_data.generate_all_checkboxes()


func load_reset_current_checkbox_options() -> void:
	reset_checkboxes_section_option_button.select(settings.task_reset_current_checkboxes_section)
	match settings.task_reset_current_checkboxes_section:
		0, 1, 2:
			settings.task_reset_current_checkboxes_month = 0
			reset_checkboxes_month_option_button.disabled = true
		_:
			pass
	reset_checkboxes_month_option_button.select(settings.task_reset_current_checkboxes_month)


func _on_reset_checkboxes_section_option_button_item_selected(index: int) -> void:
	DataGlobal.settings_file.task_reset_current_checkboxes_section = index
	prints("Reset Checkboxes Section selected:", reset_checkboxes_section_option_button.get_item_text(index), index)
	reload_settings()

func _on_reset_checkboxes_month_option_button_item_selected(index: int) -> void:
	DataGlobal.settings_file.task_reset_current_checkboxes_month = index
	prints("Reset Checkboxes Month selected:", reset_checkboxes_month_option_button.get_item_text(index), index)
	reload_settings()
