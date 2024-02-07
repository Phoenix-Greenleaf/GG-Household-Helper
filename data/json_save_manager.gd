extends Node


func load_data(filepath_parameter: String):
	var file_to_load = FileAccess.open(filepath_parameter, FileAccess.READ)
	var loaded_json_data = JSON.parse_string(file_to_load.get_as_text())
	return loaded_json_data


func save_data(filepath_parameter: String, save_data_parameter) -> void:
	var file_to_save = FileAccess.open(filepath_parameter, FileAccess.WRITE)
	file_to_save.store_string(JSON.stringify(save_data_parameter))
	file_to_save.close()
	file_to_save = null
