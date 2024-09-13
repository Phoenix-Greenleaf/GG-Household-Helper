extends PanelContainer

@export var visibility_node: Control


@onready var database_grid: GridContainer = %DatabaseGrid




@onready var close_manager_button: Button = %CloseManager
@onready var import_task_file_dialog: FileDialog = $ImportTaskFileDialog
@onready var task_data_title_line_edit: LineEdit = %TaskDataTitleLineEdit
@onready var new_task_panel: PanelContainer = %NewTaskPanel
@onready var new_task_button: Button = %NewTaskButton
@onready var task_grid: GridContainer = %TaskGrid
@onready var current_tasksheet_label: Label = %CurrentTasksheetLabel
@onready var task_accept_button: Button = %TaskAcceptButton
@onready var clone_data_button: Button = %CloneDataButton
@onready var clone_data_panel: PanelContainer = %CloneDataPanel
@onready var clone_label: Label = %CloneLabel
@onready var clone_line_edit: LineEdit = %CloneLineEdit
@onready var clone_spin_box: SpinBox = %CloneSpinBox
@onready var clone_back_button: Button = %CloneBackButton
@onready var clone_accept_button: Button = %CloneAcceptButton




const DATABASE_FILE_BUTTON = preload("res://gui/task_tracking/database_manager/database_file_button.tscn")
const DATABASE_FILE_BUTTON_GROUP = preload("res://gui/task_tracking/database_manager/database_file_button_group.tres")
#var task_save_button_group = preload("res://gui/task_tracking/data_manager/task_save_button_group.tres")
#var task_save_button = preload("res://gui/task_tracking/data_manager/task_save_button.tscn")

var safe_lock_active: bool
var database_file_button_count: int = 4
var empty_string := ""

var database_file_button_group_string := "database_file_buttons"
var retoggle_button_group_string := "retoggle_button_group"


func _ready() -> void:
	connect_signal_bus()
	starting_visibilities()
	#load_existing_task_sets()
	if TaskTrackingGlobal.active_data:
		update_current_tasksheet_label()


func connect_signal_bus() -> void:
	TaskSignalBus._on_active_data_set_switched.connect(update_current_tasksheet_label)
	TaskSignalBus._on_data_set_modified.connect(safety_toggle.bind(true))
	TaskSignalBus._on_data_set_saved.connect(safety_toggle.bind(false))


func safety_toggle(new_bool) -> void:
	safe_lock_active = new_bool


func update_current_tasksheet_label() -> void:
	var intro_text = "Current Data: "
	var title = TaskTrackingGlobal.active_data.task_set_title
	var year = TaskTrackingGlobal.active_data.task_set_year
	var new_label = intro_text + title + ": " + str(year)
	current_tasksheet_label.text = new_label


func starting_visibilities() -> void:
	import_task_file_dialog.visible = false
	new_task_panel.visible = false
	clone_menu_reset()


func load_database_file_info() -> void:
	var database_files: Array = get_database_file_names()
	for iteration_name in database_files:
		create_database_file_button(iteration_name)
	get_tree().call_group(database_file_button_group_string, retoggle_button_group_string)


func get_database_file_names() -> Array:
	var full_database_paths: Array = SqlManager.get_existing_database_files()
	var database_file_names: Array
	for file_iteration: String in full_database_paths:
		var full_file_name: String = file_iteration.get_file()
		var file_name_without_extension: String = full_file_name.replace(".db", "")
		var capitalized_file_name: String = file_name_without_extension.capitalize()
		database_file_names.append(capitalized_file_name)
	return database_file_names




func show_new_task_panel() -> void:
	new_task_panel.visible = true
	new_task_button.visible = false


func show_new_task_button() -> void:
	new_task_button.visible = true
	new_task_panel.visible = false


func task_field_reset() -> void:
	task_data_title_line_edit.clear()


func create_database_file_button(target_name: String) -> void:
	var new_database_file_button := DATABASE_FILE_BUTTON.instantiate()
	database_grid.add_child(new_database_file_button)
	database_grid.move_child(new_database_file_button, database_file_button_count)
	new_database_file_button.task_set_name_label.text = target_name
	new_database_file_button.add_to_group(database_file_button_group_string)
	database_file_button_count += 1
	var actual_task_button: Button = new_database_file_button.get_node("FunctionalButton")
	actual_task_button.toggled.connect(_on_task_save_button_pressed.bind(target_name))
	actual_task_button.set_button_group(DATABASE_FILE_BUTTON_GROUP)





