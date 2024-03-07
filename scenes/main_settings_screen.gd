extends Control

@onready var main_settings: Control = %MainSettings
@onready var theme_color_palettes_panel_container: PanelContainer = %ThemeColorPalettesPanelContainer
@onready var theme_palette_picker_popup: PanelContainer = %ThemePalettePickerPopup


func _ready() -> void:
	SceneTransition.fade_from_black()
	SignalBus._on_main_settings_back_button_pressed.connect(exit_to_main_menu)
	main_settings.color_palette_menu_button.pressed.connect(open_color_palette_menu)
	theme_palette_picker_popup.close_button.pressed.connect(close_color_palette_menu)
	close_color_palette_menu()


func exit_to_main_menu() -> void:
	SceneTransition.fade_to_black("res://scenes/main_menu.tscn")


func open_color_palette_menu() -> void:
	theme_color_palettes_panel_container.visible = true


func close_color_palette_menu() -> void:
	theme_color_palettes_panel_container.visible = false
