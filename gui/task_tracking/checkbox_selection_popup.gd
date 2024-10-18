extends PanelContainer

@onready var new_profile_menu: PanelContainer = %NewProfileMenu
@onready var in_progress_panel_container: PanelContainer = %InProgressPanelContainer
@onready var completed_panel_container: PanelContainer = %CompletedPanelContainer

@onready var new_profile_button: Button = %NewProfileButton
@onready var active_button: Button = %ActiveButton
@onready var in_progress_button: Button = %InProgressButton
@onready var completed_button: Button = %CompletedButton
@onready var expired_button: Button = %ExpiredButton
@onready var profile_menu_accept: Button = %ProfileMenuAccept

@onready var completed_color_rect: ColorRect = %CompletedColorRect
@onready var in_progress_bottom_color_rect: ColorRect = %InProgressBottomColorRect
@onready var active_checkbox_border_color_rect: ColorRect = %ActiveCheckboxBorderColorRect
@onready var expired_checkbox_border_color_rect: ColorRect = %ExpiredCheckboxBorderColorRect

@onready var profile_name_line_edit: LineEdit = %ProfileNameLineEdit

@onready var selection_popup_profile_h_box: HBoxContainer = %SelectionPopupProfileHBox
@onready var selection_popup_profile_label: Label = %SelectionPopupProfileLabel
@onready var current_sibling = selection_popup_profile_label

@onready var profile_color_picker_button: ColorPickerButton = %ProfileColorPickerButton

@export var paired_checkbox_menu_button: PanelContainer


@onready var edit_profile_button: Button = %EditProfileButton
@onready var edit_profile_menu: PanelContainer = %EditProfileMenu
@onready var edit_profile_name_line_edit: LineEdit = %EditProfileNameLineEdit
@onready var edit_profile_color_picker_button: ColorPickerButton = %EditProfileColorPickerButton
@onready var edit_profile_menu_accept: Button = %EditProfileMenuAccept

var menu_button_width: int


var checkbox_profile = preload("res://gui/task_tracking/checkbox_profile.tscn")
var profile_button_group = preload("res://gui/task_tracking/checkbox_profile_group.tres")
var status_button_group = preload("res://gui/task_tracking/checkbox_status_group.tres")
 

func _ready() -> void:
	load_all_profiles()
	connection_central()
	starting_visibilities()
	database_check()
	update_panel()
	prints(TaskTrackingGlobal.current_checkbox_profile_id, TaskTrackingGlobal.current_checkbox_profile_name, TaskTrackingGlobal.current_checkbox_profile_color)

func _process(_delta: float) -> void:
	if self.visible and paired_checkbox_menu_button:
			sync_position()


func connection_central() -> void:
	connect_paired_menu_button()
	connect_status_button_group()
	signal_bus_connections()


func signal_bus_connections() -> void:
	TaskSignalBus._on_checkbox_selection_changed.connect(update_status_colors)
	TaskSignalBus._on_profile_selection_changed.connect(reload_profiles)
	TaskSignalBus._on_current_checkbox_profile_changed.connect(update_panel)
	TaskSignalBus._on_data_set_saved.connect(unlock_new_profile)
	TaskSignalBus._on_new_database_loaded.connect(database_check)
	TaskSignalBus._on_database_unloaded.connect(database_check)


func database_check() -> void:
	if not SqlManager.database_is_active:
		new_profile_button.text = "Task Data\nNeeded!"
	database_active_visibility()


func reset_panel() -> void:
	new_profile_menu.visible = false
	edit_profile_menu.visible = false
	visible = false


func database_active_visibility() -> void:
	in_progress_panel_container.visible = SqlManager.database_is_active
	completed_panel_container.visible = SqlManager.database_is_active


func default_profile_status_limiter() -> void:
	if TaskTrackingGlobal.current_checkbox_profile_id == TaskTrackingGlobal.default_profile_id:
		in_progress_panel_container.visible = false
		completed_panel_container.visible = false
		edit_profile_button.visible = false
		return
	in_progress_panel_container.visible = true
	completed_panel_container.visible = true
	edit_profile_button.visible = true


func update_edit_profile_menu() -> void:
	if TaskTrackingGlobal.current_checkbox_profile_id == TaskTrackingGlobal.default_profile_id:
		edit_profile_button.visible = false
	else:
		edit_profile_button.visible = true
	if edit_profile_menu.visible:
		edit_profile_button.visible = false
	edit_profile_name_line_edit.text = TaskTrackingGlobal.current_checkbox_profile_name
	edit_profile_color_picker_button.color = TaskTrackingGlobal.current_checkbox_profile_color
	edit_profile_button.add_theme_color_override("font_color", TaskTrackingGlobal.current_checkbox_profile_color)


func starting_visibilities() -> void:
	new_profile_menu.visible = false
	self.visible = false
	in_progress_panel_container.visible = false
	completed_panel_container.visible = false
	edit_profile_button.visible = false
	edit_profile_menu.visible = false


