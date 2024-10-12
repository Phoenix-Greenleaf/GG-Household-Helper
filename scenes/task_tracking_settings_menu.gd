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
@onready var settings: TaskSettingsData
@onready var new_checkbox_options: Dictionary

var task_new_checkbox_options_button_group: ButtonGroup = preload("res://gui/task_tracking/task_new_checkbox_options_button_group.tres")

var scanned_profiles: Array
var scan_data: TaskSetData



func _ready() -> void:
	TaskTrackingGlobal.load_task_tracking_settings()
	settings = TaskTrackingGlobal.active_settings
	new_checkbox_options = settings.NewCheckboxOption
	establish_connections()
	load_all_settings()
	disarm_danger_buttons()
	deletion_background_panel_container.visible = false


func establish_connections() -> void:
	task_new_checkbox_options_button_group.pressed.connect(
		_on_task_new_checkbox_options_button_group_pressed
	)


func disarm_danger_buttons() -> void:
		settings.enable_deletion_buttons = false


func load_all_settings() -> void:
	load_auto_load_setting()
	load_default_task_data()
	load_new_checkbox_setting()
	load_deletion_armed_setting()
	load_description_preview_length()
	#load_reset_current_checkbox_options()
	reset_buttons()


func load_auto_load_setting() -> void:
	if not settings.enable_auto_load_default_data:
		auto_load_check_button.button_pressed = false
		auto_load_check_button.text = "Auto-Load Default Database (Off)"
	if settings.enable_auto_load_default_data:
		auto_load_check_button.button_pressed = true
		auto_load_check_button.text = "Auto-Load Default Database (On!)"


func load_default_task_data() -> void:
	if settings.autoload_database_path:
		default_data_display_button.text = "Current Default: " + SqlManager.database_name
		default_data_display_button.set_pressed_no_signal(true)
		default_data_display_button.disabled = false
	if not settings.autoload_database_path:
		default_data_display_button.text = "No Database Set"
		default_data_display_button.set_pressed_no_signal(false)
		default_data_display_button.disabled = true
		auto_load_check_button.button_pressed = false
		auto_load_check_button.text = "Auto Load Default Data (Off)"


func load_new_checkbox_setting() -> void:
	set_active_button.set_pressed_no_signal(false)
	set_expired_button.set_pressed_no_signal(false)
	set_assigned_button.set_pressed_no_signal(false)
	match settings.current_new_checkbox_option:
		new_checkbox_options.ACTIVE:
			set_active_button.set_pressed_no_signal(true)
		new_checkbox_options.EXPIRED:
			set_expired_button.set_pressed_no_signal(true)
		new_checkbox_options.ASSIGNED:
			set_assigned_button.set_pressed_no_signal(true)


func load_deletion_armed_setting() -> void:
	if settings.enable_deletion_buttons:
		deletion_safety_check_button.text = "Danger Buttons ARMED"
		deletion_safety_check_button.set_pressed_no_signal(true)
		remove_profile_button.disabled = false
		purge_profile_data_button.disabled = false
		delete_task_sheet_button.disabled = false
		reset_checkboxes_button.disabled = false
		reset_checkboxes_section_option_button.disabled = false
		reset_checkboxes_month_option_button.disabled = false
	if not settings.enable_deletion_buttons:
		deletion_safety_check_button.text = "Danger Buttons Disarmed"
		deletion_safety_check_button.set_pressed_no_signal(false)
		remove_profile_button.disabled = true
		purge_profile_data_button.disabled = true
		delete_task_sheet_button.disabled = true
		reset_checkboxes_button.disabled = true
		reset_checkboxes_section_option_button.disabled = true
		reset_checkboxes_month_option_button.disabled = true


func load_description_preview_length() -> void:
	description_preview_length_spin_box.set_value_no_signal(settings.description_preview_length)


func reset_buttons() -> void:
	reset_default_settings_button.text = "Reset Default Settings"


#func full_scan() -> void:
	#scanned_profiles = []
	#scan_data = TaskTrackingGlobal.active_data
	#scan_section(scan_data.spreadsheet_year_data)
	#scan_section(scan_data.spreadsheet_month_data)
	#scan_section(scan_data.spreadsheet_week_data)
	#scan_section(scan_data.spreadsheet_day_data)


