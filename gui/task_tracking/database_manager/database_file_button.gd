extends PanelContainer


@onready var functional_button: Button = %FunctionalButton
@onready var database_name_label: Label = %DatabaseNameLabel


func _ready() -> void:
	initialize_button()
	TaskSignalBus._on_active_database_switched.connect(retoggle_button_group)


func initialize_button() -> void:
	database_name_label.text = "Button Test"


func retoggle_button_group() -> void:
	functional_button.set_pressed_no_signal(false)
	if not TaskTrackingGlobal.database_is_active:
		return
	if not name_compare():
		return
	functional_button.set_pressed_no_signal(true)


func name_compare() -> bool:
	return TaskTrackingGlobal.active_data.task_set_title == database_name_label.text
