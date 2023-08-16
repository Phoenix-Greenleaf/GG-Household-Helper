extends PanelContainer

@onready var current_checkbox_color_rect_top: ColorRect = $CurrentCheckboxMargin/CurrentCheckboxVBox/VBox/CurrentCheckboxColorRectTop
@onready var current_checkbox_color_rect_bottom: ColorRect = $CurrentCheckboxMargin/CurrentCheckboxVBox/VBox/CurrentCheckboxColorRectBottom

@onready var current_checkbox_status_label: Label = $CurrentCheckboxMargin/CurrentCheckboxVBox/CurrentCheckboxStatusLabel
@onready var current_checkbox_profile_label: Label = $CurrentCheckboxMargin/CurrentCheckboxVBox/CurrentCheckboxProfileLabel


var checkbox_status_keys = DataGlobal.Checkbox.keys()




func _ready() -> void:
	disable_capslock()
	update_status()
	update_profile()
	update_checkbox_colors()




func disable_capslock() -> void:
	for status_number in checkbox_status_keys.size():
		var allcaps: String = checkbox_status_keys[status_number]
		var capitalized: String = allcaps.capitalize()
		checkbox_status_keys[status_number] = capitalized



func update_status() -> void:
	var new_status_enum = DataGlobal.current_checkbox_state
	var new_status_text: String = checkbox_status_keys[new_status_enum]
	current_checkbox_status_label.set_text(new_status_text)

func update_profile() -> void:
	var new_profile: Array = DataGlobal.current_checkbox_profile
	var new_profile_text: String = new_profile[0]
	current_checkbox_profile_label.set_text(new_profile_text)

func update_checkbox_colors() -> void:
	var profile_color: Color = DataGlobal.current_checkbox_profile[1]
	var white := Color(1, 1, 1)
	var black := Color(0, 0, 0)
	match DataGlobal.current_checkbox_state:
		DataGlobal.Checkbox.ACTIVE:
			current_checkbox_color_rect_top.set_color(white)
			current_checkbox_color_rect_bottom.set_color(white)
		DataGlobal.Checkbox.IN_PROGRESS:
			current_checkbox_color_rect_top.set_color(white)
			current_checkbox_color_rect_bottom.set_color(profile_color)
		DataGlobal.Checkbox.COMPLETED:
			current_checkbox_color_rect_top.set_color(profile_color)
			current_checkbox_color_rect_bottom.set_color(profile_color)
		DataGlobal.Checkbox.EXPIRED:
			current_checkbox_color_rect_top.set_color(black)
			current_checkbox_color_rect_bottom.set_color(black)
		_:
			print("update_checkbox_colors match failure!")
