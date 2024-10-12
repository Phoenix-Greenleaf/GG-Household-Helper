extends Button

func  _ready() -> void:
	connect_signals()
	if not SqlManager.database_is_active:
		disable_button()


func connect_signals() -> void:
	TaskSignalBus._on_new_database_loaded.connect(enable_button)
	TaskSignalBus._on_database_unloaded.connect(disable_button)


func disable_button() -> void:
	disabled = true


func enable_button() -> void:
	disabled = false
