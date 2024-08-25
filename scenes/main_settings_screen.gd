extends Control

@onready var main_settings: Control = %MainSettings
@onready var theme_color_palettes_panel_container: PanelContainer = %ThemeColorPalettesPanelContainer
@onready var theme_palette_picker_popup: PanelContainer = %ThemePalettePickerPopup
@onready var preview_panel_panel_container: PanelContainer = %PreviewPanelPanelContainer
var theme_tab_number: int = 1



func _ready() -> void:
	SignalBus._on_main_settings_back_button_pressed.connect(exit_to_main_menu)
	main_settings.color_palette_menu_button.pressed.connect(open_color_palette_menu)
	theme_palette_picker_popup.close_button.pressed.connect(close_color_palette_menu)
	main_settings.preview_panel_check_button.toggled.connect(_on_preview_panel_toggled)
	main_settings.main_settings_tab_container.tab_changed.connect(_on_settings_tab_container_tab_changed)
	_on_preview_panel_toggled(false)
	close_color_palette_menu()


func exit_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func open_color_palette_menu() -> void:
	theme_color_palettes_panel_container.visible = true


func close_color_palette_menu() -> void:
	theme_color_palettes_panel_container.visible = false


func _on_preview_panel_toggled(toggled_parameter: bool) -> void:
	if toggled_parameter:
		preview_panel_panel_container.visible = true
		return
	preview_panel_panel_container.visible = false


func _on_settings_tab_container_tab_changed(tab_parameter: int) -> void:
	if tab_parameter != theme_tab_number:
		preview_panel_panel_container.visible = false
		return
	var preview_toggled: bool = main_settings.preview_panel_check_button.button_pressed
	_on_preview_panel_toggled(preview_toggled)
