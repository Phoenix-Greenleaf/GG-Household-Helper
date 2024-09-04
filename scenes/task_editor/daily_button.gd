extends Button



func _ready() -> void:
	initialize_button()


func initialize_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_section == DataGlobal.Section.DAILY:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_section != DataGlobal.Section.DAILY:
		TaskTrackingGlobal.current_toggled_section = DataGlobal.Section.DAILY
		TaskSignalBus._on_section_changed.emit()
		prints("Daily Section Toggled")
	else:
		prints("Daily Section ALREADY TOGGLED")
