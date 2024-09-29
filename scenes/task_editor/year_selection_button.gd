extends Button


func _ready() -> void:
	TaskSignalBus._on_new_database_loaded.connect(update_button)
	TaskSignalBus._on_new_database_loaded.connect(no_database_toggle)
	update_button()
	no_database_toggle()


func no_database_toggle() -> void:
	if SqlManager.active_database:
		disabled = false
		return
	disabled = true


func update_button() -> void:
	text = str(TaskTrackingGlobal.current_toggled_year)
	if SqlManager.database_name == "":
		disabled = true
		return
	if disabled:
		disabled = false
