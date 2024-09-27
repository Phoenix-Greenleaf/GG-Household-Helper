extends Button


func _ready() -> void:
	TaskSignalBus._on_new_database_loaded.connect(update_button)
	update_button()


func update_button() -> void:
	text = str(TaskTrackingGlobal.current_toggled_year)
	if SqlManager.database_name == "":
		disabled = true
		return
	if disabled:
		disabled = false
