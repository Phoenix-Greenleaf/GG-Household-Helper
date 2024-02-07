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
	load_existing_tasksheets()
	if DataGlobal.current_tasksheet_data:
		update_current_tasksheet_label()


func connect_signal_bus() -> void:
	close_manager_button.pressed.connect(emit_exit_signal)
	SignalBus._on_current_tasksheet_data_changed.connect(update_current_tasksheet_label)
	SignalBus.trigger_save_warning.connect(safety_toggle.bind(true))
	SignalBus.reset_save_warning.connect(safety_toggle.bind(false))


func safety_toggle(new_bool) -> void:
	safe_lock_active = new_bool


func emit_exit_signal() -> void:
	SignalBus.data_manager_close.emit()


func update_current_tasksheet_label() -> void:
	var intro_text = "Current Data: "
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	var new_label = intro_text + title + ": " + str(year)
	current_tasksheet_label.text = new_label


func starting_visibilities() -> void:
	import_task_file_dialog.visible = false
	new_task_panel.visible = false
	clone_menu_reset()


func load_existing_tasksheets() -> void:
#build connection to data gobal
	create_task_save_button(loaded_resource)
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


func create_tasksheet_data(tasksheet_name: String, tasksheet_year: int) -> void:
	#var tasksheet_data := TaskSpreadsheetData.new()
	#tasksheet_data.spreadsheet_title = tasksheet_name
	#tasksheet_data.spreadsheet_year = tasksheet_year
	#directory_check(JsonSaveManager.task_tracker_folder)
	#create_task_save_button(tasksheet_data)
	#send_tasksheet_to_global(tasksheet_data)
	#save_current_tasksheet()
	pass


func create_task_save_button(target_resource: TaskSpreadsheetData) -> void:
	var new_task_save_button = task_save_button.instantiate()
	task_grid.add_child(new_task_save_button)
	task_grid.move_child(new_task_save_button, task_button_count)
	new_task_save_button.saved_resource = target_resource
	new_task_save_button.update_button()
	new_task_save_button.add_to_group("task_save_panels")
	task_button_count += 1
	var actual_task_button: Button = new_task_save_button.get_node("FunctionalButton")
	actual_task_button.toggled.connect(_on_task_save_button_pressed.bind(target_resource))
	actual_task_button.set_button_group(task_save_button_group)
	var target_name = target_resource.spreadsheet_title
	var target_year = target_resource.spreadsheet_year


func send_tasksheet_to_global(tasksheet_to_send) -> void:
	#DataGlobal.current_tasksheet_data = tasksheet_to_send
	#SignalBus._on_current_tasksheet_data_changed.emit()
	#SignalBus.reload_profiles_triggered.emit()
	#SignalBus._on_editor_section_changed.emit()
	clone_menu_reset()


func clone_menu_open() -> void:
	clone_data_button.visible = false
	clone_data_panel.visible = true


func clone_menu_reset() -> void:
	if DataGlobal.current_tasksheet_data:
		clone_data_button.visible = true
		clone_data_panel.visible = false
		clone_back_button.visible = false
		clone_menu_update()
	else:
		clone_data_button.visible = false
		clone_data_panel.visible = false


func clone_menu_update() -> void:
	clone_label.text = "Clone Title"
	clone_line_edit.text = DataGlobal.current_tasksheet_data.spreadsheet_title
	clone_line_edit.visible = true
	var new_year = DataGlobal.current_tasksheet_data.spreadsheet_year + 1
	clone_spin_box.set_value_no_signal(new_year)
	clone_spin_box.visible = false


#func clone_tasksheet_data(tasksheet_name: String, tasksheet_year: int) -> void:
	#var tasksheet_data: TaskSpreadsheetData = DataGlobal.current_tasksheet_data.duplicate(true)
	#tasksheet_data.spreadsheet_title = tasksheet_name
	#tasksheet_data.spreadsheet_year = tasksheet_year
	#create_task_save_button(tasksheet_data)
	#send_tasksheet_to_global(tasksheet_data)
	#save_current_tasksheet()


func reset_data_manager() -> void:
	for panel_iteration in get_tree().get_nodes_in_group("task_save_panels"):
		task_grid.remove_child(panel_iteration)
		panel_iteration.queue_free()
	load_existing_tasksheets()




func _on_import_task_file_dialog_file_selected(path: String) -> void:
	prints("File Dialogue import:", path)


func _on_new_task_button_pressed() -> void:
	show_new_task_panel()


func _on_task_cancel_button_pressed() -> void:
	show_new_task_button()


func _on_task_accept_button_pressed() -> void:
	if not task_data_title_line_edit.text:
		printerr("Task needs title, not accepted")
		DataGlobal.button_based_message(task_accept_button, "Title Needed!")
		return
	var new_tasksheet_year := int(task_data_year_spinbox.value)
	var new_tasksheet_name: String = task_data_title_line_edit.text
	create_tasksheet_data(new_tasksheet_name, new_tasksheet_year)
	task_field_reset()
	show_new_task_button()


func _on_task_save_button_pressed(button_pressed: bool, pressed_tasksheet: TaskSpreadsheetData):
	if not button_pressed:
		return
	if pressed_tasksheet == DataGlobal.current_tasksheet_data:
		prints("Tasksheet data already loaded, skipping.")
		DataGlobal.button_based_message(current_tasksheet_label, "Data Already Loaded!") 
		return
	if safe_lock_active:
		save_current_tasksheet()
	send_tasksheet_to_global(pressed_tasksheet)
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
		var cloned_snake_name: String = cloned_title.to_snake_case()
		var cloned_save_name: String = cloned_snake_name + "_" + str(cloned_year)
		if FileAccess.file_exists(JsonSaveManager.generate_filepath(cloned_save_name, JsonSaveManager.FileType.TASK_TRACKING)):
			prints("File already exists! Clone needs different year or title...")
			DataGlobal.button_based_message(clone_accept_button, "Error!")
			DataGlobal.button_based_message(clone_label, "File Already Exists!\n(Change Title or Year)")
			return
		clone_tasksheet_data_and_save(cloned_title, cloned_year)


func _on_clone_cancel_button_pressed() -> void:
	clone_menu_reset()


func _on_clone_back_button_pressed() -> void:
	clone_line_edit.visible = true
	clone_spin_box.visible = false
	clone_back_button.visible = false
	clone_label.text = "Clone Title"
