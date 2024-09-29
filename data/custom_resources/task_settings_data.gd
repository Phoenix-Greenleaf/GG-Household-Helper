extends Resource

class_name TaskSettingsData

enum NewCheckboxOption {ACTIVE, EXPIRED, ASSIGNED}

@export var enable_auto_load_default_data: bool:
	set(value):
		enable_auto_load_default_data = value
		if settings_active:
			TaskSignalBus._on_task_editing_settings_changed.emit()
@export var autoload_database_path: String:
	set(value):
		autoload_database_path = value
		if settings_active:
			TaskSignalBus._on_task_editing_settings_changed.emit()
@export var current_new_checkbox_option: NewCheckboxOption:
	set(value):
		current_new_checkbox_option = value
		if settings_active:
			TaskSignalBus._on_task_editing_settings_changed.emit()
@export var description_preview_length: int:
	set(value):
		description_preview_length = value
		if settings_active:
			TaskSignalBus._on_task_editing_settings_changed.emit()
#@export var reset_current_checkboxes_section: int
#@export var reset_current_checkboxes_month: int

var enable_deletion_buttons: bool = false
var settings_active: bool = false



func export_json_from_resouce() -> Dictionary:
	var json_data: Dictionary = {
		"enable_auto_load_default_data": enable_auto_load_default_data,
		"autoload_database_path": autoload_database_path,
		#"enable_deletion_buttons": enable_deletion_buttons,
		"current_new_checkbox_option": current_new_checkbox_option,
		"description_preview_length": description_preview_length,
		#"reset_current_checkboxes_section": reset_current_checkboxes_section,
		#"reset_current_checkboxes_month": reset_current_checkboxes_month,
	}
	return json_data


func import_json_to_resource(data_parameter: Dictionary) -> void:
	settings_active = false
	enable_auto_load_default_data = data_parameter.enable_auto_load_default_data
	autoload_database_path = data_parameter.autoload_database_path
	#enable_deletion_buttons = data_parameter.enable_deletion_buttons
	enable_deletion_buttons = false
	current_new_checkbox_option = data_parameter.current_new_checkbox_option
	description_preview_length = data_parameter.description_preview_length
	#reset_current_checkboxes_section = data_parameter.reset_current_checkboxes_section
	#reset_current_checkboxes_month = data_parameter.reset_current_checkboxes_month
	settings_active = true


func reset_settings() -> void:
	settings_active = false
	enable_auto_load_default_data = false
	autoload_database_path = ""
	enable_deletion_buttons = false
	current_new_checkbox_option = NewCheckboxOption.ASSIGNED
	description_preview_length = 50
	autoload_database_path = ""
	#reset_current_checkboxes_section = 0
	#reset_current_checkboxes_month = 0
	settings_active = true # could move this up and autosave after the reset
	prints("Task Tracking Settings reset to defaults.")
