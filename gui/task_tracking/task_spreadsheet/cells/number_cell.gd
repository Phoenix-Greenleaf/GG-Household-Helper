extends SpinBox

@export var saved_task: TaskData
@export var saved_type: String

func _ready() -> void:
	name = "NumberCell"


func connect_spinbox_update() -> void:
	self.value_changed.connect(update_active_data)



func update_active_data(number_parameter: float) -> void:
	var int_number: int = number_parameter as int
	match saved_type:
		"Units/Cycle":
			saved_task.units_per_cycle = int_number
		"Schedule Start":
			saved_task.scheduling_start = int_number
		_:
			prints("SpinBox func update_active_data failed! saved_type:", saved_type)
			prints("Spinbox Task", saved_task.name)
			return
	SignalBus.trigger_save_warning.emit()
	prints("NumberCell", saved_task.name, "func update_active_data emits 'trigger_save_warning'")
