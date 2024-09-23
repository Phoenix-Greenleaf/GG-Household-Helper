extends Label

var file_label_intro: String = "Current Database: "
var empty_file_label: String = "No Database Loaded"


func _ready() -> void:
	TaskSignalBus._on_new_database_loaded.connect(update_database_label)
	update_database_label()


func update_database_label() -> void:
	if SqlManager.database_name == "":
		text = empty_file_label
		return
	text = file_label_intro + SqlManager.database_name
