extends OptionButton

@export var saved_task: TaskData
@export var saved_type: String


var section: Array = [
	DataGlobal.Section.YEARLY,
	DataGlobal.Section.MONTHLY,
	DataGlobal.Section.WEEKLY,
	DataGlobal.Section.DAILY,
]

var time_of_day: Array = [
	DataGlobal.TimeOfDay.ANY,
	DataGlobal.TimeOfDay.FIRST_THING,
	DataGlobal.TimeOfDay.MORNING,
	DataGlobal.TimeOfDay.AFTERNOON,
	DataGlobal.TimeOfDay.EVENING,
	DataGlobal.TimeOfDay.LAST_THING,
]

var priority: Array = [
	DataGlobal.Priority.NO_PRIORITY,
	DataGlobal.Priority.LOW_PRIORITY,
	DataGlobal.Priority.NORMAL_PRIORITY,
	DataGlobal.Priority.HIGH_PRIORITY,
	DataGlobal.Priority.MAX_PRIORITY_OVERRIDE,
]

func _ready() -> void:
	name = "DropdownCell"
	self.item_selected.connect(update_active_data)


func update_active_data(index_parameter) -> void:
	match saved_type:
		"Section":
			saved_task.section = section[index_parameter]
		"Time Of Day":
			saved_task.time_of_day = time_of_day[index_parameter]
		"Priority":
			saved_task.priority = priority[index_parameter]
		_:
			prints("OptionButton active data update failed")
			return
	SignalBus.trigger_save_warning.emit()
