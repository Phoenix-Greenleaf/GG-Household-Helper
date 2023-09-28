extends PanelContainer

@onready var task_set_name_label: Label = $MarginContainer/VBox/TaskSetNameLabel
@onready var task_set_year_label: Label = $MarginContainer/VBox/TaskSetYearLabel
@onready var functional_button: Button = $FunctionalButton


@export var saved_resource: TaskSpreadsheetData 


func _ready() -> void:
	update_button()
	SignalBus._on_current_tasksheet_data_changed.connect(retoggle_button_group)


func update_button() -> void:
	if saved_resource:
		task_set_name_label.text = saved_resource.spreadsheet_title
		task_set_year_label.text = str(saved_resource.spreadsheet_year)
	else:
		task_set_name_label.text = "Button Test"
		task_set_year_label.text = "2020"


func retoggle_button_group() -> void:
	functional_button.set_pressed_no_signal(false)
	if DataGlobal.current_tasksheet_data == saved_resource:
		functional_button.set_pressed_no_signal(true)
