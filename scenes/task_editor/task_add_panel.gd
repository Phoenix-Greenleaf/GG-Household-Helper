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





func update_task_add_assigned_users() -> void:
	task_add_assigned_user_option_button.clear()
	for item in TaskTrackingGlobal.user_profiles_dropdown_items:
		task_add_assigned_user_option_button.add_item(item[0])




func open_new_task_panel() -> void:
	add_task_button.text = "Cancel"
	task_title_line_edit.visible = true
	task_group_line_edit.visible = true
	existing_groups_option_button.visible = true
	accept_new_task_button.visible = true
	task_add_assigned_user_label.visible = true
	task_add_assigned_user_option_button.visible = true
	task_add_schedule_start_label.visible = true
	task_add_schedule_start_spin_box.visible = true
	task_add_units_per_cycle_label.visible = true
	task_add_units_per_cycle_spin_box.visible = true
	v_separator_6.visible = true
	v_separator_5.visible = true
	v_separator_4.visible = true
	v_separator_3.visible = true
	v_separator_2.visible = true
	v_separator.visible = true


func close_new_task_panel() -> void:
	add_task_button.text = "Add Task"
	task_title_line_edit.visible = false
	task_group_line_edit.visible = false
	existing_groups_option_button.visible = false
	accept_new_task_button.visible = false
	task_add_assigned_user_label.visible = false
	task_add_assigned_user_option_button.visible = false
	task_add_schedule_start_label.visible = false
	task_add_schedule_start_spin_box.visible = false
	task_add_units_per_cycle_label.visible = false
	task_add_units_per_cycle_spin_box.visible = false
	v_separator_6.visible = false
	v_separator_5.visible = false
	v_separator_4.visible = false
	v_separator_3.visible = false
	v_separator_2.visible = false
	v_separator.visible = false



#
#func create_new_task_data() -> void: #task code, the data side
	#var new_task = TaskData.new()
	#var new_task_title = task_title_line_edit.text
	#new_task.name = new_task_title
	#var new_task_year = TaskTrackingGlobal.active_data.task_set_year
	#new_task.task_year = new_task_year
	#var new_task_section := TaskTrackingGlobal.current_toggled_section
	#new_task.section = new_task_section
	#new_task.previous_section = new_task_section
	#var new_task_assigned_user: Array = (
		#TaskTrackingGlobal.user_profiles_dropdown_items[
			#task_add_assigned_user_option_button.selected
		#]
	#)
	#new_task.assigned_user = new_task_assigned_user
	#var new_task_schedule_start: float = task_add_schedule_start_spin_box.value
	#new_task.scheduling_start = new_task_schedule_start
	#var new_task_units_per_cycle: float = task_add_units_per_cycle_spin_box.value
	#new_task.units_per_cycle = new_task_units_per_cycle
	#var new_task_group = "None"
	#if task_group_line_edit.text:
		#new_task_group = task_group_line_edit.text
	#row_group = new_task_group
	#new_task.group = new_task_group
	#new_task.offbrand_init()
	#match new_task_section:
		#DataGlobal.Section.YEARLY:
			#TaskTrackingGlobal.active_data.spreadsheet_year_data.append(new_task)
		#DataGlobal.Section.MONTHLY:
			#TaskTrackingGlobal.active_data.spreadsheet_month_data.append(new_task)
		#DataGlobal.Section.WEEKLY:
			#TaskTrackingGlobal.active_data.spreadsheet_week_data.append(new_task)
		#DataGlobal.Section.DAILY:
			#TaskTrackingGlobal.active_data.spreadsheet_day_data.append(new_task)
	#DataGlobal.task_editor_scan_task_for_group(new_task)
	#update_existing_groups_option_button_items()
	#process_task(new_task)





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
	TaskTrackingGlobal.task_editor_update_task_group_dropdown_items()
	for item in TaskTrackingGlobal.task_group_dropdown_items:
		existing_groups_option_button.add_item(item)


#func create_time_unit_column_header(column_parameter: String) -> void:
	#var column_data: Dictionary = TaskTrackingGlobal.active_data.column_data
	#var current_column_data: Dictionary = column_data[column_parameter]
	#var header_text: String = ""
	#var column_order: int = current_column_data["Column Order"]
	#var ordering_enabled: bool = true
	#var sorting_mode: int = current_column_data["Sorting Mode"]
	#var sorting_enabled: bool = current_column_data["Sorting Enabled"]
	#var column_group: String = column_parameter
	#match TaskTrackingGlobal.current_toggled_section:
		#DataGlobal.Section.YEARLY, DataGlobal.Section.MONTHLY:
			#header_text = "Months/Cycle"
			#task_add_units_per_cycle_label.text = "Months per Cycle:"
		#DataGlobal.Section.WEEKLY:
			#header_text = "Weeks/Cycle"
			#task_add_units_per_cycle_label.text = "Weeks per Cycle:"
		#DataGlobal.Section.DAILY:
			#header_text = "Days/Cycle"
			#task_add_units_per_cycle_label.text = "Days per Cycle:"
	#full_header_size += 1
	#create_header_cell(header_text, column_order, ordering_enabled, sorting_mode, sorting_enabled, column_group)
