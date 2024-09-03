extends PanelContainer

@onready var task_set_name_label: Label = %TaskSetNameLabel
@onready var task_set_year_label: Label = %TaskSetYearLabel
@onready var functional_button: Button = $FunctionalButton



func _ready() -> void:
	initialize_button()
	TaskSignalBus._on_active_data_set_switched.connect(retoggle_button_group)


func initialize_button() -> void:
	task_set_name_label.text = "Button Test"
	task_set_year_label.text = "2020"


func retoggle_button_group() -> void:
	functional_button.set_pressed_no_signal(false)
	if not TaskTrackingGlobal.active_data:
		return
	if name_compare() and year_compare():
		functional_button.set_pressed_no_signal(true)


func name_compare() -> bool:
	return TaskTrackingGlobal.active_data.task_set_title == task_set_name_label.text


func year_compare() -> bool:
	return str(TaskTrackingGlobal.active_data.task_set_year) == task_set_year_label.text
