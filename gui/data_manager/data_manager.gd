extends PanelContainer


@onready var close_manager_button: Button = %CloseManager
@onready var import_task_file_dialog: FileDialog = $ImportTaskFileDialog
@onready var task_data_title_line_edit: LineEdit = %TaskDataTitleLineEdit
@onready var task_data_year_spinbox: SpinBox = %TaskDataYearSpinbox
@onready var new_task_panel: PanelContainer = %NewTaskPanel
@onready var new_task_button: Button = %NewTaskButton
@onready var task_grid: GridContainer = %TaskGrid
@onready var current_tasksheet_label: Label = %CurrentTasksheetLabel


var task_save_button_group = preload("res://gui/data_manager/task_save_button_group.tres")
var task_save_button = preload("res://gui/data_manager/task_save_button.tscn")

var tasksheet_folder = "user://task_data/"
var profile_folder = "user://profile_data/"
var export_folder = "user://exports/"

var task_button_count: int = 0

var error_keys : Array = [
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
	import_task_file_dialog.visible = false
	new_task_panel.visible = false

func connect_signal_bus() -> void:
	close_manager_button.pressed.connect(emit_exit_signal)
	SignalBus._on_current_tasksheet_data_changed.connect(update_current_tasksheet_label)


func emit_exit_signal() -> void:
	SignalBus.emit_signal("data_manager_close")
	prints("data manager close Emitted")

func update_current_tasksheet_label() -> void:
	var intro_text = "Current Data: "
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	var new_label = intro_text + title + ": " + str(year)
	current_tasksheet_label.text = new_label


func show_new_task_panel() -> void:
	new_task_panel.visible = true
	new_task_button.visible = false


func show_new_task_button() -> void:
	new_task_button.visible = true
	new_task_panel.visible = false

func task_field_reset() -> void:
	task_data_year_spinbox.value = 2000
	task_data_title_line_edit.clear()





func _on_import_task_file_dialog_file_selected(path: String) -> void:
	prints("File Dialogue import:", path)


func _on_new_task_button_pressed() -> void:
	show_new_task_panel()


func _on_task_cancel_button_pressed() -> void:
	show_new_task_button()


func _on_task_accept_button_pressed() -> void:
	if not task_data_title_line_edit.text:
		printerr("Task needs title, not accepted")
#		show_new_task_button()
		return
	create_spreadsheet_data_and_save()
	task_field_reset()
	show_new_task_button()


func create_spreadsheet_data_and_save() -> void:
	var tasksheet_year := int(task_data_year_spinbox.value)
	var tasksheet_name: String = task_data_title_line_edit.text
	var tasksheet_data := TaskSpreadsheetData.new(tasksheet_year, tasksheet_name)
	var tasksheet_save_name = tasksheet_name + "_" + str(tasksheet_year)
	var filepath: String = tasksheet_folder + tasksheet_save_name + ".res"
	var save_error = ResourceSaver.save(tasksheet_data, filepath)
	if save_error != OK:
		var error_highscore = error_keys.size() - 1
		if save_error > error_highscore:
			printerr("Failed to save resource: NEW HIGHSCORE! ", save_error, "!")
		else:
			printerr("Failed to save resource: ", error_keys[save_error], " ", save_error)
	create_task_save_button(tasksheet_data)


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
	prints("Created button for", target_resource.get_class(), target_resource)
	send_tasksheet_to_global(target_resource)



func _on_task_save_button_pressed(button_pressed: bool, tasksheet: TaskSpreadsheetData):
	if not button_pressed:
		return
	if tasksheet == DataGlobal.current_tasksheet_data:
		prints("Tasksheet data already loaded, skipping.")
		return
	send_tasksheet_to_global(tasksheet)



func send_tasksheet_to_global(tasksheet_to_send) -> void:
	prints("Button Tasksheet:", tasksheet_to_send)
	DataGlobal.current_tasksheet_data = tasksheet_to_send
	SignalBus.emit_signal("_on_current_tasksheet_data_changed")
	var global_test : bool = DataGlobal.current_tasksheet_data == tasksheet_to_send
	prints("Global Test:", global_test)



func _on_import_tasksheet_pressed() -> void:
	import_task_file_dialog.visible = true
