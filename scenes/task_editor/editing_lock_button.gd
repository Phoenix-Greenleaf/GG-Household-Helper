extends CheckButton


func _ready() -> void:
	set_pressed_no_signal(false)
	TaskSignalBus._on_new_database_loaded.connect(no_database_toggle)
	no_database_toggle()

func no_database_toggle() -> void:
	if SqlManager.active_database:
		disabled = false
		return
	disabled = true


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		if TaskTrackingGlobal.current_toggled_checkbox_mode != TaskTrackingGlobal.CheckboxToggle.INSPECT:
			TaskTrackingGlobal.current_toggled_checkbox_mode = TaskTrackingGlobal.CheckboxToggle.INSPECT
	TaskSignalBus._on_task_editing_lock_toggled.emit(toggled_on)
