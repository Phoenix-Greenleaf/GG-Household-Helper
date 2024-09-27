extends CheckButton


func _ready() -> void:
	set_pressed_no_signal(false)


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if TaskTrackingGlobal.current_toggled_checkbox_mode != TaskTrackingGlobal.CheckboxToggle.INSPECT:
			TaskTrackingGlobal.current_toggled_checkbox_mode = TaskTrackingGlobal.CheckboxToggle.INSPECT
	TaskSignalBus._on_task_editing_lock_toggled.emit(toggled_on)