func clone_menu_open() -> void:
	clone_data_button.visible = false
	clone_data_panel.visible = true


func clone_menu_reset() -> void:
	if TaskTrackingGlobal.active_data:
		clone_data_button.visible = true
		clone_data_panel.visible = false
		clone_back_button.visible = false
		clone_menu_update()
	else:
		clone_data_button.visible = false
		clone_data_panel.visible = false


func clone_menu_update() -> void:
	clone_label.text = "Clone Title"
	clone_line_edit.text = TaskTrackingGlobal.active_data.task_set_title
	clone_line_edit.visible = true
	var new_year = TaskTrackingGlobal.active_data.task_set_year + 1
	clone_spin_box.set_value_no_signal(new_year)
	clone_spin_box.visible = false


func reset_data_manager() -> void:
	for panel_iteration in get_tree().get_nodes_in_group("task_save_panels"):
		task_grid.remove_child(panel_iteration)
		panel_iteration.queue_free()
	load_database_file_info()


func _on_import_task_file_dialog_file_selected(path: String) -> void:
	prints("File Dialogue import:", path)


func _on_new_task_button_pressed() -> void:
	show_new_task_panel()


func _on_task_cancel_button_pressed() -> void:
	show_new_task_button()


func _on_task_accept_button_pressed() -> void:
	if not task_data_title_line_edit.text:
		printerr("Task Set needs title, not accepted")
		DataGlobal.button_based_message(task_accept_button, "Title Needed!")
		return
	var new_tasksheet_name: String = task_data_title_line_edit.text
	TaskTrackingGlobal.create_data_task_set(new_tasksheet_name)
	create_database_file_button(new_tasksheet_name)
	task_field_reset()
	show_new_task_button()


func _on_task_save_button_pressed(button_pressed: bool, name_parameter: String, year_parameter: int):
	if not button_pressed:
		return
	prints("Test _on_task_save_button_pressed:", name_parameter, year_parameter)
	if TaskTrackingGlobal.active_data:
		if [name_parameter, year_parameter] == DataGlobal.get_active_task_set_info():
			prints("Tasksheet data already loaded, skipping.")
			DataGlobal.button_based_message(current_tasksheet_label, "Data Already Loaded!") 
			return
	if safe_lock_active:
		TaskTrackingGlobal.save_data_task_set()
	TaskTrackingGlobal.load_data_task_set(name_parameter, year_parameter)
	DataGlobal.task_set_data_reloaded()
	clone_menu_reset()
	clone_menu_update()


func _on_import_tasksheet_pressed() -> void:
	import_task_file_dialog.visible = true


func _on_clone_data_button_pressed() -> void:
	clone_menu_open()


func _on_clone_accept_button_pressed() -> void:
	if clone_label.text == "Clone Title":
		clone_line_edit.visible = false
		clone_spin_box.visible = true
		clone_back_button.visible = true
		clone_label.text = "Clone Year"
		return
	if clone_label.text == "Clone Year" or "File Already Exists!\n(Change Title or Year)":
		var cloned_title = clone_line_edit.text
		var cloned_year = int(clone_spin_box.value)
		if FileAccess.file_exists(DataGlobal.generate_task_set_filepath(cloned_title, cloned_year)):
			prints("File already exists! Clone needs different year or title...")
			DataGlobal.button_based_message(clone_accept_button, "Error!")
			DataGlobal.button_based_message(clone_label,
				"File Already Exists!\n(Change Title or Year)"
			)
			return
		DataGlobal.clone_task_set_data(cloned_title, cloned_year)
		create_database_file_button(cloned_title)
		


func _on_clone_cancel_button_pressed() -> void:
	clone_menu_reset()


func _on_clone_back_button_pressed() -> void:
	clone_line_edit.visible = true
	clone_spin_box.visible = false
	clone_back_button.visible = false
	clone_label.text = "Clone Title"


func _on_close_manager_pressed() -> void:
	TaskSignalBus._on_data_manager_close_manager_button_pressed.emit()
