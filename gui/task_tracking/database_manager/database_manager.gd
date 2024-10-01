extends PanelContainer

@export var visibility_node: Control

@onready var current_database_label: Label = %CurrentDatabaseLabel
@onready var database_grid: GridContainer = %DatabaseGrid
@onready var new_database_button: Button = %NewDatabaseButton
@onready var new_database_panel: PanelContainer = %NewDatabasePanel
@onready var database_accept_button: Button = %DatabaseAcceptButton
@onready var clone_database_button: Button = %CloneDatabaseButton
@onready var clone_database_panel: PanelContainer = %CloneDatabasePanel
@onready var close_manager_button: Button = %CloseManager
#@onready var clone_back_button: Button = %CloneBackButton
@onready var clone_accept_button: Button = %CloneAcceptButton
@onready var new_database_label: Label = %NewDatabaseLabel
@onready var household_name_line_edit: LineEdit = %HouseholdNameLineEdit
@onready var database_title_line_edit: LineEdit = %DatabaseTitleLineEdit
@onready var file_name_preview_label: Label = %FileNamePreviewLabel
@onready var clone_label: Label = %CloneLabel
@onready var clone_household_name_line_edit: LineEdit = %CloneHouseholdNameLineEdit
@onready var clone_database_title_line_edit: LineEdit = %CloneDatabaseTitleLineEdit
@onready var clone_file_preview_label: Label = %CloneFilePreviewLabel



const DATABASE_FILE_BUTTON = preload("res://gui/task_tracking/database_manager/database_file_button.tscn")
const DATABASE_FILE_BUTTON_GROUP = preload("res://gui/task_tracking/database_manager/database_file_button_group.tres")
#var task_save_button_group = preload("res://gui/task_tracking/data_manager/task_save_button_group.tres")
#var task_save_button = preload("res://gui/task_tracking/data_manager/task_save_button.tscn")

var database_not_loaded_text: String = "[ Database Not Loaded ]"
var error_text: String = "Error!"
var database_exists_text: String = "Database already exists! (Change name)"
var name_needed_text: String = "Name needed"
var panel_title_label_message_bundle: PackedStringArray = [database_exists_text, name_needed_text]
var clone_database_text: String = "Database Clone Name"
var file_preview_text: String = "( Preview )"
var safe_lock_active: bool
var database_file_button_count: int = 4
#var empty_string := ""
var database_file_button_group_string := "database_file_buttons"
var retoggle_button_group_string := "retoggle_button_group"




func _ready() -> void:
	connect_signal_bus()
	connect_panels_submitted_text()
	starting_visibilities()
	populate_database_grid()
	manager_reset()


func connect_signal_bus() -> void:
	TaskSignalBus._on_new_database_loaded.connect(manager_reset)
	TaskSignalBus._on_data_modified.connect(safety_toggle.bind(true))
	TaskSignalBus._on_data_saved.connect(safety_toggle.bind(false))


func connect_panels_submitted_text() -> void:
	household_name_line_edit.text_changed.connect(new_database_name_updated)
	database_title_line_edit.text_changed.connect(new_database_title_updated)
	clone_household_name_line_edit.text_changed.connect(clone_database_name_updated)
	clone_database_title_line_edit.text_changed.connect(clone_database_title_updated)


func manager_reset() -> void:
	update_current_database_label()
	new_database_menu_reset()
	clone_menu_reset()


func new_database_name_updated(new_string: String) -> void:
	update_preview_with_name(new_string, file_name_preview_label)
	unused_line_edit_lockout(household_name_line_edit, database_title_line_edit)


func new_database_title_updated(new_string: String) -> void:
	update_preview_with_title(new_string, file_name_preview_label)
	unused_line_edit_lockout(household_name_line_edit, database_title_line_edit)


func clone_database_name_updated(new_string: String) -> void:
	update_preview_with_name(new_string, clone_file_preview_label)
	unused_line_edit_lockout(clone_household_name_line_edit, clone_database_title_line_edit)


func clone_database_title_updated(new_string: String) -> void:
	update_preview_with_title(new_string, clone_file_preview_label)
	unused_line_edit_lockout(clone_household_name_line_edit, clone_database_title_line_edit)


func update_preview_with_name(name_param: String, preview_label: Label) -> void:
	if name_param == "":
		preview_label.text = file_preview_text
		return
	var new_name: String = name_param + SqlManager.database_standard_title
	preview_label.text = new_name.capitalize()


func update_preview_with_title(title_param: String, preview_label: Label) -> void:
	if title_param == "":
		preview_label.text = file_preview_text
		return
	preview_label.text = title_param.capitalize()


func safety_toggle(new_bool) -> void:
	safe_lock_active = new_bool


