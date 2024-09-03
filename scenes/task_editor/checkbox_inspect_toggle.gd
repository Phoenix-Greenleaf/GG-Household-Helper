extends Button

func _ready() -> void:
	initialize_button()

func initialize_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_checkbox_mode == TaskTrackingGlobal.CheckboxToggle.INSPECT:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_checkbox_mode != TaskTrackingGlobal.CheckboxToggle.INSPECT:
		TaskTrackingGlobal.current_toggled_checkbox_mode = TaskTrackingGlobal.CheckboxToggle.INSPECT
		TaskSignalBus._on_checkbox_mode_changed.emit()
		prints("Inspect Mode toggled")
	else:
		prints("Inspect Mode ALREADY TOGGLED")
