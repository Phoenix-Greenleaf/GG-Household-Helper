extends SpinBox

@export var saved_task: TaskData
@export var saved_type: String

func _ready() -> void:
	name = "NumberCell"
	self.value_changed.connect(update_active_data)



func update_active_data(number_parameter: float) -> void:
	var int_number: int = number_parameter as int
	match saved_type:
		"Units Per Cycle":
			saved_task.units_per_cycle = int_number
		"Units Added When Skipped":
			saved_task.units_added_when_skipped = int_number
		_:
			prints("SpinBox active data update failed")
			return
	SignalBus.trigger_save_warning.emit()