#func scan_section(target_section) -> void: 
	#for task_iteration in target_section:
		#for month_iteration in task_iteration.month_checkbox_dictionary:
			#var checkbox_array = task_iteration.month_checkbox_dictionary[month_iteration]
			#for checkbox_iteration in checkbox_array:
				#var profile_iteration: Array = checkbox_iteration.assigned_user
				#if scanned_profiles.has(profile_iteration):
					#continue
				#if profile_iteration == TaskTrackingGlobal.default_profile:
					#continue
				#scanned_profiles.append(profile_iteration)
				#prints(profile_iteration[0], "added to Scan Array")


#func full_purge(profile_to_purge) -> void:
	#scan_data = TaskTrackingGlobal.active_data
	#purge_section(scan_data.spreadsheet_year_data, profile_to_purge)
	#purge_section(scan_data.spreadsheet_month_data, profile_to_purge)
	#purge_section(scan_data.spreadsheet_week_data, profile_to_purge)
	#purge_section(scan_data.spreadsheet_day_data, profile_to_purge)
	#prints("Purge complete")


#func purge_section(target_section, target_profile) -> void:
	#for task_iteration in target_section:
		#if task_iteration.assigned_user == target_profile:
			#task_iteration.assigned_user = TaskTrackingGlobal.default_profile
		#for month_iteration in task_iteration.month_checkbox_dictionary:
			#var checkbox_array = task_iteration.month_checkbox_dictionary[month_iteration]
			#for checkbox_iteration in checkbox_array:
				#var profile_iteration: Array = checkbox_iteration.assigned_user
				#if profile_iteration == target_profile:
					#checkbox_iteration.assigned_user = TaskTrackingGlobal.default_profile
					#checkbox_iteration.checkbox_status = TaskTrackingGlobal.Checkbox.ACTIVE


func reload_settings() -> void:
	TaskTrackingGlobal.save_task_tracking_settings()
	load_all_settings()


#func create_sheet_data_deathrow_button(task_set_info: Array) -> void:
	#var deathrow_button : Button = Button.new()
	#var type: String = "sheet data"
	#deletion_grid_container.add_child(deathrow_button)
	#var loaded_name: String = task_set_info[0]
	#var loaded_year := str(task_set_info[1])
	#deathrow_button.text = loaded_name + "\n" + loaded_year
	#deathrow_button.pressed.connect(
		#_on_deathrow_button_pressed.bind(deathrow_button, type, task_set_info)
	#)
#
#
#func create_profile_deathrow_button(target_profile: Array, type: String) -> void:
	#var deathrow_button : Button = Button.new()
	#deletion_grid_container.add_child(deathrow_button)
	#deathrow_button.text = target_profile[0]
	#deathrow_button.add_theme_color_override("font_color", target_profile[1])
	#deathrow_button.pressed.connect(
		#_on_deathrow_button_pressed.bind(deathrow_button, type, target_profile)
	#)


func grab_active_task_set_info() -> Array:
	var active_task_set_info = [
		TaskTrackingGlobal.active_data.task_set_title,
		TaskTrackingGlobal.active_data.task_set_year,
		]
	return active_task_set_info


#func regen_all_checkboxes() -> void:
	#prints("Checkbox Regen Signal recieved")
	#if (settings.reset_current_checkboxes_section == 0
		#or settings.reset_current_checkboxes_section == 1
	#): 
		#regen_section_checkboxes(TaskTrackingGlobal.active_data.spreadsheet_year_data)
		#prints("Year Regened")
	#if (settings.reset_current_checkboxes_section == 0
		#or settings.reset_current_checkboxes_section == 2
	#): 
		#regen_section_checkboxes(TaskTrackingGlobal.active_data.spreadsheet_month_data)
		#prints("Month Regened")
	#if (settings.reset_current_checkboxes_section == 0
		#or settings.reset_current_checkboxes_section == 3
	#): 
		#regen_section_checkboxes(TaskTrackingGlobal.active_data.spreadsheet_week_data)
		#prints("Week Regened")
	#if (settings.reset_current_checkboxes_section == 0
		#or settings.reset_current_checkboxes_section == 4
	#): 
		#regen_section_checkboxes(TaskTrackingGlobal.active_data.spreadsheet_day_data)
		#prints("Day Regened")


