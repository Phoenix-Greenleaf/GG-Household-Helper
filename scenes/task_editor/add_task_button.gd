extends Button


func _ready() -> void:
	TaskSignalBus._on_new_database_loaded.connect(no_database_toggle)
	no_database_toggle()


func no_database_toggle() -> void:
	if SqlManager.active_database:
		disabled = false
		return
	disabled = true
