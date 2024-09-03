extends PanelContainer

@onready var current_checkbox_color_rect_top: ColorRect = %CurrentCheckboxColorRectTop
@onready var current_checkbox_color_rect_bottom: ColorRect = %CurrentCheckboxColorRectBottom
@onready var current_checkbox_border_color_rect: ColorRect = %CurrentCheckboxBorderColorRect

@onready var current_checkbox_status_label: Label = %CurrentCheckboxStatusLabel
@onready var current_checkbox_profile_label: Label = %CurrentCheckboxProfileLabel

var checkbox_status_keys = DataGlobal.Checkbox.keys()


func _ready() -> void:
	disable_capslock()
	TaskSignalBus._on_checkbox_selection_changed.connect(update_all)
	update_all()


func update_all() -> void:
	update_status()
	update_profile()
	update_checkbox_colors()


func disable_capslock() -> void:
	for status_number in checkbox_status_keys.size():
		var allcaps: String = checkbox_status_keys[status_number]
		var capitalized: String = allcaps.capitalize()
		checkbox_status_keys[status_number] = capitalized


func update_status() -> void:
	var new_status_enum = DataGlobal.task_tracking_current_checkbox_state
	var new_status_text: String = checkbox_status_keys[new_status_enum]
	current_checkbox_status_label.set_text(new_status_text)


func update_profile() -> void:
	var new_profile_text: String = DataGlobal.task_tracking_current_checkbox_profile[0]
	current_checkbox_profile_label.set_text(new_profile_text)


func update_checkbox_colors() -> void:
	var profile_color: Color = DataGlobal.task_tracking_current_checkbox_profile[1]
	var white := Color(1, 1, 1)
	var black := Color(0, 0, 0)
	match DataGlobal.task_tracking_current_checkbox_state:
		DataGlobal.Checkbox.ACTIVE:
			current_checkbox_color_rect_top.set_color(white)
			current_checkbox_color_rect_bottom.set_color(white)
			update_current_border(profile_color)
		DataGlobal.Checkbox.IN_PROGRESS:
			current_checkbox_color_rect_top.set_color(white)
			current_checkbox_color_rect_bottom.set_color(profile_color)
			update_current_border(white)
		DataGlobal.Checkbox.COMPLETED:
			current_checkbox_color_rect_top.set_color(profile_color)
			current_checkbox_color_rect_bottom.set_color(profile_color)
			update_current_border(white)
		DataGlobal.Checkbox.EXPIRED:
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
