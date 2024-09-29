extends Button

func _ready() -> void:
	TaskSignalBus._on_checkbox_mode_changed.connect(update_button)
	TaskSignalBus._on_new_database_loaded.connect(no_database_toggle)
	update_button()
	no_database_toggle()


func update_button() -> void:
	set_pressed_no_signal(false)
	if TaskTrackingGlobal.current_toggled_checkbox_mode == TaskTrackingGlobal.CheckboxToggle.INSPECT:
			set_pressed_no_signal(true)



func no_database_toggle() -> void:
	if SqlManager.active_database:
		disabled = false
		return
	disabled = true

func _on_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		return
	if TaskTrackingGlobal.current_toggled_checkbox_mode != TaskTrackingGlobal.CheckboxToggle.INSPECT:
		TaskTrackingGlobal.current_toggled_checkbox_mode = TaskTrackingGlobal.CheckboxToggle.INSPECT
		prints("Inspect Mode toggled")
	else:
		prints("Inspect Mode ALREADY TOGGLED")
