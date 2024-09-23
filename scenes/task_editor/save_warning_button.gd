extends Button


var no_database: String = "Pick Database"
var unchanged_data: String = "No Changes"
var changed_data: String = "SAVE CHANGES"



func _ready() -> void:
	TaskSignalBus._on_data_modified.connect(update_button)
	update_button()


func update_button() -> void:
	if SqlManager.database_name == "":
		text = no_database
		disabled = false
		return
	if TaskTrackingGlobal.active_changes.size() == 0:
		text = unchanged_data
		disabled = true
		return
	text = changed_data
	disabled = false
