extends PanelContainer

@onready var new_profile_button: Button = %NewProfileButton
@onready var new_profile_menu: PanelContainer = %NewProfileMenu
@onready var completed_color_rect: ColorRect = %CompletedColorRect
@onready var in_progress_bottom_color_rect: ColorRect = %InProgressBottomColorRect
@onready var selection_popup_profile_label: Label = %SelectionPopupProfileLabel
@onready var current_sibling = selection_popup_profile_label
@onready var profile_name_line_edit: LineEdit = %ProfileNameLineEdit
@onready var profile_color_picker_button: ColorPickerButton = %ProfileColorPickerButton




@export var paired_checkbox_menu_button: Node

var checkbox_profile = preload("res://scenes/screens/checkbox_profile.tscn")
var profile_button_group = preload("res://scenes/screens/checkbox_profile_group.tres")

 

func _ready() -> void:
	load_existing_profiles()
	update_status_colors()
	update_paired_menu_button()
	new_profile_menu.visible = false
	self.visible = false
	connect_paired_menu_button()
	

func add_profile(target_profile: Array) -> void:
	var new_profile = checkbox_profile.instantiate()
	var profile_button = new_profile.get_node("ProfileButton")
	profile_button.toggled.connect(_on_profile_button_toggled.bind(target_profile))
	profile_button.set_button_group(profile_button_group)
	
	current_sibling.add_sibling(new_profile)
	new_profile.load_checkbox_profile(target_profile)
	current_sibling = new_profile

func load_existing_profiles() -> void:
	for profile in DataGlobal.user_profiles:
		if profile[0] != "Default":
			add_profile(profile)



func update_status_colors() -> void:
	var current_color = DataGlobal.current_checkbox_profile[1]
	completed_color_rect.set_color(current_color)
	in_progress_bottom_color_rect.set_color(current_color)


func create_new_profile(profile_name: String, profile_color: Color) -> void:
	var new_profile: Array = [profile_name, profile_color]
	DataGlobal.user_profiles.append(new_profile)
	add_profile(new_profile)


func connect_paired_menu_button() -> void:
	if paired_checkbox_menu_button:
		var menu_button = paired_checkbox_menu_button.get_node("Button")
		menu_button.toggled.connect(_on_menu_button_toggled)
	else:
		self.visible = true
		print("No menu button for visibility!")


func _on_profile_button_toggled(button_pressed: bool, target_profile: Array) -> void:
	if (button_pressed): # these toggle tests may not be needed, see _on_menu_button_toggled()
		if target_profile != DataGlobal.current_checkbox_profile:
			DataGlobal.current_checkbox_profile = target_profile
			update_status_colors()
			update_paired_menu_button()
		else:
			prints("ALREADY TOGGLED")


func update_paired_menu_button() -> void:
	if paired_checkbox_menu_button:
		paired_checkbox_menu_button.update_profile()
	else:
		print("No menu button to update!")


func random_color() -> Color:
	var red: float = randf()
	var green: float = randf()
	var blue: float = randf()
	return Color(red, green, blue)


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
	
