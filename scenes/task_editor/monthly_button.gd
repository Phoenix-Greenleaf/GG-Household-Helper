extends Button



func _ready() -> void:
	initialize_button()


func initialize_button() -> void:
	set_pressed_no_signal(false)
	if DataGlobal.task_tracking_current_toggled_section == DataGlobal.Section.MONTHLY:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if DataGlobal.task_tracking_current_toggled_section != DataGlobal.Section.MONTHLY:
		DataGlobal.task_tracking_current_toggled_section = DataGlobal.Section.MONTHLY
		SignalBus._on_task_editor_section_changed.emit()
		prints("Monthly Section Toggled")
	else:
		prints("Monthly Section ALREADY TOGGLED")