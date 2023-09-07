extends PanelContainer


@onready var profile_color_rect: ColorRect = %ProfileColorRect
@onready var profile_label: Label = %ProfileLabel
@onready var profile_button: Button = %ProfileButton


func _ready() -> void:
	var default_profile: Array = DataGlobal.default_profile
	load_checkbox_profile(default_profile)

func load_checkbox_profile(target_profile: Array) -> void:
	profile_label.set_text(target_profile[0])
	profile_color_rect.set_color(target_profile[1])
