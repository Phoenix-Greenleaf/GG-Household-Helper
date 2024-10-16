extends PanelContainer


@onready var add_button: Button = %AddButton
@onready var line_edit: LineEdit = %LineEdit
@onready var cancel_button: Button = %CancelButton





var empty_name_error: String = "Title Required!"
var existing_name_error: String = "Title already in use!"
var success_message: String = "Task Group Added"
var error_bundle: Array[String] = [
	empty_name_error,
	existing_name_error,
	success_message,
]







func _ready() -> void:
	connect_signals()
	panel_standby()


func connect_signals() -> void:
	TaskSignalBus._on_editor_data_add_panels_activated.connect(toggle_entire_panel)
	TaskSignalBus._on_editor_data_add_panels_standby_set.connect(panel_standby)


func toggle_entire_panel(panel_name: String) -> void:
	if panel_name == name:
		panel_activation()
		return
	panel_deactivation()


func panel_activation() -> void:
	set_editing_visibility(true)


func panel_deactivation() -> void:
	visible = false


func panel_standby() -> void:
	visible = true
	set_editing_visibility(false)


func set_editing_visibility(is_visible: bool) -> void:
	line_edit.visible = is_visible
	cancel_button.visible = is_visible


func add_data() -> void:
	pass


func data_check() -> bool:
	if not line_edit_check():
		return false
	return true


func error_message(message_param: String) -> void:
	DataGlobal.button_based_message(add_button, message_param, 3, error_bundle)


func line_edit_check() -> bool:
	if line_edit.text.is_empty():
		error_message(empty_name_error)
		return false
	if does_task_group_already_exist():
		error_message(existing_name_error)
		return false
	return true


func does_task_group_already_exist() -> bool:
	for user_iteration: String in TaskTrackingGlobal.current_task_group_items:
		if line_edit.text.to_lower() == user_iteration.to_lower():
			return true
	return false


func _on_add_button_pressed() -> void:
	if line_edit.visible:
		add_data()
		line_edit.clear()
		error_message(success_message)
		return
	set_editing_visibility(true)


func _on_cancel_button_pressed() -> void:
	TaskSignalBus._on_editor_data_add_panels_standby_set.emit()
