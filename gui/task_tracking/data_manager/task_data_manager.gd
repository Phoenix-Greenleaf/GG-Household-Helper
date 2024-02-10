extends PanelContainer

@onready var close_manager_button: Button = %CloseManager
@onready var import_task_file_dialog: FileDialog = $ImportTaskFileDialog
@onready var task_data_title_line_edit: LineEdit = %TaskDataTitleLineEdit
@onready var task_data_year_spinbox: SpinBox = %TaskDataYearSpinbox
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

var task_save_button_group = preload("res://gui/task_tracking/data_manager/task_save_button_group.tres")
var task_save_button = preload("res://gui/task_tracking/data_manager/task_save_button.tscn")

var safe_lock_active: bool
var task_button_count: int = 4
var empty_string := ""



func _ready() -> void:
	connect_signal_bus()
	starting_visibilities()
	load_existing_task_sets()
	if DataGlobal.active_data_task_tracking:
		update_current_tasksheet_label()


func connect_signal_bus() -> void:
	close_manager_button.pressed.connect(emit_exit_signal)
	SignalBus._on_task_set_data_active_data_switched.connect(update_current_tasksheet_label)
	SignalBus._on_task_set_data_modified.connect(safety_toggle.bind(true))
	SignalBus._on_task_set_data_saved.connect(safety_toggle.bind(false))


func safety_toggle(new_bool) -> void:
	safe_lock_active = new_bool


func emit_exit_signal() -> void:
	SignalBus._on_task_data_manager_close_manager_button_pressed.emit()


func update_current_tasksheet_label() -> void:
	var intro_text = "Current Data: "
	var title = DataGlobal.active_data_task_tracking.task_set_title
	var year = DataGlobal.active_data_task_tracking.task_set_year
	var new_label = intro_text + title + ": " + str(year)
	current_tasksheet_label.text = new_label


func starting_visibilities() -> void:
	import_task_file_dialog.visible = false
	new_task_panel.visible = false
	clone_menu_reset()


func load_existing_task_sets() -> void:
	var existing_files_info = DataGlobal.get_task_sets_info()
	for file_info_iteration in existing_files_info:
		var interation_name = file_info_iteration[0]
		var interation_year = file_info_iteration[1]
		create_task_save_button(interation_name, interation_year)
	get_tree().call_group("task_save_panels", "retoggle_button_group")


func show_new_task_panel() -> void:
	new_task_panel.visible = true
	new_task_button.visible = false


func show_new_task_button() -> void:
	new_task_button.visible = true
	new_task_panel.visible = false


func task_field_reset() -> void:
	task_data_year_spinbox.value = 2000
	task_data_title_line_edit.clear()


func create_task_save_button(target_name: String, target_year: int) -> void:
	var new_task_save_button := task_save_button.instantiate()
	task_grid.add_child(new_task_save_button)
	task_grid.move_child(new_task_save_button, task_button_count)
	new_task_save_button.task_set_name_label.text = target_name
	new_task_save_button.task_set_year_label.text = str(target_year)
	new_task_save_button.add_to_group("task_save_panels")
	task_button_count += 1
	var actual_task_button: Button = new_task_save_button.get_node("FunctionalButton")
	actual_task_button.toggled.connect(_on_task_save_button_pressed.bind(target_name, target_year))
	actual_task_button.set_button_group(task_save_button_group)


func clone_menu_open() -> void:
	clone_data_button.visible = false
	clone_data_panel.visible = true


func clone_menu_reset() -> void:
	if DataGlobal.active_data_task_tracking:
		clone_data_button.visible = true
		clone_data_panel.visible = false
		clone_back_button.visible = false
		clone_menu_update()
	else:
		clone_data_button.visible = false
		clone_data_panel.visible = false


func clone_menu_update() -> void:
	clone_label.text = "Clone Title"
	clone_line_edit.text = DataGlobal.active_data_task_tracking.task_set_title
	clone_line_edit.visible = true
	var new_year = DataGlobal.active_data_task_tracking.task_set_year + 1
	clone_spin_box.set_value_no_signal(new_year)
	clone_spin_box.visible = false


func reset_data_manager() -> void:
	for panel_iteration in get_tree().get_nodes_in_group("task_save_panels"):
		task_grid.remove_child(panel_iteration)
		panel_iteration.queue_free()
	load_existing_task_sets()


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
	var new_tasksheet_year := int(task_data_year_spinbox.value)
	var new_tasksheet_name: String = task_data_title_line_edit.text
	DataGlobal.create_data_task_set(new_tasksheet_name, new_tasksheet_year)
	create_task_save_button(new_tasksheet_name, new_tasksheet_year)
	task_field_reset()
	show_new_task_button()


func _on_task_save_button_pressed(button_pressed: bool, name_parameter: String, year_parameter: int):
	if not button_pressed:
		return
	prints("Test _on_task_save_button_pressed:", name_parameter, year_parameter)
	if DataGlobal.active_data_task_tracking:
		if [name_parameter, year_parameter] == DataGlobal.get_active_task_set_info():
			prints("Tasksheet data already loaded, skipping.")
			DataGlobal.button_based_message(current_tasksheet_label, "Data Already Loaded!") 
			return
	if safe_lock_active:
		DataGlobal.save_data_task_set()
	DataGlobal.load_data_task_set(name_parameter, year_parameter)
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
			DataGlobal.button_based_message(clone_label, "File Already Exists!\n(Change Title or Year)")
			return
		DataGlobal.clone_task_set_data(cloned_title, cloned_year)
		create_task_save_button(cloned_title, cloned_year)
		


func _on_clone_cancel_button_pressed() -> void:
	clone_menu_reset()


func _on_clone_back_button_pressed() -> void:
	clone_line_edit.visible = true
	clone_spin_box.visible = false
	clone_back_button.visible = false
	clone_label.text = "Clone Title"
