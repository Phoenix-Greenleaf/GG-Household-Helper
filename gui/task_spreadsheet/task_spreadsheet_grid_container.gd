extends GridContainer

@export var data_for_spreadsheet : TaskSpreadsheetData

@onready var add_task_button: Button = %AddTaskButton
@onready var task_title_line_edit: LineEdit = %TaskTitleLineEdit
@onready var task_group_line_edit: LineEdit = %TaskGroupLineEdit
@onready var existing_groups_option: OptionButton = %ExistingGroupsOption
@onready var accept_new_task_button: Button = %AcceptNewTaskButton



func _ready() -> void:
	ready_connections()
	close_new_task_panel()
	if !data_for_spreadsheet:
#		test_spreadsheet_initialization()
		print("No Tasksheet found for TaskGrid....")
	else:
		var title = DataGlobal.current_tasksheet_data.spreadsheet_title
		var year = DataGlobal.current_tasksheet_data.spreadsheet_year
		prints("TaskGrid found:", title, ":", year)


func ready_connections() -> void:
	if DataGlobal.current_tasksheet_data:
		data_for_spreadsheet = DataGlobal.current_tasksheet_data
	SignalBus._on_current_tasksheet_data_changed.connect(update_grid_spreadsheet)


func test_spreadsheet_initialization() -> void:
	pass


func button_based_message(target: Button, message: String, time: int = 2) -> void:
	var original_text = target.text
	target.text = message
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = time
	timer.one_shot
	timer.start()
	await timer.timeout
	timer.queue_free()
	target.text = original_text


func update_grid_spreadsheet() -> void:
	data_for_spreadsheet = DataGlobal.current_tasksheet_data
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	prints("TaskGrid updated:", title, ":", year)


func _on_add_task_button_pressed() -> void:
	match add_task_button.text:
		"Add Task":
			open_new_task_panel()
		"Cancel":
			close_new_task_panel()


func open_new_task_panel() -> void:
	add_task_button.text = "Cancel"
	task_title_line_edit.visible = true
	task_group_line_edit.visible = true
	existing_groups_option.visible = true
	accept_new_task_button.visible = true


func close_new_task_panel() -> void:
	add_task_button.text = "Add Task"
	task_title_line_edit.visible = false
	task_group_line_edit.visible = false
	existing_groups_option.visible = false
	accept_new_task_button.visible = false


func create_new_task() -> void:
	var new_task = TaskData.new()
	new_task.offbrand_init()
	



func _on_sort_tasks_button_pressed() -> void:
	pass # Replace with function body.


func _on_accept_new_task_button_pressed() -> void:
	if not task_title_line_edit.text:
		button_based_message(accept_new_task_button, "Title Needed!")
		return
	
	#create new task
	#use current sections as defaults
	#add to grid
	#grid positioning
	pass

func _on_existing_groups_option_item_selected(index: int) -> void:
	pass # Replace with function body.



