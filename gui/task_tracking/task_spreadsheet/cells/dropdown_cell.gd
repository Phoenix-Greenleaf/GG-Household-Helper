extends OptionButton

@export var saved_task: TaskData
@export var saved_type: String
@export var dropdown_items: Array

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
var selected_item



func _ready() -> void:
	name = "DropdownCell"
	self.item_selected.connect(_on_dropdown_item_selected)
	connect_type_updates()


func connect_type_updates() -> void:
	match saved_type:
		"Section":
			pass
		"Group":
			SignalBus._on_task_editor_group_dropdown_items_changed.connect(update_dropdown_items)
		"Time Of Day":
			pass
		"Priority":
			pass
		"Assigned User":
			SignalBus._on_task_editor_assigned_user_dropdown_items_changed.connect(update_dropdown_items)
		_:
			pass


func update_dropdown_items(selected_item_parameter = selected_item) -> void:
	clear()
	if selected_item != selected_item_parameter:
		selected_item = selected_item_parameter
	var selection_index: int
	match saved_type:
		"Section", "Time Of Day", "Priority":
			for item in dropdown_items:
				add_item(item)
			selection_index = selected_item
		"Group":
			for item in DataGlobal.task_tracking_task_group_dropdown_items:
				add_item(item)
			selection_index = dropdown_items.find(selected_item)
		"Assigned User":
			for profile in DataGlobal.task_tracking_user_profiles_dropdown_items:
				var profile_name = profile[0]
				if profile_name == "No Profile":
					profile_name = "Not Assigned"
				add_item(profile_name)
			selection_index = dropdown_items.find(selected_item)
			if selected_item == DataGlobal.default_profile:
				selection_index = 0
			if selection_index == -1:
				prints("dropdown find error")
				prints("Selected item:", selected_item)
				prints("dropdown items:", dropdown_items)
				prints("")
	selected = selection_index


func _on_dropdown_item_selected(index_parameter) -> void:
	match saved_type:
		"Section":
			prints("Section selected:", get_item_text(index_parameter), section[index_parameter])
			saved_task.section = section[index_parameter]
			saved_task.section_transfer()
		"Group":
			saved_task.group = get_item_text(index_parameter)
			prints("Group selected:", saved_task.group)
		"Time Of Day":
			prints("Time of Day selected:", get_item_text(index_parameter), time_of_day[index_parameter])
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
				for current_profile in DataGlobal.active_data_task_tracking.user_profiles:
					profile_names.append(current_profile[0])
				var assigned_user_profile_index = profile_names.find(assigned_user_name)
				var assigned_user_profile = DataGlobal.active_data_task_tracking.user_profiles[assigned_user_profile_index]
				prints("Profile selected on dropdown:", assigned_user_profile[0])
				saved_task.assigned_user = assigned_user_profile
		_:
			prints("OptionButton active data update failed")
			return
	SignalBus._on_task_set_data_modified.emit()
	print_verbose("DropdownCell", saved_task.name, "func _on_dropdown_item_selected emits '_on_task_set_data_modified'")

