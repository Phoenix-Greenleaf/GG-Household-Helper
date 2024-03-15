extends Control


@onready var close_button: Button = %CloseButton
@onready var preset_palette_v_box_container: VBoxContainer = %PresetPaletteVBoxContainer
@onready var custom_palette_v_box_container: VBoxContainer = %CustomPaletteVBoxContainer

const COLOR_PALETTE_STRIP = preload("res://gui/main_helper/color_palette_strip.tscn")
const COLOR_PALETTE_LABEL_BUTTON_GROUP = preload("res://gui/main_helper/color_palette_label_button_group.tres")

var current_palette: String
var chromatic_array := [
	"red",
	"orange",
	"yellow",
	"green",
	"blue",
	"purple",
	"pink",
	"neutral",
]
var custom_chromatic_array := [
	"red custom",
	"orange custom",
	"yellow custom",
	"green custom",
	"blue custom",
	"purple custom",
	"pink custom",
	"neutral custom",
]



func _ready():
	SignalBus._on_theme_settings_color_palette_updated.connect(refresh_palettes)
	refresh_palettes()


func empty_palette_colums() -> void:
	for child in preset_palette_v_box_container.get_children():
		preset_palette_v_box_container.remove_child(child)
		child.queue_free()
	for child in custom_palette_v_box_container.get_children():
		custom_palette_v_box_container.remove_child(child)
		child.queue_free()


func load_color_palettes() -> void:
	var color_palettes: Dictionary = DataGlobal.active_settings_main.theme_color_palettes
	for palette_name in chromatic_array:
		add_preset_palette(palette_name, color_palettes[palette_name])
	for palette_name in custom_chromatic_array:
		add_custom_palette(palette_name, color_palettes[palette_name])
	SignalBus._on_theme_settings_color_palettes_loaded.emit()


func add_preset_palette(palette_name_parameter: String, palette_colors_parameter: Dictionary) -> void:
	var color_palette_strip_instance = COLOR_PALETTE_STRIP.instantiate()
	preset_palette_v_box_container.add_child(color_palette_strip_instance)
	color_palette_strip_instance.set_palette_name(palette_name_parameter.capitalize())
	color_palette_strip_instance.set_palette_color(palette_colors_parameter)
	color_palette_strip_instance.set_palette_button_group(COLOR_PALETTE_LABEL_BUTTON_GROUP)

func add_custom_palette(palette_name_parameter: String, palette_colors_parameter: Dictionary) -> void:
	var color_palette_strip_instance = COLOR_PALETTE_STRIP.instantiate()
	custom_palette_v_box_container.add_child(color_palette_strip_instance)
	color_palette_strip_instance.set_palette_name(palette_name_parameter)
	color_palette_strip_instance.set_palette_color(palette_colors_parameter)
	color_palette_strip_instance.enable_reset_button()
	color_palette_strip_instance.set_palette_button_group(COLOR_PALETTE_LABEL_BUTTON_GROUP)


func refresh_palettes() -> void:
	empty_palette_colums()
	load_color_palettes()
