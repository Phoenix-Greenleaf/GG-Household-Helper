extends TextEdit

@export var saved_task: TaskData

func _ready() -> void:
	name = "MultiLineCell"
	self.text_changed.connect(update_active_data)


func update_active_data() -> void:
	var text_parameter = self.text
	saved_task.description = text_parameter
	SignalBus.trigger_save_warning.emit()
