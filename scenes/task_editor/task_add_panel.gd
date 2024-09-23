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
@onready var accept_new_task_button: Button = %AcceptNewTaskButton
@onready var v_separator_6: VSeparator = %VSeparator6
@onready var v_separator_5: VSeparator = %VSeparator5
@onready var v_separator_4: VSeparator = %VSeparator4
@onready var v_separator_3: VSeparator = %VSeparator3
@onready var v_separator_2: VSeparator = %VSeparator2
@onready var v_separator: VSeparator = %VSeparator


func _ready() -> void:
	close_new_task_panel()
	TaskSignalBus._on_task_grid_column_toggled.connect(refresh_panel)


func update_task_add_assigned_users() -> void:
	task_add_assigned_user_option_button.clear()
	for user_name in TaskTrackingGlobal.current_users_keys:
		task_add_assigned_user_option_button.add_item(user_name)


func open_new_task_panel() -> void:
	toggle_standard_parts(true)
	toggle_task_group_parts(true)
	toggle_assigned_user_parts(true)
	toggle_scheduling_parts(true)


func close_new_task_panel() -> void:
	toggle_standard_parts(false)
	toggle_task_group_parts(false)
	toggle_assigned_user_parts(false)
	toggle_scheduling_parts(false)


func toggle_standard_parts(parts_active: bool) -> void:
	if parts_active:
		add_task_button.text = "Cancel"
	if not parts_active:
		add_task_button.text = "Add Task"
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


func update_existing_groups_option_button_items() -> void:
	existing_groups_option_button.clear()
	existing_groups_option_button.add_item("Existing Groups")
	for group_item in TaskTrackingGlobal.current_task_group_items:
		existing_groups_option_button.add_item(group_item)

"""

group_column_toggled
assigned_to_column_toggled
scheduling_column_toggled


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
