extends Button

func _ready() -> void:
	initialize_button()


func initialize_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_checkbox_mode == TaskTrackingGlobal.CheckboxToggle.APPLY:
			set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_checkbox_mode != TaskTrackingGlobal.CheckboxToggle.APPLY:
		TaskTrackingGlobal.current_toggled_checkbox_mode = TaskTrackingGlobal.CheckboxToggle.APPLY
		TaskSignalBus._on_checkbox_mode_changed.emit()
		prints("Apply Mode toggled")
	else:
		prints("Apply Mode ALREADY TOGGLED")
