extends PanelContainer

@export var visibility_node: Control

@onready var current_database_label: Label = %CurrentDatabaseLabel
@onready var database_grid: GridContainer = %DatabaseGrid
@onready var new_database_button: Button = %NewDatabaseButton
@onready var new_database_panel: PanelContainer = %NewDatabasePanel
@onready var database_title_line_edit: LineEdit = %DatabaseTitleLineEdit
@onready var database_accept_button: Button = %DatabaseAcceptButton
@onready var clone_database_button: Button = %CloneDatabaseButton
@onready var clone_database_panel: PanelContainer = %CloneDatabasePanel
@onready var close_manager_button: Button = %CloseManager
@onready var clone_data_button: Button = %CloneDataButton
@onready var clone_data_panel: PanelContainer = %CloneDataPanel
@onready var clone_label: Label = %CloneLabel
@onready var clone_line_edit: LineEdit = %CloneLineEdit
@onready var clone_back_button: Button = %CloneBackButton
@onready var clone_accept_button: Button = %CloneAcceptButton




const DATABASE_FILE_BUTTON = preload("res://gui/task_tracking/database_manager/database_file_button.tscn")
const DATABASE_FILE_BUTTON_GROUP = preload("res://gui/task_tracking/database_manager/database_file_button_group.tres")
#var task_save_button_group = preload("res://gui/task_tracking/data_manager/task_save_button_group.tres")
#var task_save_button = preload("res://gui/task_tracking/data_manager/task_save_button.tscn")



var safe_lock_active: bool
var database_file_button_count: int = 4
#var empty_string := ""
var database_file_button_group_string := "database_file_buttons"
var retoggle_button_group_string := "retoggle_button_group"




func _ready() -> void:
	connect_signal_bus()
	starting_visibilities()
	populate_database_grid()
	if SqlManager.database_is_active:
		update_current_database_label()


func connect_signal_bus() -> void:
	TaskSignalBus._on_new_database_loaded.connect(update_current_database_label)
	TaskSignalBus._on_data_modified.connect(safety_toggle.bind(true))
	TaskSignalBus._on_data_saved.connect(safety_toggle.bind(false))


func safety_toggle(new_bool) -> void:
	safe_lock_active = new_bool


func update_current_database_label() -> void:
	var new_label = "Current Data: " + SqlManager.database_name
	current_database_label.text = new_label


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


func new_database_title_field_reset() -> void:
	database_title_line_edit.clear()


func create_database_file_button(path_param: String, name_param: String) -> void:
	var new_database_file_button: Control = DATABASE_FILE_BUTTON.instantiate()
	database_grid.add_child(new_database_file_button)
	database_grid.move_child(new_database_file_button, database_file_button_count)
	new_database_file_button.load_path_and_name(path_param, name_param)
	new_database_file_button.add_to_group(database_file_button_group_string)
	database_file_button_count += 1
	var actual_button: Button = new_database_file_button.functional_button
	#actual_button.toggled.connect(_on_database_save_button_pressed.bind(name_param))
	actual_button.set_button_group(DATABASE_FILE_BUTTON_GROUP)


func clone_menu_open() -> void:
	clone_data_button.visible = false
	clone_data_panel.visible = true


func clone_menu_reset() -> void:
	if SqlManager.database_is_active:
		clone_data_button.visible = true
		clone_data_panel.visible = false
		clone_back_button.visible = false
		clone_menu_update()
	else:
		clone_data_button.visible = false
		clone_data_panel.visible = false


func clone_menu_update() -> void:
	clone_label.text = "Clone Title"
	clone_line_edit.text = SqlManager.database_name
	clone_line_edit.visible = true


func reset_data_manager() -> void:
	for panel_iteration in get_tree().get_nodes_in_group("task_save_panels"):
		database_grid.remove_child(panel_iteration)
		panel_iteration.queue_free()
	populate_database_grid()


func _on_new_database_button_pressed() -> void:
	show_new_database_panel()


func _on_database_cancel_button_pressed() -> void:
	show_new_database_button()


func _on_database_accept_button_pressed() -> void:
	if not database_title_line_edit.text:
		printerr("Task Set needs title, not accepted")
		DataGlobal.button_based_message(database_accept_button, "Title Needed!")
		return
	var new_database_name: String = database_title_line_edit.text
	var new_database_path: String
#	create new database
	create_database_file_button(new_database_path, new_database_name)
	new_database_title_field_reset()
	show_new_database_button()


func _on_database_file_button_pressed(button_pressed: bool, path_param: String, name_param: String):
	if not button_pressed:
		return
	prints("Database Button Pressed:", name_param)
	if SqlManager.database_is_active:
		if SqlManager.database_name == name_param:
			prints("Database already active, skipping.")
			DataGlobal.button_based_message(current_database_label, "Data Already Loaded!") 
			return
	if safe_lock_active:
		TaskTrackingGlobal.save_data_task_set()
#	load database
	DataGlobal.task_set_data_reloaded()
	clone_menu_reset()
	clone_menu_update()


func _on_clone_database_button_pressed() -> void:
	clone_menu_open()


func _on_clone_accept_button_pressed() -> void:
	if clone_label.text == "Clone Title":
		clone_line_edit.visible = false
		clone_back_button.visible = true
		clone_label.text = "Clone Year"
		return
	if clone_label.text == "Clone Year" or "File Already Exists!\n(Change Title or Year)":
		var cloned_title: String = clone_line_edit.text
		var cloned_path: String
		if FileAccess.file_exists(cloned_path):
			prints("File already exists! Clone needs different year or title...")
			DataGlobal.button_based_message(clone_accept_button, "Error!")
			DataGlobal.button_based_message(clone_label,
				"File Already Exists!\n(Change Title or Year)"
			)
			return
#		create cloned database
		create_database_file_button(cloned_path, cloned_title)


func _on_clone_cancel_button_pressed() -> void:
	clone_menu_reset()


func _on_clone_back_button_pressed() -> void:
	clone_line_edit.visible = true
	clone_back_button.visible = false
	clone_label.text = "Clone Title"


func _on_close_manager_pressed() -> void:
	TaskSignalBus._on_database_manager_close_manager_button_pressed.emit()