func sync_position() -> void:
	var offset_x: int = 0
	var offset_y: int = 0
	var menu_transform: Transform2D
	menu_transform = paired_checkbox_menu_button.get_global_transform_with_canvas()
	var menu_origin = menu_transform.origin
	var menu_position_x: int = menu_origin.x
	var menu_position_y: int = menu_origin.y
	var sync_x: int = offset_x + menu_position_x + menu_button_width
	var sync_y: int = offset_y + menu_position_y
	var sync_vector := Vector2i(sync_x, sync_y)
	position = sync_vector


func update_menu_button_witdth() -> void:
	menu_button_width = int(paired_checkbox_menu_button.size.x)


func load_all_profiles() -> void:
	add_default_profile()
	load_existing_profiles()
	load_new_profiles()


func load_existing_profiles() -> void:
	if not SqlManager.database_is_active:
		return
	if TaskTrackingGlobal.current_users_id.is_empty():
		return
	for current_user_name in TaskTrackingGlobal.current_users_keys:
		var current_user_id: int = TaskTrackingGlobal.current_users_id[current_user_name]
		if current_user_id == 1:
			continue
		var current_user_color: Color = TaskTrackingGlobal.current_users_color[current_user_name]
		add_profile(int(current_user_id), current_user_name, current_user_color)


func load_new_profiles() -> void:
	if not SqlManager.database_is_active:
		return
	if TaskTrackingGlobal.new_user_profiles.is_empty():
		return
	for user_iteration in TaskTrackingGlobal.new_user_profiles:
		var current_user_id: int = user_iteration[0]
		var current_user_name: String = user_iteration[1]
		var current_user_color: Color = user_iteration[2]
		add_profile(current_user_id, current_user_name, current_user_color)


func add_profile(target_id: int, target_name: String, target_color: Color) -> void:
	var new_profile = checkbox_profile.instantiate()
	new_profile.add_to_group("profile_children")
	var profile_button = new_profile.get_node("ProfileButton")
	profile_button.set_button_group(profile_button_group)
	current_sibling.add_sibling(new_profile)
	new_profile.load_checkbox_profile(target_id, target_name, target_color)
	current_sibling = new_profile


func add_default_profile() -> void:
	add_profile(
		TaskTrackingGlobal.default_profile_id,
		TaskTrackingGlobal.default_profile_name,
		TaskTrackingGlobal.default_profile_color,
	)
	#remove ability to edit the default


func update_status_colors() -> void:
	var current_color = TaskTrackingGlobal.current_checkbox_profile_color
	completed_color_rect.set_color(current_color)
	in_progress_bottom_color_rect.set_color(current_color)
	if current_color == Color.WHITE:
		active_checkbox_border_color_rect.update_border()
		expired_checkbox_border_color_rect.update_border()
		return
	active_checkbox_border_color_rect.update_border(current_color)
	expired_checkbox_border_color_rect.update_border(current_color)


func create_new_profile(profile_name: String, profile_color: Color) -> void:
	TaskTrackingGlobal.add_new_user_info(profile_name, profile_color)
	var new_profile: Array = TaskTrackingGlobal.new_user_profiles.back()
	var current_user_id: int = new_profile[0]
	var current_user_name: String = new_profile[1]
	var current_user_color: Color = new_profile[2]
	add_profile(current_user_id, current_user_name, current_user_color)


func connect_paired_menu_button() -> void:
	if not paired_checkbox_menu_button:
		self.visible = true
		print("No menu button for visibility!")
		return
	var menu_button = paired_checkbox_menu_button.get_node("CurrentCheckboxActualButton")
	menu_button.toggled.connect(_on_menu_button_toggled)
	paired_checkbox_menu_button.resized.connect(update_menu_button_witdth)


func connect_status_button_group() -> void:
	status_button_group.pressed.connect(_on_status_button_toggled)


func update_paired_menu() -> void:
	TaskSignalBus._on_checkbox_selection_changed.emit()


func status_change(new_state: TaskTrackingGlobal.Checkbox) -> void:
	if new_state == TaskTrackingGlobal.current_checkbox_state:
		prints("STATUS ALREADY TOGGLED")
		return
	TaskTrackingGlobal.current_checkbox_state = new_state
	update_paired_menu()


func update_panel() -> void:
	default_profile_status_limiter()
	update_status_colors()
	update_paired_menu()
	update_edit_profile_menu()


func reload_profiles() -> void:
	clear_profiles()
	load_all_profiles()


func clear_profiles() -> void:
	var children_to_clear = get_tree().get_nodes_in_group("profile_children")
	for child_iteration in children_to_clear:
		selection_popup_profile_h_box.remove_child(child_iteration)
		child_iteration.queue_free()
	current_sibling = selection_popup_profile_label


func unlock_new_profile() -> void:
	if new_profile_button.text == "Task Data\nNeeded!":
		new_profile_button.text = "New\nProfile"


