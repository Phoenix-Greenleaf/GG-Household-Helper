extends PanelContainer

#@onready var selection_popup_profile_h_box: HBoxContainer = %SelectionPopupProfileHBox
@onready var new_profile_button: Button = %NewProfileButton
@onready var completed_color_rect: ColorRect = %CompletedColorRect
@onready var in_progress_bottom_color_rect: ColorRect = %InProgressBottomColorRect
@onready var selection_popup_profile_label: Label = %SelectionPopupProfileLabel
@onready var current_sibling = selection_popup_profile_label



@export var paired_checkbox_menu_button: Node

var checkbox_profile = preload("res://scenes/screens/checkbox_profile.tscn")
var profile_button_group = preload("res://scenes/screens/checkbox_profile_group.tres")

 

func _ready() -> void:
	load_existing_profiles()
	update_status_colors()
	update_paired_menu_button()
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


func create_new_profile() -> void:
	pass


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



func _on_menu_button_toggled(_button_pressed: bool) -> void:
	self.visible = !self.visible
