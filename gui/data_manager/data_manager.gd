extends PanelContainer


@onready var close_manager_button: Button = %CloseManager
@onready var import_task_file_dialog: FileDialog = $ImportTaskFileDialog
@onready var task_data_title_line_edit: LineEdit = %TaskDataTitleLineEdit
@onready var task_data_year_line_edit: LineEdit = %TaskDataYearLineEdit
@onready var new_task_panel: PanelContainer = %NewTaskPanel
@onready var new_task_button: Button = %NewTaskButton
@onready var task_grid: GridContainer = %TaskGrid

var task_save_button_group = preload("res://gui/data_manager/task_save_button_group.tres")
var task_save_button = preload("res://gui/data_manager/task_save_button.tscn")

var tasksheet_folder = "user://task_data/"
var profile_folder = "user://profile_data/"
var export_folder = "user://exports/"

var task_button_count: int = 0



var name_column: int = 0
var section_column: int = 1
var group_column: int = 2
var user_column: int = 4
var time_of_day_column: int 
var priority_column: int 
var location_column: int 
var time_unit_column: int 
var units_per_cycle_column: int 
var units_added_when_skipped_column: int 
var last_completed_column: int 
var year_column: int 



#var csv_conversion: Array = []

func _ready() -> void:
	close_manager_button.pressed.connect(emit_exit_signal)
	import_task_file_dialog.visible = false
	new_task_panel.visible = false


func emit_exit_signal() -> void:
	SignalBus.emit_signal("data_manager_close")
	prints("data manager close Emitted")


func _task(save_path):
	pass



#	var task_data = TaskData.new()
#	spreadsheet_data.spreadsheet_data.append()
#
#
#
#	var filename = save_path + ".res"
#	var save_error = ResourceSaver.save(spreadsheet_data, filename)
#	if save_error != OK:
#		printerr("Failed to save resource: ", save_error)
#	return save_error


func show_new_task_panel() -> void:
	new_task_panel.visible = true
	new_task_button.visible = false


func show_new_task_button() -> void:
	new_task_button.visible = true
	new_task_panel.visible = false







func _on_import_task_csv_pressed() -> void:
	import_task_file_dialog.visible = true


func _on_import_task_file_dialog_file_selected(path: String) -> void:
	pass # Replace with function body.


func _on_new_task_button_pressed() -> void:
	show_new_task_panel()


func _on_task_cancel_button_pressed() -> void:
	show_new_task_button()


func _on_task_accept_button_pressed() -> void:
	if not task_data_year_line_edit.text or not task_data_title_line_edit.text:
		printerr("Task needs title and year, not accepted")
		show_new_task_button()
		return
	var tasksheet_year: String = task_data_year_line_edit.text
	var tasksheet_name: String = task_data_title_line_edit.text
	var tasksheet_data := TaskSpreadsheetData.new(tasksheet_year as int, tasksheet_name)
	var filepath: String = tasksheet_folder + tasksheet_name + tasksheet_year + ".res"
	var save_error = ResourceSaver.save(tasksheet_data, filepath)
	if save_error != OK:
		printerr("Failed to save resource: ", save_error)
	create_task_save_button(tasksheet_data)
	show_new_task_button()


func create_task_save_button(target_resource: TaskSpreadsheetData) -> void:
	var new_task_save_button = task_save_button.instantiate()
	task_grid.add_child(new_task_save_button)
	task_grid.move_child(new_task_save_button, task_button_count)
	new_task_save_button.saved_resource = target_resource
	new_task_save_button.update_button() #this failed and I don't understand why
#	var task_title_label: Label = new_task_save_button.task_set_name_label
#	var task_year_label: Label = new_task_save_button.task_set_year_label
#	task_title_label.text = new_task_save_button.saved_resource.spreadsheet_title
#	task_year_label.text = new_task_save_button.saved_resource.spreadsheet_year as String
#	task_title_label.text = "testing"
#	task_year_label.text = "1888"
	
	task_button_count += 1
	var actual_task_button: Button = new_task_save_button.get_node("FunctionalButton")
	actual_task_button.toggled.connect(_on_task_save_button_pressed.bind(target_resource))
	actual_task_button.set_button_group(task_save_button_group)

func _on_task_save_button_pressed(tasksheet: TaskSpreadsheetData):
	pass
