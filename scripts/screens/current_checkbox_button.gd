extends PanelContainer

@onready var current_checkbox_color_rect: ColorRect = $CurrentCheckboxMargin/CurrentCheckboxVBox/CurrentCheckboxColorRect
@onready var current_checkbox_status_label: Label = $CurrentCheckboxMargin/CurrentCheckboxVBox/CurrentCheckboxStatusLabel
@onready var current_checkbox_profile_label: Label = $CurrentCheckboxMargin/CurrentCheckboxVBox/CurrentCheckboxProfileLabel


var checkbox_status_keys = DataGlobal.Checkbox.keys()




func _ready() -> void:
	disable_capslock()
	update_profile()
	update_status()




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
	var new_profile_color: Color = new_profile[1]
	current_checkbox_profile_label.set_text(new_profile_text)
	current_checkbox_color_rect.set_color(new_profile_color)