func update_current_database_label() -> void:
	if not SqlManager.database_is_active:
		current_database_label.text = database_not_loaded_text
		return
	if SqlManager.database_name == "":
		breakpoint
	current_database_label.text = SqlManager.database_name


func starting_visibilities() -> void:
	new_database_panel.visible = false
	clone_menu_reset()


func populate_database_grid() -> void:
	var database_paths: Array = SqlManager.get_existing_database_files()
	var database_names: Array = get_database_file_names(database_paths)
	for database_iteration in database_paths.size():
		create_database_file_button(database_paths[database_iteration], database_names[database_iteration])
	get_tree().call_group(database_file_button_group_string, retoggle_button_group_string)


func get_database_file_names(paths_parameter: Array) -> Array:
	var full_database_paths: Array = paths_parameter
	var database_file_names: Array
	for file_iteration: String in full_database_paths:
		var iteration_name = SqlManager.get_database_name_from_path(file_iteration)
		database_file_names.append(iteration_name)
	return database_file_names


func show_new_database_panel() -> void:
	new_database_panel.visible = true
	new_database_button.visible = false


func show_new_database_button() -> void:
	new_database_button.visible = true
	new_database_panel.visible = false


func reset_menus() -> void:
	new_database_menu_reset()
	clone_menu_reset()


func new_database_menu_reset() -> void:
	household_name_line_edit.clear()
	database_title_line_edit.clear()
	show_new_database_button()


func create_database_file_button(path_param: String, name_param: String) -> void:
	var new_database_file_button: Control = DATABASE_FILE_BUTTON.instantiate()
	database_grid.add_child(new_database_file_button)
	database_grid.move_child(new_database_file_button, database_file_button_count)
	new_database_file_button.load_path_and_name(path_param, name_param)
	new_database_file_button.add_to_group(database_file_button_group_string)
	database_file_button_count += 1
	var actual_button: Button = new_database_file_button.functional_button
	actual_button.set_button_group(DATABASE_FILE_BUTTON_GROUP)


func clone_menu_open() -> void:
	clone_database_button.visible = false
	clone_database_panel.visible = true


func clone_menu_reset() -> void:
	clone_database_panel.visible = false
	if SqlManager.database_is_active:
		clone_database_button.visible = true
		clone_household_name_line_edit.clear()
		clone_database_title_line_edit.clear()
	else:
		clone_database_button.visible = false


func reset_data_manager() -> void:
	for database_iteration in get_tree().get_nodes_in_group(database_file_button_group_string):
		database_grid.remove_child(database_iteration)
		database_iteration.queue_free()
	populate_database_grid()


func unused_line_edit_lockout(name_line: LineEdit, title_line: LineEdit) -> void:
	title_line.editable = name_line.text.is_empty()
	name_line.editable = title_line.text.is_empty()


func database_panel_accepted(
	name_param: String,
	title_param: String,
	panel_label: Label,
	preview_label: Label,
	accept_button: Button,
)-> void:
	if name_param == "" and title_param == "":
		DataGlobal.button_based_message(accept_button, error_text)
		DataGlobal.button_based_message(panel_label, name_needed_text, 2, panel_title_label_message_bundle)
		return
	if preview_label.text.to_snake_case() == SqlManager.database_name.to_snake_case():
		DataGlobal.button_based_message(accept_button, error_text)
		DataGlobal.button_based_message(panel_label, database_exists_text, 4, panel_title_label_message_bundle)
		return
	var current_path: String = SqlManager.create_database_path(preview_label.text)
	var current_name: String = SqlManager.create_database_name(current_path)
	SqlManager.unload_database()
	SqlManager.set_database_name_and_path(current_name, current_path)
	SqlManager.load_database()
	create_database_file_button(current_path, current_name)


func _on_new_database_button_pressed() -> void:
	show_new_database_panel()


func _on_database_cancel_button_pressed() -> void:
	show_new_database_button()


func _on_database_accept_button_pressed() -> void:
	database_panel_accepted(
		household_name_line_edit.text,
		database_title_line_edit.text,
		new_database_label,
		file_name_preview_label,
		database_accept_button,
	)
	new_database_menu_reset()


func _on_clone_database_button_pressed() -> void:
	clone_menu_open()


func _on_clone_cancel_button_pressed() -> void:
	clone_menu_reset()


func _on_clone_accept_button_pressed() -> void:
	database_panel_accepted(
		clone_household_name_line_edit.text,
		clone_database_title_line_edit.text,
		clone_label,
		clone_file_preview_label,
		clone_accept_button,
	)
	clone_menu_reset()


func _on_close_manager_pressed() -> void:
	TaskSignalBus._on_database_manager_remote_close_pressed.emit()
