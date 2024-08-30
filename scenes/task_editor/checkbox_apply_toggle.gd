extends Button

func _ready() -> void:
	initialize_button()


func initialize_button() -> void:
	set_pressed_no_signal(false)
	if DataGlobal.task_tracking_current_toggled_checkbox_mode == DataGlobal.CheckboxToggle.APPLY:
			set_pressed_no_signal(true)


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if DataGlobal.task_tracking_current_toggled_checkbox_mode != DataGlobal.CheckboxToggle.APPLY:
		DataGlobal.task_tracking_current_toggled_checkbox_mode = DataGlobal.CheckboxToggle.APPLY
		SignalBus._on_task_editor_checkbox_mode_changed.emit()
		prints("Apply Mode toggled")
	else:
		prints("Apply Mode ALREADY TOGGLED")