func _on_status_button_toggled(button_pressed: BaseButton) -> void:
	match button_pressed:
		active_button:
			status_change(TaskTrackingGlobal.Checkbox.ACTIVE)
		in_progress_button:
			status_change(TaskTrackingGlobal.Checkbox.IN_PROGRESS)
		completed_button:
			status_change(TaskTrackingGlobal.Checkbox.COMPLETED)
		expired_button:
			status_change(TaskTrackingGlobal.Checkbox.EXPIRED)
		_:
			prints("Status button error")


func _on_menu_button_toggled(_button_pressed: bool) -> void:
	self.visible = !self.visible


func _on_new_profile_button_pressed() -> void:
	if new_profile_button.text == "Task Data\nNeeded!":
		TaskSignalBus._on_database_manager_remote_open_pressed.emit()
		visible = !visible
		return
	new_profile_button.visible = false
	new_profile_menu.visible = true
	profile_name_line_edit.clear()
	profile_color_picker_button.set_pick_color(DataGlobal.random_color())


func _on_profile_menu_cancel_pressed() -> void:
	new_profile_button.visible = true
	new_profile_menu.visible = false


func _on_profile_menu_accept_pressed() -> void:
	var profile_name: String = profile_name_line_edit.get_text()
	if profile_name == "":
		prints("Profiles need names!")
		DataGlobal.button_based_message(profile_menu_accept, "Name Needed!", 3, ["Can't use White!"])
		return
	var profile_color: Color = profile_color_picker_button.get_pick_color()
	if profile_color == Color.WHITE:
		prints("Profiles cannot be white!")
		DataGlobal.button_based_message(profile_menu_accept, "Can't use White!", 3, ["Name Needed!"])
		profile_color_picker_button.set_pick_color(DataGlobal.random_color())
		return
	create_new_profile(profile_name, profile_color)
	TaskSignalBus._on_section_changed.emit()
	new_profile_button.visible = true
	new_profile_menu.visible = false


func _on_random_color_button_pressed() -> void:
	profile_color_picker_button.set_pick_color(DataGlobal.random_color())


func edit_profile_menu_data_check(profile_name: String, profile_color: Color, edited_profile: Array, previous_profile: Array) -> bool:
	var no_name_error: String = "Name Needed!"
	var white_color_error: String = "Can't use White!"
	var no_change_error: String = "No changes!"
	var edit_profile_menu_errors: Array = [
		no_name_error,
		white_color_error,
		no_change_error,
	]
	if profile_name == "":
		prints("Profiles need names!")
		DataGlobal.button_based_message(edit_profile_menu_accept, no_name_error)
		return false
	if profile_color == Color.WHITE:
		prints("Profiles cannot be white!")
		DataGlobal.button_based_message(edit_profile_menu_accept, white_color_error)
		edit_profile_color_picker_button.set_pick_color(DataGlobal.random_color())
		return false
	if edited_profile == previous_profile:
		prints("No changes made to profile!")
		DataGlobal.button_based_message(edit_profile_menu_accept, no_change_error)
		return false
	prints("Replacing", previous_profile)
	prints("with", edited_profile)
	return true


func _on_edit_profile_menu_accept_pressed() -> void:
	var profile_name: String = edit_profile_name_line_edit.get_text()
	var profile_color: Color = edit_profile_color_picker_button.get_pick_color()
	var edited_profile: Array = [profile_name, profile_color]
	var previous_profile: Array = [
		TaskTrackingGlobal.current_checkbox_profile_name,
		TaskTrackingGlobal.current_checkbox_profile_color,
	]
	if not edit_profile_menu_data_check(profile_name, profile_color, edited_profile, previous_profile):
		return
	var profile_buttons = get_tree().get_nodes_in_group("profile_children")
	for profile: CheckboxProfile in profile_buttons:
		var iteration_profile: Array = [profile.saved_profile_name, profile.saved_profile_color]
		if iteration_profile == previous_profile:
			profile.update_checkbox_profile(profile_name, profile_color)
	edit_profile_button.visible = true
	edit_profile_menu.visible = false
	#replacement_scan(previous_profile, edited_profile)
	#TaskTrackingGlobal.current_checkbox_profile_name = profile_name
	#TaskTrackingGlobal.current_checkbox_profile_color = profile_color
	#TaskSignalBus._on_save_button_pressed.emit()
	#TaskSignalBus._on_new_database_loaded.emit()
	reload_profiles()
	TaskSignalBus._on_checkbox_selection_changed.emit()
	TaskSignalBus._on_profile_selection_changed.emit()


func _on_edit_profile_menu_cancel_pressed() -> void:
	edit_profile_button.visible = true
	edit_profile_menu.visible = false


func _on_edit_random_color_button_pressed() -> void:
	edit_profile_color_picker_button.set_pick_color(DataGlobal.random_color())


func _on_edit_profile_button_pressed() -> void:
	edit_profile_button.visible = false
	edit_profile_menu.visible = true
