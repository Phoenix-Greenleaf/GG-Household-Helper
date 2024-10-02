extends PanelContainer


@onready var add_task_button: Button = %AddTaskButton
@onready var task_title_line_edit: LineEdit = %TaskTitleLineEdit
@onready var task_group_line_edit: LineEdit = %TaskGroupLineEdit
@onready var existing_groups_option_button: OptionButton = %ExistingGroupsOption
@onready var task_add_assigned_user_label: Label = %TaskAddAssignedUserLabel
@onready var task_add_assigned_user_option_button: OptionButton = %TaskAddAssignedUserOptionButton
@onready var task_add_schedule_start_label: Label = %TaskAddScheduleStartLabel
@onready var task_add_schedule_start_spin_box: SpinBox = %TaskAddScheduleStartSpinBox
@onready var task_add_units_per_cycle_label: Label = %TaskAddUnitsPerCycleLabel
@onready var task_add_units_per_cycle_spin_box: SpinBox = %TaskAddUnitsPerCycleSpinBox
@onready var task_add_schedule_end_label: Label = %TaskAddScheduleEndLabel
@onready var task_add_schedule_end_spin_box: SpinBox = %TaskAddScheduleEndSpinBox
@onready var accept_new_task_button: Button = %AcceptNewTaskButton
@onready var v_separator_7: VSeparator = %VSeparator7
@onready var v_separator_6: VSeparator = %VSeparator6
@onready var v_separator_5: VSeparator = %VSeparator5
@onready var v_separator_4: VSeparator = %VSeparator4
@onready var v_separator_3: VSeparator = %VSeparator3
@onready var v_separator_2: VSeparator = %VSeparator2
@onready var v_separator: VSeparator = %VSeparator

var cancel_txt: String = "Cancel"
var add_task_txt: String = "Add Task"



func _ready() -> void:
	close_new_task_panel()
	TaskSignalBus._on_task_grid_column_toggled.connect(refresh_panel)
	TaskSignalBus._on_task_editing_lock_toggled.connect(toggle_editing_lock)


func update_task_add_assigned_users() -> void:
	task_add_assigned_user_option_button.clear()
	for user_name in TaskTrackingGlobal.current_users_keys:
		task_add_assigned_user_option_button.add_item(user_name)


func open_new_task_panel() -> void:
	toggle_standard_parts(true)
	toggle_task_group_parts(TaskTrackingGlobal.group_column_toggled)
	toggle_assigned_user_parts(TaskTrackingGlobal.assigned_to_column_toggled)
	toggle_scheduling_parts(TaskTrackingGlobal.scheduling_column_toggled)


func close_new_task_panel() -> void:
	toggle_standard_parts(false)
	toggle_task_group_parts(false)
	toggle_assigned_user_parts(false)
	toggle_scheduling_parts(false)


func toggle_standard_parts(parts_active: bool) -> void:
	if parts_active:
		add_task_button.text = cancel_txt
	if not parts_active:
		add_task_button.text = add_task_txt
	v_separator_6.visible = parts_active
	task_title_line_edit.visible = parts_active
	v_separator_5.visible = parts_active
	accept_new_task_button.visible = parts_active


func toggle_task_group_parts(parts_active: bool) -> void:
	task_group_line_edit.visible = parts_active
	existing_groups_option_button.visible = parts_active
	v_separator_4.visible = parts_active


func toggle_assigned_user_parts(parts_active: bool) -> void:
	task_add_assigned_user_label.visible = parts_active
	task_add_assigned_user_option_button.visible = parts_active
	v_separator_3.visible = parts_active


func toggle_scheduling_parts(parts_active: bool) -> void:
	task_add_schedule_start_label.visible = parts_active
	task_add_schedule_start_spin_box.visible = parts_active
	v_separator_2.visible = parts_active
	task_add_units_per_cycle_label.visible = parts_active
	task_add_units_per_cycle_spin_box.visible = parts_active
	v_separator.visible = parts_active
	task_add_schedule_end_label.visible = parts_active
	task_add_schedule_end_spin_box.visible = parts_active
	v_separator_7.visible = parts_active


