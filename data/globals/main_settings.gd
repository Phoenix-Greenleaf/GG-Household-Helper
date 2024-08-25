extends Node


# main settings


func create_settings_main() -> void:
	active_settings_main = MainSettingsData.new()
	active_settings_main.reset_settings_all_main()
	prints("New main settings data created")
	save_settings_main()


func save_settings_main() -> void:
	var json_data = active_settings_main.export_json_from_resouce()
	JsonSaveManager.save_data(filepath_main_settings, json_data)
	prints("Main settings data saved")


func load_settings_main() -> void:
	directory_check(settings_folder)
	if active_settings_main:
		prints("Main settings exist")
		return
	if not FileAccess.file_exists(filepath_main_settings):
		prints("Creating new main settings")
		create_settings_main()
		return
	prints("Loading main settings")
	active_settings_main = MainSettingsData.new()
	var json_data = JsonSaveManager.load_data(filepath_main_settings)
	active_settings_main.import_json_to_resource(json_data)
