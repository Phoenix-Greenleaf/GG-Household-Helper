extends Button



func _ready() -> void:
	TaskSignalBus._on_section_changed.connect(update_button)
	update_button()


func update_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_section == DataGlobal.Section.DAILY:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_section != DataGlobal.Section.DAILY:
		TaskTrackingGlobal.current_toggled_section = DataGlobal.Section.DAILY
		prints("Daily Section Toggled")
	else:
		prints("Daily Section ALREADY TOGGLED")
