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

@export var paired_checkbox_menu_button: Node

var checkbox_profile = preload("res://gui/task_tracking/checkbox_profile.tscn")
var profile_button_group = preload("res://gui/task_tracking/checkbox_profile_group.tres")
var status_button_group = preload("res://gui/task_tracking/checkbox_status_group.tres")
 

func _ready() -> void:
	add_default_profile()
	load_existing_profiles()
	update_status_colors()
	update_paired_menu()
	connect_paired_menu_button()
	connect_status_button_group()
	new_profile_menu.visible = false
	self.visible = false
	in_progress_panel_container.visible = false
	completed_panel_container.visible = false
	new_profile_button.disabled = true
	SignalBus.update_checkbox_button.connect(update_status_colors)
	SignalBus.reload_profiles_triggered.connect(reload_profiles)
	SignalBus.reset_save_warning.connect(unlock_new_profile)


func load_existing_profiles() -> void:
	if not DataGlobal.current_tasksheet_data:
		prints("No Current Data to load profiles")
		return
	var current_profiles: Array = DataGlobal.current_tasksheet_data.user_profiles
	if current_profiles.size() == 0:
		prints("No profiles to load")
		return
	prints("Loading existing profiles:", current_profiles.size())
	for profile in current_profiles:
		add_profile(profile)


func add_profile(target_profile: Array) -> void:
	var new_profile = checkbox_profile.instantiate()
	new_profile.add_to_group("profile_children")
	var profile_button = new_profile.get_node("ProfileButton")
	profile_button.toggled.connect(_on_profile_button_toggled.bind(target_profile))
	profile_button.set_button_group(profile_button_group)
	current_sibling.add_sibling(new_profile)
	new_profile.load_checkbox_profile(target_profile)
	current_sibling = new_profile
	


func add_default_profile() -> void:
	add_profile(DataGlobal.default_profile)
	#remove ability to edit the default


func update_status_colors() -> void:
	prints("Update status colors:")
	var current_color = DataGlobal.current_checkbox_profile[1]
	completed_color_rect.set_color(current_color)
	in_progress_bottom_color_rect.set_color(current_color)
	if current_color == Color(1, 1, 1):
		active_checkbox_border_color_rect.update_border()
		expired_checkbox_border_color_rect.update_border()
		return
	active_checkbox_border_color_rect.update_border(current_color)
	expired_checkbox_border_color_rect.update_border(current_color)


func create_new_profile(profile_name: String, profile_color: Color) -> void:
	var new_profile: Array = [profile_name, profile_color]
	DataGlobal.current_tasksheet_data.user_profiles.append(new_profile)
	add_profile(new_profile)
	SignalBus.trigger_save_warning.emit()


func connect_paired_menu_button() -> void:
	if not paired_checkbox_menu_button:
		self.visible = true
		print("No menu button for visibility!")
		return
	var menu_button = paired_checkbox_menu_button.get_node("Button")
	menu_button.toggled.connect(_on_menu_button_toggled)


func connect_status_button_group() -> void:
	status_button_group.pressed.connect(_on_status_button_toggled)


func update_paired_menu() -> void:
	SignalBus.update_checkbox_button.emit()


func random_color() -> Color:
	var red: float = randf()
	var green: float = randf()
	var blue: float = randf()
	return Color(red, green, blue)


func status_change(new_state: DataGlobal.Checkbox) -> void:
	if new_state == DataGlobal.current_checkbox_state:
		prints("STATUS ALREADY TOGGLED")
		return
	DataGlobal.current_checkbox_state = new_state
	update_paired_menu()


func _on_profile_button_toggled(button_pressed: bool, target_profile: Array) -> void:
	if not button_pressed:
		return
	if target_profile == DataGlobal.current_checkbox_profile:
		prints("PROFILE ALREADY TOGGLED")
		return
	default_profile_status_limiter(target_profile)
	DataGlobal.current_checkbox_profile = target_profile
	update_status_colors()
	update_paired_menu()


func default_profile_status_limiter(profile_parameter: Array) -> void:
	if profile_parameter == DataGlobal.default_profile:
		in_progress_panel_container.visible = false
		completed_panel_container.visible = false
	else:
		in_progress_panel_container.visible = true
		completed_panel_container.visible = true


func _on_status_button_toggled(button_pressed: BaseButton) -> void:
	match button_pressed:
		active_button:
			status_change(DataGlobal.Checkbox.ACTIVE)
		in_progress_button:
			status_change(DataGlobal.Checkbox.IN_PROGRESS)
		completed_button:
			status_change(DataGlobal.Checkbox.COMPLETED)
		expired_button:
			status_change(DataGlobal.Checkbox.EXPIRED)
		_:
			prints("Status button error")


func _on_menu_button_toggled(_button_pressed: bool) -> void:
	self.visible = !self.visible


func _on_new_profile_button_pressed() -> void:
	new_profile_button.visible = false
	new_profile_menu.visible = true
	profile_name_line_edit.clear()
	profile_color_picker_button.set_pick_color(random_color())


func _on_profile_menu_canel_pressed() -> void:
	new_profile_button.visible = true
	new_profile_menu.visible = false


func _on_profile_menu_accept_pressed() -> void:
	var profile_name: String = profile_name_line_edit.get_text()
	if profile_name == "":
		prints("Profiles need names!")
		DataGlobal.button_based_message(profile_menu_accept, "Name Needed!")
		return
	var profile_color: Color = profile_color_picker_button.get_pick_color()
	if profile_color == Color.WHITE:
		prints("Profiles cannot be white!")
		DataGlobal.button_based_message(profile_menu_accept, "Can't use White!")
		profile_color_picker_button.set_pick_color(random_color())
		return
	create_new_profile(profile_name, profile_color)
	new_profile_button.visible = true
	new_profile_menu.visible = false


func reload_profiles() -> void:
	prints("Reloading Profiles")
	clear_profiles()
	add_default_profile()
	load_existing_profiles()


func clear_profiles() -> void:
	var children_to_clear = get_tree().get_nodes_in_group("profile_children")
	for child_iteration in children_to_clear:
		selection_popup_profile_h_box.remove_child(child_iteration)
		child_iteration.queue_free()
	prints("Profiles cleared")


func unlock_new_profile() -> void:
	if new_profile_button.disabled:
		new_profile_button.disabled = false


func _on_random_color_button_pressed() -> void:
	profile_color_picker_button.set_pick_color(random_color())
