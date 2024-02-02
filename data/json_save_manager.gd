extends Node

@export var user_folder: String = "user://"
@export var task_tracker_folder = "user://task_tracker_data/"
@export var json_extension: String = ".json"

enum FileType {SETTINGS, TASK_TRACKING}



func generate_filepath(save_name_parameter: String, current_file_type: FileType) -> String:
	var save_filepath: String
	if current_file_type == FileType.SETTINGS:
		save_filepath = user_folder + save_name_parameter + json_extension
		return save_filepath
	if current_file_type == FileType.TASK_TRACKING:
		save_filepath = task_tracker_folder + save_name_parameter + json_extension
		return save_filepath
	prints("Generate_filepath error for FileType:", current_file_type)
	return "ERROR"


func load_data(name_parameter: String,  file_type_parameter: FileType):
	var file_path = generate_filepath(name_parameter, file_type_parameter)
	var file_to_load = FileAccess.open(file_path, FileAccess.READ)
	var loaded_data = JSON.parse_string(file_to_load.get_as_text())
	return loaded_data


func save_data(name_parameter: String, file_type_parameter: FileType, save_data_parameter) -> void:
	var file_path = generate_filepath(name_parameter, file_type_parameter)
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	save_file.store_string(JSON.stringify(save_data_parameter))
	save_file.close()
	save_file = null
