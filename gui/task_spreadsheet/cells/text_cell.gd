extends LineEdit

@export var saved_task: TaskData
@export var saved_type: String

func _ready() -> void:
	name = "TextCell"
	self.text_changed.connect(update_active_data)


func update_active_data(text_parameter) -> void:
	match saved_type:
		"Task Name":
			saved_task.name = text_parameter
		"Group":
			saved_task.group = text_parameter
		"Assigned User":
			saved_task.assigned_user = text_parameter
		"Location":
			saved_task.location = text_parameter
		"Cycle Time Unit":
			saved_task.time_unit = text_parameter
		"Last Completed":
			saved_task.last_completed = text_parameter
		_:
			prints("LineEdit active data update failed")
			return
	SignalBus.trigger_save_warning.emit()
