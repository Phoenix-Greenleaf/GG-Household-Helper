extends PanelContainer

class_name CheckboxProfile

@onready var profile_color_rect: ColorRect = %ProfileColorRect
@onready var profile_label: Label = %ProfileLabel
@onready var profile_button: Button = %ProfileButton
var saved_profile_name: String
var saved_profile_color: Color
var saved_profile_id: int


func _ready() -> void:
	load_checkboad_default()
	TaskSignalBus._on_checkbox_selection_changed.connect(toggle_to_focused_cell)


func load_checkboad_default() -> void:
	load_checkbox_profile(
		TaskTrackingGlobal.default_profile_id,
		TaskTrackingGlobal.default_profile_name,
		TaskTrackingGlobal.default_profile_color,
	)


func load_checkbox_profile(target_id: int, target_name: String, target_color: Color) -> void:
	saved_profile_id = target_id
	saved_profile_name = target_name
	saved_profile_color = target_color
	profile_label.set_text(saved_profile_name)
	profile_color_rect.set_color(saved_profile_color)


func update_checkbox_profile(target_name: String, target_color: Color) -> void:
	saved_profile_name = target_name
	saved_profile_color = target_color
	profile_label.set_text(saved_profile_name)
	profile_color_rect.set_color(saved_profile_color)
	TaskSignalBus._on_user_profile_updated.emit(saved_profile_id, saved_profile_name, saved_profile_color)


func toggle_to_focused_cell() -> void:
	if TaskTrackingGlobal.current_checkbox_profile_id != saved_profile_id:
		profile_button.set_pressed_no_signal(false)
		return
	profile_button.set_pressed_no_signal(true)


func activate_profile() -> void:
	TaskTrackingGlobal.current_checkbox_profile_id = saved_profile_id
	TaskTrackingGlobal.current_checkbox_profile_name = saved_profile_name
	TaskTrackingGlobal.current_checkbox_profile_color = saved_profile_color


func _on_profile_button_toggled(button_pressed: bool) -> void:
	if not button_pressed:
		return
	if saved_profile_id == TaskTrackingGlobal.current_checkbox_profile_id:
		prints("PROFILE ALREADY TOGGLED")
		return
	activate_profile()
