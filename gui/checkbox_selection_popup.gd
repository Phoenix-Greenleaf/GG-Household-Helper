extends PanelContainer

@onready var new_profile_button: Button = %NewProfileButton
@onready var new_profile_menu: PanelContainer = %NewProfileMenu
@onready var completed_color_rect: ColorRect = %CompletedColorRect
@onready var in_progress_bottom_color_rect: ColorRect = %InProgressBottomColorRect
@onready var selection_popup_profile_label: Label = %SelectionPopupProfileLabel
@onready var current_sibling = selection_popup_profile_label
@onready var profile_name_line_edit: LineEdit = %ProfileNameLineEdit
@onready var profile_color_picker_button: ColorPickerButton = %ProfileColorPickerButton

@onready var active_button: Button = $SelectionPopupMargin/SelectionPopupVBox/SelectionPopupStatusHBox/Status1PanelContainer/ActiveButton
@onready var in_progress_button: Button = $SelectionPopupMargin/SelectionPopupVBox/SelectionPopupStatusHBox/Status2PanelContainer/InProgressButton
@onready var completed_button: Button = $SelectionPopupMargin/SelectionPopupVBox/SelectionPopupStatusHBox/Status3PanelContainer/CompletedButton
@onready var expired_button: Button = $SelectionPopupMargin/SelectionPopupVBox/SelectionPopupStatusHBox/Status4PanelContainer/ExpiredButton


@export var paired_checkbox_menu_button: Node

var checkbox_profile = preload("res://gui/checkbox_profile.tscn")
var profile_button_group = preload("res://gui/checkbox_profile_group.tres")
var status_button_group = preload("res://gui/checkbox_status_group.tres")
 

func _ready() -> void:
	add_default_profile()
	load_existing_profiles()
	update_status_colors()
	update_paired_menu()
	new_profile_menu.visible = false
	self.visible = false
	connect_paired_menu_button()
	connect_status_button_group()
	SignalBus.update_checkbox_button.connect(update_status_colors)


func load_existing_profiles() -> void:
	for profile in DataGlobal.user_profiles:
		add_profile(profile)


func add_profile(target_profile: Array) -> void:
	var new_profile = checkbox_profile.instantiate()
	var profile_button = new_profile.get_node("ProfileButton")
	profile_button.toggled.connect(_on_profile_button_toggled.bind(target_profile))
	profile_button.set_button_group(profile_button_group)
	current_sibling.add_sibling(new_profile)
	new_profile.load_checkbox_profile(target_profile)
	current_sibling = new_profile
	


func add_default_profile() -> void:
	add_profile(DataGlobal.default_profile)
	#remove edit/delete buttons from default


func update_status_colors() -> void:
	var current_color = DataGlobal.current_checkbox_profile[1]
	completed_color_rect.set_color(current_color)
	in_progress_bottom_color_rect.set_color(current_color)


func create_new_profile(profile_name: String, profile_color: Color) -> void:
	var new_profile: Array = [profile_name, profile_color]
	DataGlobal.user_profiles.append(new_profile)
	add_profile(new_profile)


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
	DataGlobal.current_checkbox_profile = target_profile
	update_status_colors()
	update_paired_menu()


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
	var profile_color: Color = profile_color_picker_button.get_pick_color()
	create_new_profile(profile_name, profile_color)
	new_profile_button.visible = true
	new_profile_menu.visible = false

