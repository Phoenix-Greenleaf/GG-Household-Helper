extends Button



func _ready() -> void:
	initialize_button()


func initialize_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.task_tracking_current_toggled_section == DataGlobal.Section.YEARLY:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.task_tracking_current_toggled_section != DataGlobal.Section.YEARLY:
		TaskTrackingGlobal.task_tracking_current_toggled_section = DataGlobal.Section.YEARLY
		TaskSignalBus._on_section_changed.emit()
		prints("Yearly Section Toggled")
	else:
		prints("Yearly Section ALREADY TOGGLED")