#func regen_section_checkboxes(section) -> void:
	#for task_data in section:
		#var month_checkbox_dictionary = task_data.month_checkbox_dictionary
		#for month_iteration in month_checkbox_dictionary:
			#match month_iteration:
				#"All":
					#continue
				#"January":
					#if regen_section_check(1):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"February":
					#if regen_section_check(2):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"March":
					#if regen_section_check(3):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"April":
					#if regen_section_check(4):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"May":
					#if regen_section_check(5):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"June":
					#if regen_section_check(6):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"July":
					#if regen_section_check(7):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"August":
					#if regen_section_check(8):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"September":
					#if regen_section_check(9):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"October":
					#if regen_section_check(10):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"November":
					#if regen_section_check(11):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
				#"December":
					#if regen_section_check(12):
						#task_data.month_checkbox_dictionary[month_iteration].clear()
		#task_data.generate_all_checkboxes()


#func regen_section_check(month_check_parameter: int) -> bool:
	#var is_section_targeted: bool = (
		#settings.reset_current_checkboxes_month == 0
		#or settings.reset_current_checkboxes_month == month_check_parameter
	#)
	#return is_section_targeted


#func load_reset_current_checkbox_options() -> void:
	#reset_checkboxes_section_option_button.select(settings.reset_current_checkboxes_section)
	#match settings.reset_current_checkboxes_section:
		#0, 1, 2:
			#settings.reset_current_checkboxes_month = 0
			#reset_checkboxes_month_option_button.disabled = true
		#_:
			#pass
	#reset_checkboxes_month_option_button.select(settings.reset_current_checkboxes_month)


func _on_menu_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_main_menu.tscn")


func _on_sheets_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_editor.tscn")


#func _on_regen_profiles_button_pressed() -> void:
	#full_scan()
	#TaskTrackingGlobal.active_data.user_profiles.clear()
	#for scan_iteration in scanned_profiles:
		#TaskTrackingGlobal.active_data.user_profiles.append(scan_iteration)
	#TaskTrackingGlobal.save_settings_task_tracking()
	#TaskSignalBus._on_profile_selection_changed.emit() #better signal to emit?


func _on_auto_load_check_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		settings.enable_auto_load_default_data = false
		reload_settings()
		return
	if not settings.autoload_database_path:
		prints("Default data is needed to enable auto-load")
		DataGlobal.button_based_message(default_data_display_button,
			"Auto-load requires Default Data"
		)
		auto_load_check_button.set_pressed_no_signal(false)
		return
	settings.enable_auto_load_default_data = true
	reload_settings()


func _on_reset_default_settings_button_pressed() -> void:
	if reset_default_settings_button.text == "Reset Default Settings":
		reset_default_settings_button.text = "Confirm Settings Reset"
		return
	settings.reset_task_tracking_settings()
	reload_settings()


func _on_set_default_data_button_pressed() -> void:
	if not SqlManager.database_is_active:
		prints("No data to set as default")
		DataGlobal.button_based_message(default_data_display_button, "No Data to set as Default!")
		return
	settings.autoload_database_path = SqlManager.database_path
	reload_settings()


func _on_task_new_checkbox_options_button_group_pressed(pressed_button: Button) -> void:
	match pressed_button.name:
		"SetActiveButton":
			settings.current_new_checkbox_option = new_checkbox_options.ACTIVE
		"SetExpiredButton":
			settings.current_new_checkbox_option = new_checkbox_options.EXPIRED
		"SetAssignedButton":
			settings.current_new_checkbox_option = new_checkbox_options.ASSIGNED
	reload_settings()


func _on_deletion_safety_check_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		settings.enable_deletion_buttons = false
	if button_pressed:
		settings.enable_deletion_buttons = true
	reload_settings()


#func _on_deletion_back_button_pressed() -> void:
	#deletion_background_panel_container.visible = false
	#var deletion_children = deletion_grid_container.get_children()
	#for child_iteration in deletion_children:
		#deletion_grid_container.remove_child(child_iteration)
		#child_iteration.queue_free()
