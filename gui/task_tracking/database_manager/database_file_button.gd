extends PanelContainer


@onready var functional_button: Button = %FunctionalButton
@onready var database_name_label: Label = %DatabaseNameLabel

var database_path: String = ""
var database_name: String = ""


func _ready() -> void:
	initialize_button()
	TaskSignalBus._on_active_database_switched.connect(retoggle_button_group)


func initialize_button() -> void:
	database_name_label.text = "Button Test"


func load_path_and_name(path_param: String, name_param: String) -> void:
	database_path = path_param
	database_name = name_param
	database_name_label.text = name_param


func retoggle_button_group() -> void:
	functional_button.set_pressed_no_signal(false)
	if not TaskTrackingGlobal.database_is_active:
		return
	if not name_compare():
		return
	functional_button.set_pressed_no_signal(true)


func name_compare() -> bool:
	return SqlManager.database_name == database_name




func _on_functional_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
