extends SpinBox

@export var saved_task: TaskData
@export var saved_type: String

var first_row_flag: bool = false
var column_pair: String


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
		"Row Order":
			saved_task.row_order = int_number
		_:
			prints("SpinBox func update_active_data failed! saved_type:", saved_type)
			prints("Spinbox Task", saved_task.name)
			return
	TaskSignalBus._on_data_set_modified.emit()





func create_number_cell(number: int, current_type: String, column_group: String = "") -> void:
	var cell: SpinBox = number_cell.instantiate()
	self.add_child(cell)
	cell.value = number
	cell.saved_task = current_task
	cell.saved_type = current_type
	cell.connect_spinbox_update()
	add_cell_to_groups(cell, column_group)
	set_first_row_flag(cell)
