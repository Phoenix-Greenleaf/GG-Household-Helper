extends PanelContainer

@onready var color_rect: ColorRect = %ColorRect
@onready var color_rect_2: ColorRect = %ColorRect2
@onready var color_rect_3: ColorRect = %ColorRect3
@onready var color_rect_4: ColorRect = %ColorRect4
@onready var color_rect_5: ColorRect = %ColorRect5
@onready var color_rect_6: ColorRect = %ColorRect6
@onready var color_rect_7: ColorRect = %ColorRect7
@onready var color_rect_8: ColorRect = %ColorRect8
@onready var color_rect_9: ColorRect = %ColorRect9
@onready var color_rect_10: ColorRect = %ColorRect10
@onready var color_rect_11: ColorRect = %ColorRect11
@onready var color_rect_12: ColorRect = %ColorRect12
@onready var color_rect_13: ColorRect = %ColorRect13
@onready var color_rect_14: ColorRect = %ColorRect14
@onready var color_rect_15: ColorRect = %ColorRect15
@onready var color_rect_16: ColorRect = %ColorRect16
@onready var reset_button: Button = %ResetButton
@onready var palette_name_button: Button = %PaletteNameButton

@export var color_set_for_reset: Dictionary



func _ready() -> void:
	reset_button.visible = false


func set_palette_color(color_set_parameter: Dictionary) -> void:
	color_rect.color = color_set_parameter.theme_background_color
	color_rect_2.color = color_set_parameter.theme_primary_color
	color_rect_3.color = color_set_parameter.theme_secondary_color
	color_rect_4.color = color_set_parameter.theme_tertiary_color
	color_rect_5.color = color_set_parameter.theme_quaternary_color
	color_rect_6.color = color_set_parameter.theme_quinary_color
	color_rect_7.color = color_set_parameter.theme_border_line_color
	color_rect_8.color = color_set_parameter.theme_font_color
	color_rect_9.color = color_set_parameter.theme_outlines_color
	color_rect_10.color = color_set_parameter.theme_button_default_color
	color_rect_11.color = color_set_parameter.theme_button_disabled_color
	color_rect_12.color = color_set_parameter.theme_button_focus_color
	color_rect_13.color = color_set_parameter.theme_button_pressed_color
	color_rect_14.color = color_set_parameter.theme_button_hover_color
	color_rect_15.color = color_set_parameter.theme_transparency_default_color
	color_rect_16.color = color_set_parameter.theme_transparency_warning_color


func enable_reset_button() -> void:
	reset_button.visible = true


func set_palette_name(palette_name: String) -> void:
	palette_name_button.text = palette_name


func set_palette_button_group(group: ButtonGroup) -> void:
	palette_name_button.button_group = group











