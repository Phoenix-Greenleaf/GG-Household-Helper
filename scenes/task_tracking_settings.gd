extends PanelContainer

var scanned_profiles: Array
var current_data: TaskSpreadsheetData



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/task_tracking_menu.tscn")


func _on_regen_profiles_button_pressed() -> void:
	prints()
#	prints("Regenerating Profiles")
	scanned_profiles = []
	if DataGlobal.current_tasksheet_data.user_profiles.size() > 0:
		prints("Aborting Regen, profiles exist:")
		for existing in DataGlobal.current_tasksheet_data.user_profiles:
			prints(DataGlobal.current_tasksheet_data.user_profiles[0])
		return
	current_data = DataGlobal.current_tasksheet_data
#	prints("Scanning Year Section")
	scan_section(current_data.spreadsheet_year_data)
#	prints("Scanning Month Section")
	scan_section(current_data.spreadsheet_month_data)
#	prints("Scanning Week Section")
	scan_section(current_data.spreadsheet_week_data)
#	prints("Scanning Day Section")
	scan_section(current_data.spreadsheet_day_data)
	for scan_iteration in scanned_profiles:
		DataGlobal.current_tasksheet_data.user_profiles.append(scan_iteration)
	prints("Profiles founds:", scanned_profiles.size())


func scan_section(target_section) -> void:
#	prints("Section contains:", target_section.size(), target_section)
	for task_iteration in target_section:
#		prints("Scanning task:", task_iteration.name)
#		prints("Checkbox Dictionary Months:", task_iteration.month_checkbox_dictionary)
		for month_iteration in task_iteration.month_checkbox_dictionary:
			var checkbox_array = task_iteration.month_checkbox_dictionary[month_iteration]
#			prints("Month", month_iteration, "has", checkbox_array.size())
			for checkbox_iteration in checkbox_array:
				var profile_iteration: Array = checkbox_iteration.assigned_user
				if scanned_profiles.has(profile_iteration):
#					prints(profile_iteration[0], "already in Scan Array")
					continue
				if profile_iteration == DataGlobal.default_profile:
#					prints("Skipping default profile")
					continue
				scanned_profiles.append(profile_iteration)
#				prints(profile_iteration[0], "added to Scan Array")
	SignalBus.reload_profiles_triggered.emit()


func _on_wipe_profiles_button_pressed() -> void:
	DataGlobal.current_tasksheet_data.user_profiles.clear()
	prints("Profiles got wiped")
