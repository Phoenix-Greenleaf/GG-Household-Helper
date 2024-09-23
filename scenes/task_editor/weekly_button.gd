extends Button



func _ready() -> void:
	TaskSignalBus._on_section_changed.connect(update_button)
	update_button()


func update_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_section == DataGlobal.Section.WEEKLY:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_section != DataGlobal.Section.WEEKLY:
		TaskTrackingGlobal.current_toggled_section = DataGlobal.Section.WEEKLY
		prints("Weekly Section Toggled")
	else:
		prints("Weekly Section ALREADY TOGGLED")