func refresh_panel() -> void:
	if add_task_button.text == "Add Task":
		return
	open_new_task_panel()


func new_task_field_reset() -> void:
	task_title_line_edit.clear()
	task_group_line_edit.clear()
	existing_groups_option_button.select(0)
	task_add_assigned_user_option_button.select(0)
	task_add_schedule_start_spin_box.value = 0
	task_add_units_per_cycle_spin_box.value = 0
	match TaskTrackingGlobal.current_toggled_section:
		DataGlobal.Section.MONTHLY:
			reset_new_task_section_scheduling(12)
		DataGlobal.Section.WEEKLY:
			reset_new_task_section_scheduling(5)
		DataGlobal.Section.DAILY:
			reset_new_task_section_scheduling(31)


func reset_new_task_section_scheduling(max_value_param: float) -> void:
	task_add_schedule_start_spin_box.max_value = max_value_param
	task_add_units_per_cycle_spin_box.max_value = max_value_param
	task_add_schedule_end_spin_box.max_value = max_value_param
	task_add_schedule_end_spin_box.value = max_value_param
	


func update_existing_groups_option_button_items() -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	for group_item in TaskTrackingGlobal.current_task_group_items:
		existing_groups_option_button.add_item(group_item)


func toggle_editing_lock(lock_active: bool) -> void:
	if lock_active:
		close_new_task_panel()
	add_task_button.disabled = lock_active




"""
task_title_line_edit
task_group_line_edit
group_column_toggled
assigned_to_column_toggled
scheduling_column_toggled
task_add_assigned_user_option_button


section_column_toggled
description_column_toggled
time_of_day_column_toggled
priority_column_toggled
location_column_toggled
task_removal_column_toggled
year_column_toggled
month_column_toggled
checkboxes_column_toggled

"""

#func add_new_task


func create_task_data() -> Dictionary:
	var new_task_data: Dictionary = {"task_name": task_title_line_edit.text}
	if TaskTrackingGlobal.group_column_toggled:
		new_task_data.merge({"task_group": task_group_line_edit.text})
	if TaskTrackingGlobal.assigned_to_column_toggled:
		var current_index: int = task_add_assigned_user_option_button.selected
		var assigned_name: String = task_add_assigned_user_option_button.get_item_text(current_index)
		var assigned_id: String = TaskTrackingGlobal.current_users_id[assigned_name]
		new_task_data.merge({"assigned_to":assigned_id})
	if TaskTrackingGlobal.scheduling_column_toggled:
		new_task_data.merge({
			TaskTrackingGlobal.section_scheduling_start(): task_add_schedule_start_spin_box,
			TaskTrackingGlobal.section_units_per_cycle(): task_add_units_per_cycle_spin_box,
			TaskTrackingGlobal.section_scheduling_end(): task_add_schedule_end_spin_box,
		})
	return new_task_data


"""

task_group_line_edit


"task_group":
:
"daily_scheduling_start", "days_per_cycle", "daily_scheduling_end":
"weekly_scheduling_start", "weeks_per_cycle", "weekly_scheduling_end":
"monthly_scheduling_start", "months_per_cycle", "monthly_scheduling_end":

"""





func _on_add_task_button_pressed() -> void:
	if add_task_button.text == add_task_txt:
		open_new_task_panel()
		return
	if add_task_button.text == cancel_txt:
		close_new_task_panel()


func _on_existing_groups_option_item_selected(index: int) -> void:
	pass # Replace with function body.


func _on_accept_new_task_button_pressed() -> void:
	var new_id: int = TaskTrackingGlobal.changed_new_data.size()
	var new_data: Dictionary = create_task_data()
	TaskTrackingGlobal.submit_new_task(new_data)
	close_new_task_panel()
