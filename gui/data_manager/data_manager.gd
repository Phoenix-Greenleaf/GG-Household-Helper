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
var safe_lock_active: bool

var task_save_button_group = preload("res://gui/data_manager/task_save_button_group.tres")
var task_save_button = preload("res://gui/data_manager/task_save_button.tscn")

var tasksheet_folder = "user://task_data/"
var profile_folder = "user://profile_data/"
var export_folder = "user://exports/"

var task_button_count: int = 0

var error_keys: Array = [
	"OK", #0
	"FAILED", #1
	"ERR_UNAVAILABLE", #2
	"ERR_UNCONFIGURED", #3
	"ERR_UNAUTHORIZED", #4
	"ERR_PARAMETER_RANGE_ERROR", #5
	"ERR_OUT_OF_MEMORY", #6
	"ERR_FILE_NOT_FOUND" #7
]




func _ready() -> void:
	connect_signal_bus()
	starting_visibilities()
	load_existing_tasksheets()


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


func load_existing_tasksheets() -> void:
	if not DirAccess.dir_exists_absolute(tasksheet_folder):
		prints("Error loading existing task sheets")
		return
	var existing_files = DirAccess.get_files_at(tasksheet_folder)
	prints("Found files:", existing_files)
	for file in existing_files:
		prints("File Iteration:", file)
		var extension = file.get_extension()
		if extension != "res":
			prints("ERROR: File", file, "is not of 'res'")
			continue
		prints("Extension:", extension)
		var filepath_for_loading = tasksheet_folder + file
		prints("Loading filepath:", filepath_for_loading)
		var file_resource: TaskSpreadsheetData = ResourceLoader.load(filepath_for_loading)
		
		
		print(file_resource)
		var loaded_name = file_resource.spreadsheet_title
		var loaded_year = file_resource.spreadsheet_year
		prints("Loaded:", loaded_name, loaded_year)
		create_task_save_button(file_resource)


func show_new_task_panel() -> void:
	new_task_panel.visible = true
	new_task_button.visible = false


func show_new_task_button() -> void:
	new_task_button.visible = true
	new_task_panel.visible = false

func task_field_reset() -> void:
	task_data_year_spinbox.value = 2000
	task_data_title_line_edit.clear()

func directory_check(directory_to_check) -> void:
	if not DirAccess.dir_exists_absolute(directory_to_check):
		DirAccess.make_dir_absolute(directory_to_check)
		prints("Created directory:", directory_to_check)
	else:
		prints("Directory Exists")



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
	create_tasksheet_data_and_save()
	task_field_reset()
	show_new_task_button()


func create_tasksheet_data_and_save() -> void:
	var tasksheet_year := int(task_data_year_spinbox.value)
	var tasksheet_name: String = task_data_title_line_edit.text
	var tasksheet_data := TaskSpreadsheetData.new()
	tasksheet_data.spreadsheet_year = tasksheet_year
	tasksheet_data.spreadsheet_title = tasksheet_name
	var tasksheet_snake_name: String = tasksheet_name.to_snake_case()
	var tasksheet_save_name: String = tasksheet_snake_name + "_" + str(tasksheet_year)
	var filepath_create_and_save: String = tasksheet_folder + tasksheet_save_name + ".res"
	prints("Filepath for save:", filepath_create_and_save)
	tasksheet_data.spreadsheet_filepath = filepath_create_and_save
	directory_check(tasksheet_folder)
	create_task_save_button(tasksheet_data)
	send_tasksheet_to_global(tasksheet_data)
	save_current_tasksheet()


func save_current_tasksheet() -> void:
	var current_tasksheet: TaskSpreadsheetData = DataGlobal.current_tasksheet_data
	var current_filepath: String = current_tasksheet.spreadsheet_filepath
	var tasksheet_save_error = ResourceSaver.save(current_tasksheet, current_filepath)
	if tasksheet_save_error != OK:
		var error_highscore: int = error_keys.size() - 1
		if tasksheet_save_error > error_highscore:
			printerr("Failed to save resource: NEW HIGHSCORE! ", tasksheet_save_error, "!")
		else:
			printerr("Failed to save resource: ", error_keys[tasksheet_save_error], " ", tasksheet_save_error)



func create_task_save_button(target_resource: TaskSpreadsheetData) -> void:
	var new_task_save_button = task_save_button.instantiate()
	task_grid.add_child(new_task_save_button)
	task_grid.move_child(new_task_save_button, task_button_count)
	new_task_save_button.saved_resource = target_resource
	new_task_save_button.update_button() 
	task_button_count += 1
	var actual_task_button: Button = new_task_save_button.get_node("FunctionalButton")
	actual_task_button.toggled.connect(_on_task_save_button_pressed.bind(target_resource))
	actual_task_button.set_button_group(task_save_button_group)
	
	var target_name = target_resource.spreadsheet_title
	var target_year = target_resource.spreadsheet_year
	prints("Created button for", target_name, target_year, target_resource)




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


func send_tasksheet_to_global(tasksheet_to_send) -> void:
	DataGlobal.current_tasksheet_data = tasksheet_to_send
	SignalBus._on_current_tasksheet_data_changed.emit()


func _on_import_tasksheet_pressed() -> void:
	import_task_file_dialog.visible = true
