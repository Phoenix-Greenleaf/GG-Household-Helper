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
	text = "Data Columns"
	popup_menu = get_popup()
	popup_menu.hide_on_checkable_item_selection = false
	allow_reselect = true
	populate_with_checkboxes()
	update_checkboxes()
	TaskSignalBus._on_task_grid_column_toggled.connect(update_checkboxes)
	TaskSignalBus._on_new_database_loaded.connect(no_database_toggle)
	no_database_toggle()


func no_database_toggle() -> void:
	if SqlManager.active_database:
		disabled = false
		return
	disabled = true


func populate_with_checkboxes() -> void:
	add_one_check_option(SECTION)
	add_one_check_option(SCHEDULING)
	add_one_check_option(GROUP)
	add_one_check_option(DESCRIPTION)
	add_one_check_option(TIME_OF_DAY)
	add_one_check_option(PRIORITY)
	add_one_check_option(LOCATION)
	add_one_check_option(ASSIGNED_TO)
	add_one_check_option(TASK_REMOVAL)
	add_one_check_option(YEAR)
	add_one_check_option(MONTH)
	add_one_check_option(CHECKBOXES)


func update_checkboxes() -> void:
	update_one_check_option(SECTION, TaskTrackingGlobal.section_column_toggled)
	update_one_check_option(SCHEDULING, TaskTrackingGlobal.scheduling_column_toggled)
	update_one_check_option(GROUP, TaskTrackingGlobal.group_column_toggled)
	update_one_check_option(DESCRIPTION, TaskTrackingGlobal.description_column_toggled)
	update_one_check_option(TIME_OF_DAY, TaskTrackingGlobal.time_of_day_column_toggled)
	update_one_check_option(PRIORITY, TaskTrackingGlobal.priority_column_toggled)
	update_one_check_option(LOCATION, TaskTrackingGlobal.location_column_toggled)
	update_one_check_option(ASSIGNED_TO, TaskTrackingGlobal.assigned_to_column_toggled)
	update_one_check_option(TASK_REMOVAL, TaskTrackingGlobal.task_removal_column_toggled)
	update_one_check_option(YEAR, TaskTrackingGlobal.year_column_toggled)
	update_one_check_option(MONTH, TaskTrackingGlobal.month_column_toggled)
	update_one_check_option(CHECKBOXES, TaskTrackingGlobal.checkboxes_column_toggled)


func add_one_check_option(id_param: int) -> void:
	popup_menu.add_check_item(popup_items[id_param], id_param)


func update_one_check_option(id_param: int, option_active: bool) -> void:
	var option_index = get_item_index(id_param)
	if popup_menu.is_item_checked(option_index) == option_active:
		return
	popup_menu.set_item_checked(option_index, option_active)


func toggle_selected_item(index: int) -> void:
	var item_id: int = get_item_id(index)
	match item_id:
		SECTION:
			TaskTrackingGlobal.section_column_toggled = !TaskTrackingGlobal.section_column_toggled
		SCHEDULING:
			TaskTrackingGlobal.scheduling_column_toggled = !TaskTrackingGlobal.scheduling_column_toggled
		GROUP:
			TaskTrackingGlobal.group_column_toggled = !TaskTrackingGlobal.group_column_toggled
		DESCRIPTION:
			TaskTrackingGlobal.description_column_toggled = !TaskTrackingGlobal.description_column_toggled
		TIME_OF_DAY:
			TaskTrackingGlobal.time_of_day_column_toggled = !TaskTrackingGlobal.time_of_day_column_toggled
		PRIORITY:
			TaskTrackingGlobal.priority_column_toggled = !TaskTrackingGlobal.priority_column_toggled
		LOCATION:
			TaskTrackingGlobal.location_column_toggled = !TaskTrackingGlobal.location_column_toggled
		ASSIGNED_TO:
			TaskTrackingGlobal.assigned_to_column_toggled = !TaskTrackingGlobal.assigned_to_column_toggled
		TASK_REMOVAL:
			TaskTrackingGlobal.task_removal_column_toggled = !TaskTrackingGlobal.task_removal_column_toggled
		YEAR:
			TaskTrackingGlobal.year_column_toggled = !TaskTrackingGlobal.year_column_toggled
		MONTH:
			TaskTrackingGlobal.month_column_toggled = !TaskTrackingGlobal.month_column_toggled
		CHECKBOXES:
			TaskTrackingGlobal.checkboxes_column_toggled = !TaskTrackingGlobal.checkboxes_column_toggled


func _on_item_selected(index: int) -> void:
	toggle_selected_item(index)
	text = "Data Columns"