#
#
#func _on_remove_profile_button_pressed() -> void:
	#if not TaskTrackingGlobal.active_data:
		#prints("Remove Profile Error: No data to load profiles from")
		#DataGlobal.button_based_message(remove_profile_button,
			#"Error: No data to load profiles from!"
		#)
		#return
	#deletion_background_panel_container.visible = true
	#for profile_iteration in TaskTrackingGlobal.active_data.user_profiles:
		#create_profile_deathrow_button(profile_iteration, "profile")
#
#
#func _on_delete_task_sheet_button_pressed() -> void:
	#deletion_background_panel_container.visible = true
	#var task_sets_info = DataGlobal.get_task_sets_info()
	#for set_info in task_sets_info:
		#create_sheet_data_deathrow_button(set_info)


#func _on_deathrow_button_pressed(pressed_button: Button, remove_type: String,
	#target: Array
#) -> void:
	#prints("Deathrow button pressed")
	#pressed_button.queue_free()
	#match remove_type:
		#"profile":
			#TaskTrackingGlobal.active_data.user_profiles.erase(target)
			#TaskTrackingGlobal.save_data_task_set()
		#"profile data":
			##full_purge(target)
			#TaskTrackingGlobal.save_data_task_set()
		#"sheet data":
			#if TaskTrackingGlobal.active_settings.default_data == target:
				#TaskTrackingGlobal.active_settings.default_data = []
			#if TaskTrackingGlobal.active_data:
				#if grab_active_task_set_info() == target:
					#TaskTrackingGlobal.active_data = null
			#reload_settings()
			#var target_filepath = DataGlobal.generate_task_set_filepath(target[0], target[1])
			#OS.move_to_trash(ProjectSettings.globalize_path(target_filepath))


#func _on_purge_profile_data_button_pressed() -> void:
	#if not TaskTrackingGlobal.active_data:
		#prints("Purge Profile Data Error: No data to load profiles from")
		#DataGlobal.button_based_message(purge_profile_data_button,
			#"Error: No data to load profiles from!"
		#)
		#return
	#deletion_background_panel_container.visible = true
	#full_scan()
	#for scanned_profile_iteration in scanned_profiles:
		#create_profile_deathrow_button(scanned_profile_iteration, "profile data")


func _on_description_preview_length_spin_box_value_changed(value: float) -> void:
	var int_value = value as int
	settings.description_preview_length = int_value
	reload_settings()


func _on_unload_current_data_button_pressed() -> void:
	TaskTrackingGlobal.active_data = null
	TaskTrackingGlobal.current_checkbox_profile = TaskTrackingGlobal.default_profile
	TaskTrackingGlobal.current_checkbox_state = TaskTrackingGlobal.Checkbox.ACTIVE
	if settings.enable_auto_load_default_data:
		settings.enable_auto_load_default_data = false
	reload_settings()


func _on_reset_checkboxes_button_pressed() -> void:
	if reset_checkboxes_button.text == "Reset Current Checkboxes":
		DataGlobal.button_based_message(reset_checkboxes_button, "CONFIRM Clear and Reset?", 6)
		return
	if reset_checkboxes_button.text == "CONFIRM Clear and Reset?":
		reset_checkboxes_button.text = "Reset Current Checkboxes"
		#regen_all_checkboxes()
		TaskTrackingGlobal.save_task_tracking_settings()
		DataGlobal.button_based_message(reset_checkboxes_button, "RESET SUCCESSFUL!")



#func _on_reset_checkboxes_section_option_button_item_selected(index: int) -> void:
	#settings.reset_current_checkboxes_section = index
	#prints("Reset Checkboxes Section selected:",
		#reset_checkboxes_section_option_button.get_item_text(index), index
	#)
	#reload_settings()


#func _on_reset_checkboxes_month_option_button_item_selected(index: int) -> void:
	#settings.reset_current_checkboxes_month = index
	#prints("Reset Checkboxes Month selected:",
		#reset_checkboxes_month_option_button.get_item_text(index), index
	#)
	#reload_settings()
