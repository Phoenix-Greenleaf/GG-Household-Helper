extends PanelContainer

@onready var current_checkbox_color_rect_top: ColorRect = %CurrentCheckboxColorRectTop
@onready var current_checkbox_color_rect_bottom: ColorRect = %CurrentCheckboxColorRectBottom
@onready var current_checkbox_border_color_rect: ColorRect = %CurrentCheckboxBorderColorRect

@onready var current_checkbox_status_label: Label = %CurrentCheckboxStatusLabel
@onready var current_checkbox_profile_label: Label = %CurrentCheckboxProfileLabel

var checkbox_status_keys = TaskTrackingGlobal.Checkbox.keys()


func _ready() -> void:
	capitalize_checkbox_status_keys()
	TaskSignalBus._on_checkbox_selection_changed.connect(update_all)
	update_all()


func capitalize_checkbox_status_keys() -> void:
	for status_number in checkbox_status_keys.size():
		var allcaps: String = checkbox_status_keys[status_number]
		var capitalized: String = allcaps.capitalize()
		checkbox_status_keys[status_number] = capitalized


func update_all() -> void:
	update_status()
	update_profile()
	update_checkbox_colors()


func update_status() -> void:
	var new_status_enum = TaskTrackingGlobal.current_checkbox_state
	var new_status_text: String = checkbox_status_keys[new_status_enum]
	current_checkbox_status_label.set_text(new_status_text)


func update_profile() -> void:
	var new_profile_text: String = TaskTrackingGlobal.current_checkbox_profile_name
	current_checkbox_profile_label.set_text(new_profile_text)


func update_checkbox_colors() -> void:
	var profile_color: Color = TaskTrackingGlobal.current_checkbox_profile_color
	var white: Color = Color.WHITE
	var black: Color = Color.BLACK
	match TaskTrackingGlobal.current_checkbox_state:
		TaskTrackingGlobal.Checkbox.ACTIVE:
			current_checkbox_color_rect_top.set_color(white)
			current_checkbox_color_rect_bottom.set_color(white)
			update_current_border(profile_color)
		TaskTrackingGlobal.Checkbox.IN_PROGRESS:
			current_checkbox_color_rect_top.set_color(white)
			current_checkbox_color_rect_bottom.set_color(profile_color)
			update_current_border(white)
		TaskTrackingGlobal.Checkbox.COMPLETED:
			current_checkbox_color_rect_top.set_color(profile_color)
			current_checkbox_color_rect_bottom.set_color(profile_color)
			update_current_border(white)
		TaskTrackingGlobal.Checkbox.EXPIRED:
			current_checkbox_color_rect_top.set_color(black)
			current_checkbox_color_rect_bottom.set_color(black)
			update_current_border(profile_color)
		_:
			print("update_checkbox_colors match failure!")


func update_current_border(color_parameter: Color) -> void:
	if color_parameter == Color(1, 1, 1):
		current_checkbox_border_color_rect.update_border()
		return
	current_checkbox_border_color_rect.update_border(color_parameter)
