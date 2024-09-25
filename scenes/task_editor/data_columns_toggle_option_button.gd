extends OptionButton

var popup_menu: PopupMenu

var popup_items: Array = [
	"Section",
	"Scheduling",
	"Group",
	"Description",
	"Time Of Day",
	"Priority",
	"Location",
	"Assigned To",
	"Task Removal",
	"Year",
	"Month",
	"Checkboxes",
]

enum {
	SECTION,
	SCHEDULING,
	GROUP,
	DESCRIPTION,
	TIME_OF_DAY,
	PRIORITY,
	LOCATION,
	ASSIGNED_TO,
	TASK_REMOVAL,
	YEAR,
	MONTH,
	CHECKBOXES,
}



func _ready() -> void:
	popup_menu = get_popup()
	if SqlManager.database_name == "":
		return
	populate_with_checkboxes()


func populate_with_checkboxes() -> void:
	add_one_check_option(SECTION, TaskTrackingGlobal.section_column_toggled)
	add_one_check_option(SCHEDULING, TaskTrackingGlobal.scheduling_column_toggled)
	add_one_check_option(GROUP, TaskTrackingGlobal.group_column_toggled)
	add_one_check_option(DESCRIPTION, TaskTrackingGlobal.description_column_toggled)
	add_one_check_option(TIME_OF_DAY, TaskTrackingGlobal.time_of_day_column_toggled)
	add_one_check_option(PRIORITY, TaskTrackingGlobal.priority_column_toggled)
	add_one_check_option(LOCATION, TaskTrackingGlobal.location_column_toggled)
	add_one_check_option(ASSIGNED_TO, TaskTrackingGlobal.assigned_to_column_toggled)
	add_one_check_option(TASK_REMOVAL, TaskTrackingGlobal.task_removal_column_toggled)
	add_one_check_option(YEAR, TaskTrackingGlobal.year_column_toggled)
	add_one_check_option(MONTH, TaskTrackingGlobal.month_column_toggled)
	add_one_check_option(CHECKBOXES, TaskTrackingGlobal.checkboxes_column_toggled)


func add_one_check_option(id_param: int, toggled_param: bool) -> void:
	popup_menu.add_check_item(popup_items[id_param], id_param)
	popup_menu.set_item_checked(get_item_index(id_param), toggled_param)


func toggle_data_option(target_option: bool) -> void:
	target_option = !target_option


func _on_item_selected(index: int) -> void:
	popup_menu.toggle_item_checked(index)
	match get_item_id(index):
		SECTION:
			toggle_data_option(TaskTrackingGlobal.section_column_toggled)
		SCHEDULING:
			toggle_data_option(TaskTrackingGlobal.scheduling_column_toggled)
		GROUP:
			toggle_data_option(TaskTrackingGlobal.group_column_toggled)
		DESCRIPTION:
			toggle_data_option(TaskTrackingGlobal.description_column_toggled)
		TIME_OF_DAY:
			toggle_data_option(TaskTrackingGlobal.time_of_day_column_toggled)
		PRIORITY:
			toggle_data_option(TaskTrackingGlobal.priority_column_toggled)
		LOCATION:
			toggle_data_option(TaskTrackingGlobal.location_column_toggled)
		ASSIGNED_TO:
			toggle_data_option(TaskTrackingGlobal.assigned_to_column_toggled)
		TASK_REMOVAL:
			toggle_data_option(TaskTrackingGlobal.task_removal_column_toggled)
		YEAR:
			toggle_data_option(TaskTrackingGlobal.year_column_toggled)
		MONTH:
			toggle_data_option(TaskTrackingGlobal.month_column_toggled)
		CHECKBOXES:
			toggle_data_option(TaskTrackingGlobal.checkboxes_column_toggled)
