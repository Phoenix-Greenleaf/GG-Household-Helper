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

var profile_names: Array

func _ready() -> void:
	name = "DropdownCell"
	self.item_selected.connect(_on_dropdown_item_selected)


func _on_dropdown_item_selected(index_parameter) -> void:
	match saved_type:
		"Section":
			prints("Section selected:", section[index_parameter])
			saved_task.section = section[index_parameter]
		"Time Of Day":
			prints("Time of Day selected:", time_of_day[index_parameter])
			saved_task.time_of_day = time_of_day[index_parameter]
		"Priority":
			prints("Priority selected:", DataGlobal.Priority.find_key(index_parameter), "index", index_parameter)
			saved_task.priority = index_parameter
		"Assigned User":
			var assigned_user_name: String = self.get_item_text(index_parameter)
			prints("Selected User name:", assigned_user_name)
			if assigned_user_name == "Not Assigned":
				saved_task.assigned_user = DataGlobal.default_profile
				prints("None / Default profile selected")
			else:
				profile_names.clear()
				for current_profile in DataGlobal.current_tasksheet_data.user_profiles:
					profile_names.append(current_profile[0])
				var assigned_user_profile_index = profile_names.find(assigned_user_name)
				var assigned_user_profile = DataGlobal.current_tasksheet_data.user_profiles[assigned_user_profile_index]
				prints("Profile selected on dropdown:", assigned_user_profile[0])
				saved_task.assigned_user = assigned_user_profile
		_:
			prints("OptionButton active data update failed")
			return
	SignalBus.trigger_save_warning.emit()
