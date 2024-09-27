extends Button

func _ready() -> void:
	TaskSignalBus._on_checkbox_mode_changed.connect(update_button)
	TaskSignalBus._on_task_editing_lock_toggled.connect(editing_lock)
	update_button()


func update_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_checkbox_mode == TaskTrackingGlobal.CheckboxToggle.APPLY:
			set_pressed_no_signal(true)


func editing_lock(locked: bool) -> void:
	disabled = locked


func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_checkbox_mode != TaskTrackingGlobal.CheckboxToggle.APPLY:
		TaskTrackingGlobal.current_toggled_checkbox_mode = TaskTrackingGlobal.CheckboxToggle.APPLY
		prints("Apply Mode toggled")
	else:
		prints("Apply Mode ALREADY TOGGLED")
