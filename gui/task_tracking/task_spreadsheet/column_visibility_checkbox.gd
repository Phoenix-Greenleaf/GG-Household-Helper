extends CheckBox



func set_column_title(title_parameter: String) -> void:
	text = title_parameter


func column_visible(visible_parameter: bool) -> void:
	button_pressed = visible_parameter


func _on_toggled(toggled_on: bool) -> void:
	var current_column_data: Dictionary = DataGlobal.active_data_task_tracking.column_data[text]
	current_column_data["Column Visible"] = toggled_on
	SignalBus._on_task_editor_column_visibility_toggled.emit(text, toggled_on)
