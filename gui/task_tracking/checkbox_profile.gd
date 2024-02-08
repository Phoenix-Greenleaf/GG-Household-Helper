extends PanelContainer


@onready var profile_color_rect: ColorRect = %ProfileColorRect
@onready var profile_label: Label = %ProfileLabel
@onready var profile_button: Button = %ProfileButton
@onready var saved_profile: Array


func _ready() -> void:
	var default_profile: Array = DataGlobal.default_profile
	load_checkbox_profile(default_profile)
	SignalBus._on_task_editor_checkbox_selection_changed.connect(toggle_to_focused_cell)


func load_checkbox_profile(target_profile: Array) -> void:
	saved_profile = target_profile
	profile_label.set_text(saved_profile[0])
	profile_color_rect.set_color(saved_profile[1])


func toggle_to_focused_cell() -> void:
	if DataGlobal.current_checkbox_profile != saved_profile:
		profile_button.set_pressed_no_signal(false)
		return
	profile_button.set_pressed_no_signal(true)
	
	
