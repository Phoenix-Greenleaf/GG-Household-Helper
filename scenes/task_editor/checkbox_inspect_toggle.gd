extends Button

func _ready() -> void:
	initialize_button()

func initialize_button() -> void:
	set_pressed_no_signal(false)
	if DataGlobal.task_tracking_current_toggled_checkbox_mode == DataGlobal.CheckboxToggle.INSPECT:
		set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if DataGlobal.task_tracking_current_toggled_checkbox_mode != DataGlobal.CheckboxToggle.INSPECT:
		DataGlobal.task_tracking_current_toggled_checkbox_mode = DataGlobal.CheckboxToggle.INSPECT
		SignalBus._on_task_editor_checkbox_mode_changed.emit()
		prints("Inspect Mode toggled")
	else:
		prints("Inspect Mode ALREADY TOGGLED")
