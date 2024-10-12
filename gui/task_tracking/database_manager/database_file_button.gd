extends PanelContainer


@onready var functional_button: Button = %FunctionalButton
@onready var database_name_label: Label = %DatabaseNameLabel

var stored_database_path: String = ""
var stored_database_name: String = ""


func _ready() -> void:
	initialize_button()
	TaskSignalBus._on_active_database_switched.connect(retoggle_button_group)


func initialize_button() -> void:
	database_name_label.text = "Button Test"


func load_path_and_name(path_param: String, name_param: String) -> void:
	stored_database_path = path_param
	stored_database_name = name_param
	database_name_label.text = name_param


func retoggle_button_group() -> void:
	functional_button.set_pressed_no_signal(false)
	if not SqlManager.database_is_active:
		return
	if not name_compare():
		return
	functional_button.set_pressed_no_signal(true)


func name_compare() -> bool:
	return SqlManager.database_name == stored_database_name


func _on_functional_button_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if SqlManager.database_path == stored_database_path:
		prints("this database file already active")
		return
	if SqlManager.database_is_active:
		SqlManager.unload_database()
	SqlManager.set_database_path_and_name(stored_database_path, stored_database_name)
	SqlManager.load_database()
