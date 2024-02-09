extends Resource

class_name TaskSettingsData

enum NewCheckboxOption {ACTIVE, EXPIRED, ASSIGNED}

@export var enable_auto_load_default_data: bool
@export var default_data: Array
@export var enable_deletion_buttons: bool
@export var current_new_checkbox_option: NewCheckboxOption
@export var description_preview_length: int
@export var reset_current_checkboxes_section: int
@export var reset_current_checkboxes_month: int



func _init() -> void:
	DisplayServer.window_set_min_size(Vector2i(500, 500))
	prints("Minimun window size applied")


func export_json_from_resouce() -> Dictionary:
	var json_data: Dictionary = {
		"enable_auto_load_default_data": enable_auto_load_default_data,
		"default_data": default_data,
		"enable_deletion_buttons": enable_deletion_buttons,
		"current_new_checkbox_option": current_new_checkbox_option,
		"description_preview_length": description_preview_length,
		"reset_current_checkboxes_section": reset_current_checkboxes_section,
		"reset_current_checkboxes_month": reset_current_checkboxes_month,
	}
	return json_data


func import_json_to_resource(data_parameter: Dictionary) -> void:
	enable_auto_load_default_data = data_parameter.enable_auto_load_default_data
	default_data = data_parameter.default_data
	enable_deletion_buttons = data_parameter.enable_deletion_buttons
	current_new_checkbox_option = data_parameter.current_new_checkbox_option
	description_preview_length = data_parameter.description_preview_length
	reset_current_checkboxes_section = data_parameter.reset_current_checkboxes_section
	reset_current_checkboxes_month = data_parameter.reset_current_checkboxes_month


func reset_settings() -> void:
	enable_auto_load_default_data = false
	default_data = []
	enable_deletion_buttons = false
	current_new_checkbox_option = NewCheckboxOption.ASSIGNED
	description_preview_length = 50
	reset_current_checkboxes_section = 0
	reset_current_checkboxes_month = 0
	prints("Task Tracking Settings reset to defaults.")
