extends Control

@onready var main_settings_tab_container: TabContainer = %MainSettingsTabContainer
@onready var resolution_width_option_button: OptionButton = %ResolutionWidthOptionButton
@onready var resolution_height_option_button: OptionButton = %ResolutionHeightOptionButton
@onready var custom_resolution_h_box_container: HBoxContainer = %CustomResolutionHBoxContainer
@onready var custom_width_spin_box: SpinBox = %CustomWidthSpinBox
@onready var custom_height_spin_box: SpinBox = %CustomHeightSpinBox
@onready var display_preference_option_button: OptionButton = %DisplayPreferenceOptionButton
@onready var display_mode_option_button: OptionButton = %DisplayModeOptionButton
@onready var borderless_check_button: CheckButton = %BorderlessCheckButton
@onready var borderless_status_label: Label = %BorderlessStatusLabel
@onready var accept_button: Button = %AcceptButton
@onready var reset_button: Button = %ResetButton
@onready var back_button: Button = %BackButton
@onready var test_h_separator: HSeparator = %TestHSeparator
@onready var test_buttons_h_box_container: HBoxContainer = %TestButtonsHBoxContainer
@onready var test_button: Button = %TestButton
@onready var save_warning_label: Label = %SaveWarningLabel
@onready var test_change_timer_label: Label = %TestChangeTimerLabel
@onready var test_change_timer: Timer = %TestChangeTimer
@onready var cancel_changes_button: Button = %CancelChangesButton
@onready var theme_title_size_spin_box: SpinBox = %ThemeTitleSizeSpinBox
@onready var theme_sub_title_size_spin_box: SpinBox = %ThemeSubTitleSizeSpinBox
@onready var theme_large_size_spin_box: SpinBox = %ThemeLargeSizeSpinBox
@onready var theme_medium_size_spin_box: SpinBox = %ThemeMediumSizeSpinBox
@onready var theme_small_size_spin_box: SpinBox = %ThemeSmallSizeSpinBox
@onready var theme_font_color_picker_button: ColorPickerButton = %ThemeFontColorPickerButton
@onready var theme_outline_color_picker_button: ColorPickerButton = %ThemeOutlineColorPickerButton
@onready var theme_background_color_picker_button: ColorPickerButton = %ThemeBackgroundColorPickerButton
@onready var theme_border_line_color_picker_button: ColorPickerButton = %ThemeBorderLineColorPickerButton
@onready var theme_primary_color_picker_button: ColorPickerButton = %ThemePrimaryColorPickerButton
@onready var theme_secondary_color_picker_button: ColorPickerButton = %ThemeSecondaryColorPickerButton
@onready var theme_tertiary_color_picker_button: ColorPickerButton = %ThemeTertiaryColorPickerButton
@onready var theme_quaternary_color_picker_button: ColorPickerButton = %ThemeQuaternaryColorPickerButton
@onready var theme_quinary_color_picker_button: ColorPickerButton = %ThemeQuinaryColorPickerButton
@onready var theme_button_default_color_picker_button: ColorPickerButton = %ThemeButtonDefaultColorPickerButton
@onready var theme_button_disabled_color_picker_button: ColorPickerButton = %ThemeButtonDisabledColorPickerButton
@onready var theme_button_focus_color_picker_button: ColorPickerButton = %ThemeButtonFocusColorPickerButton
@onready var theme_button_pressed_color_picker_button: ColorPickerButton = %ThemeButtonPressedColorPickerButton
@onready var theme_button_hover_color_picker_button: ColorPickerButton = %ThemeButtonHoverColorPickerButton
@onready var theme_transparency_default_color_picker_button: ColorPickerButton = %ThemeTransparencyDefaultColorPickerButton
@onready var theme_transparency_warning_color_picker_button: ColorPickerButton = %ThemeTransparencyWarningColorPickerButton
@onready var theme_test_button: Button = %ThemeTestButton
@onready var theme_save_warning_label: Label = %ThemeSaveWarningLabel
@onready var theme_test_change_timer_label: Label = %ThemeTestChangeTimerLabel
@onready var theme_cancel_changes_button: Button = %ThemeCancelChangesButton
@onready var theme_reset_button: Button = %ThemeResetButton
@onready var theme_test_change_timer: Timer = %ThemeTestChangeTimer
@onready var theme_test_h_separator: HSeparator = %ThemeTestHSeparator
@onready var theme_test_buttons_h_box_container: HBoxContainer = %ThemeTestButtonsHBoxContainer
@onready var color_palette_menu_button: Button = %ColorPaletteMenuButton
@onready var preview_panel_check_button: CheckButton = %PreviewPanelCheckButton

@onready var settings = MainSettings.active_settings_main

const COLOR_PALETTE_LABEL_BUTTON_GROUP = preload("res://gui/main_helper/color_palette_label_button_group.tres")

var testing_active: bool = false
var test_time: int = 13
var current_setting_tab: int = 0
var ignore_window_resize: bool = true




func _ready() -> void:
	connect_signals()
	initialize_all_sections()
	fix_theme_variations()
	toggle_changed_settings_section()
	theme_toggle_changed_settings_section()
	main_settings_tab_container.set_current_tab(0)


func _process(_delta: float) -> void:
	if not testing_active:
		return
	match main_settings_tab_container.current_tab:
		0:
			test_change_timer_label.set_text(str(int(test_change_timer.time_left)))
		1:
			theme_test_change_timer_label.set_text(str(int(theme_test_change_timer.time_left)))
		_:
			prints("No tab timer to update")


func initialize_all_sections() -> void:
	initialize_display()
	initialize_theme()


func initialize_display() -> void:
	initialize_option_buttons()
	test_change_timer_label.text = ""
	apply_current_display_server_to_menu()


func fix_theme_variations() -> void:
	DataGlobal.theme_variation_issue_workaround(resolution_width_option_button, "PopupMenu_Medium")
	DataGlobal.theme_variation_issue_workaround(resolution_height_option_button, "PopupMenu_Medium")
	DataGlobal.theme_variation_issue_workaround(custom_width_spin_box, "LineEdit_Medium")
	DataGlobal.theme_variation_issue_workaround(custom_height_spin_box, "LineEdit_Medium")
	DataGlobal.theme_variation_issue_workaround(display_preference_option_button, "PopupMenu_Medium")
	DataGlobal.theme_variation_issue_workaround(display_mode_option_button, "PopupMenu_Medium")
	
	DataGlobal.theme_variation_issue_workaround(theme_title_size_spin_box, "LineEdit_Medium")
	DataGlobal.theme_variation_issue_workaround(theme_sub_title_size_spin_box, "LineEdit_Medium")
	DataGlobal.theme_variation_issue_workaround(theme_large_size_spin_box, "LineEdit_Medium")
	DataGlobal.theme_variation_issue_workaround(theme_medium_size_spin_box, "LineEdit_Medium")
	DataGlobal.theme_variation_issue_workaround(theme_small_size_spin_box, "LineEdit_Medium")


func initialize_option_buttons() -> void:
	initialize_resolution_lists(resolution_width_option_button, MainSettings.screen_native_width)
	initialize_resolution_lists(resolution_height_option_button, MainSettings.screen_native_height)
	initialize_display_preference_options()


func initialize_resolution_lists(
	button_parameter: OptionButton,
	native_resolution_paramter: int,
) -> void:
	button_parameter.clear()
	for resolution_iteration in MainSettings.resolution_list:
		if resolution_iteration == native_resolution_paramter:
			button_parameter.add_item(str(resolution_iteration)+" Native")
		else:
			button_parameter.add_item(str(resolution_iteration))
	button_parameter.add_item("Custom")


func initialize_display_preference_options() -> void:
	display_preference_option_button.clear()
	for display_iteration in MainSettings.screen_count:
		var monitor_name: String = "Monitor " + str(display_iteration + 1)
		var monitor_size: Vector2i = DisplayServer.screen_get_size(display_iteration)
		var monitor_size_string: String = ("  (" + str(monitor_size.x) + " x "
			+ str(monitor_size.y) + ")"
		)
		display_preference_option_button.add_item(monitor_name + monitor_size_string)


func connect_signals() -> void:
	test_change_timer.timeout.connect(test_changes_end)
	theme_test_change_timer.timeout.connect(theme_test_changes_end)
	get_tree().get_root().size_changed.connect(window_resized)
	COLOR_PALETTE_LABEL_BUTTON_GROUP.pressed.connect(theme_palette_button_pressed)
	SignalBus._on_theme_settings_color_palettes_loaded.connect(theme_select_current_palette_button)
	SignalBus._on_theme_settings_color_palette_reset.connect(theme_reset_palette)
	connect_theme_color_pickers()


func connect_theme_color_pickers() -> void:
	theme_font_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_outline_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_background_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_border_line_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_primary_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_secondary_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_tertiary_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_quaternary_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_quinary_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_button_default_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_button_disabled_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_button_focus_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_button_pressed_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_button_hover_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_transparency_default_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)
	theme_transparency_warning_color_picker_button.color_changed.connect(theme_preset_palette_swaps_to_custom_when_edited)


func apply_display_settings_to_menu() -> void:
	apply_both_resolutions(MainSettings.window_width, MainSettings.window_height)
	apply_display_preference(MainSettings.current_screen)
	apply_display_mode(MainSettings.monitor_mode)
	apply_borderless(MainSettings.borderless)
	disable_changed_settings_section(true)


func apply_current_display_server_to_menu() -> void:
	var active_window_width = MainSettings.window_width
	var active_window_height = MainSettings.window_height
	var active_screen = MainSettings.current_screen
	var active_display_mode = MainSettings.monitor_mode
	var active_borderless = MainSettings.borderless
	apply_both_resolutions(active_window_width, active_window_height)
	apply_display_preference(active_screen)
	apply_display_mode(active_display_mode)
	apply_borderless(active_borderless)
	toggle_changed_settings_section()


func apply_both_resolutions(width_parameter: int, height_parameter: int) -> void:
	apply_resolution(resolution_width_option_button, custom_width_spin_box, width_parameter)
	apply_resolution(resolution_height_option_button, custom_height_spin_box, height_parameter)
	toggle_custom_resolution_container()


func apply_resolution(button_parameter: OptionButton, spinbox_parameter: SpinBox,
	resolution_parameter: int
) -> void:
	spinbox_parameter.value = resolution_parameter
	if resolution_parameter not in MainSettings.resolution_list:
		button_parameter.select(MainSettings.resolution_list.size())
		spinbox_parameter.editable = true
		return
	var resolution_index = MainSettings.resolution_list.find(resolution_parameter)
	button_parameter.select(resolution_index)
	spinbox_parameter.editable = false


func toggle_custom_resolution_container() -> void:
	if (resolution_height_option_button.selected != MainSettings.resolution_list.size()
		and resolution_width_option_button.selected != MainSettings.resolution_list.size()
	):
		custom_resolution_h_box_container.visible = false
		return
	custom_resolution_h_box_container.visible = true
	toggle_custom_dimension_disable(resolution_height_option_button, custom_height_spin_box)
	toggle_custom_dimension_disable(resolution_width_option_button, custom_width_spin_box)


func toggle_custom_dimension_disable(option_button_parameter: OptionButton,
	spin_box_parameter: SpinBox
) -> void:
	if option_button_parameter.selected == MainSettings.resolution_list.size():
		spin_box_parameter.editable = true
	else:
		spin_box_parameter.editable = false


func apply_display_preference(display_parameter: int) -> void:
	display_preference_option_button.select(display_preference_option_button.get_item_index(display_parameter))
	toggle_display_preference_option_button()


func toggle_display_preference_option_button() -> void:
	if display_preference_option_button.item_count < 2:
		display_preference_option_button.disabled = true


func apply_display_mode(display_mode_parameter: int) -> void:
	display_mode_option_button.select(display_mode_option_button.get_item_index(display_mode_parameter)) 


func apply_borderless(borderless_parameter: bool) -> void:
	if display_mode_option_button.selected == 0:
		borderless_check_button.disabled = false
		borderless_check_button.set_pressed_no_signal(borderless_parameter)
		if MainSettings.borderless:
			borderless_status_label.text = "On"
			return
		borderless_status_label.text = "Off"
		return
	if display_mode_option_button.selected == 1:
		borderless_check_button.disabled = true
		borderless_check_button.set_pressed_no_signal(true)
		borderless_status_label.text = "On"
		return
	prints("apply_borderless ERROR!")


func toggle_borderless_button() -> void:
	if display_mode_option_button.selected == 0:
		borderless_check_button.disabled = false
		return
	if display_mode_option_button.selected == 1:
		borderless_check_button.disabled = true
		return
	prints("Toggle_borderless ERROR!")


func toggle_changed_settings_section() -> void:
	var settings_changed: bool = changed_settings_check()
	prints("Settings changed:", settings_changed)
	if display_mode_option_button.selected == 1:
		fullscreen_resolution_lock(true)
	if display_mode_option_button.selected == 0:
		fullscreen_resolution_lock(false)
	if settings_changed:
		disable_changed_settings_section(false)
		return
	disable_changed_settings_section(true)


func disable_changed_settings_section(disabled_parameter: bool) -> void:
	test_h_separator.visible = !disabled_parameter
	test_buttons_h_box_container.visible = !disabled_parameter
	toggle_accept_button()


func changed_settings_check() -> bool:
	if MainSettings.window_width != custom_width_spin_box.value: 
		prints("Width setting changed")
		return true
	if MainSettings.window_height != custom_height_spin_box.value:
		prints("Height setting changed")
		return true
	if MainSettings.monitor_mode != display_mode_option_button.get_item_id(display_mode_option_button.selected): 
		prints("Display mode setting changed")
		return true
	if MainSettings.current_screen != display_preference_option_button.get_item_id(display_preference_option_button.selected):
		prints("Display preference setting changed")
		return true
	if MainSettings.borderless != borderless_check_button.button_pressed:
		if display_mode_option_button.selected == 0:
			prints("Borderless setting changed")
			return true
	return false


func test_changes_start() -> void:
	test_mass_disable(true)
	disable_main_settings_tab_container_all_tabs(true)
	MainSettings.set_window(display_preference_option_button.selected,
		display_mode_option_button.selected,
		borderless_check_button.button_pressed,
		int(custom_width_spin_box.value),
		int(custom_height_spin_box.value)
	)
	test_button.text = "Cancel Test"
	save_warning_label.text = "Test Active, will revert in:"
	testing_active = true
	test_change_timer.start(test_time)


func test_mass_disable(disabled_parameter: bool) -> void:
	get_tree().call_group("testing_lock", "set_disabled", disabled_parameter)
	get_tree().call_group("testing_lock", "set_editable", !disabled_parameter)


func fullscreen_resolution_lock(lock_parameter: bool) -> void:
	get_tree().call_group("fullscreen_lock", "set_disabled", lock_parameter)
	get_tree().call_group("fullscreen_lock", "set_editable", !lock_parameter)


func test_changes_end() -> void:
	if not testing_active:
		return
	test_mass_disable(false)
	disable_main_settings_tab_container_all_tabs(false)
	MainSettings.set_window(
		MainSettings.current_screen,
		MainSettings.monitor_mode,
		MainSettings.borderless,
		MainSettings.window_width,
		MainSettings.window_height,
	)
	test_button.text = "Test Changes"
	save_warning_label.text = "Changes not saved!"
	testing_active = false
	if not test_change_timer.is_stopped():
		test_change_timer.stop()
	test_change_timer_label.text = ""
	toggle_custom_resolution_container()
	toggle_display_preference_option_button()
	toggle_borderless_button()
	toggle_changed_settings_section()


func save_display_settings() -> void:
	settings.window_width = custom_width_spin_box.value
	settings.window_height = custom_height_spin_box.value
	settings.monitor_mode = display_mode_option_button.selected
	settings.current_monitor = display_preference_option_button.selected
	settings.borderless = borderless_check_button.button_pressed
	MainSettings.save_settings_main()
	MainSettings.load_display_settings()
	apply_display_settings_to_menu()


func window_resized() -> void:
	if ignore_window_resize:
		prints("Window resized signal IGNORED")
		return
	var resized_window_size: Vector2i = DisplayServer.window_get_size(MainSettings.current_screen)
	prints("Window resized function activated")
	var resized_window_width: int = resized_window_size.x
	var resized_window_height: int = resized_window_size.y
	apply_both_resolutions(resized_window_width, resized_window_height)


func disable_main_settings_tab_container_all_tabs(disabled_parameter:bool) -> void:
	for tab_iteration in main_settings_tab_container.get_tab_count():
		main_settings_tab_container.set_tab_disabled(tab_iteration, disabled_parameter)


func toggle_accept_button() -> void:
	match main_settings_tab_container.current_tab:
		0:
			accept_button.disabled = !changed_settings_check()
		1:
			accept_button.disabled = !theme_changed_settings_check()
		_:
			printerr("Accept button error: Tab not found. ",
				main_settings_tab_container.current_tab
			)

func initialize_theme() -> void:
	apply_theme_settings_to_menu()
	theme_test_change_timer_label.text = ""
	MainSettings.set_themes()


func apply_theme_settings_to_menu() -> void:
	theme_title_size_spin_box.value = MainSettings.theme_title_size
	theme_sub_title_size_spin_box.value = MainSettings.theme_sub_title_size
	theme_large_size_spin_box.value = MainSettings.theme_large_size
	theme_medium_size_spin_box.value = MainSettings.theme_medium_size
	theme_small_size_spin_box.value = MainSettings.theme_small_size
	apply_theme_color_palette_to_menu()


func apply_theme_color_palette_to_menu() -> void:
	MainSettings.theme_current_color_palette = MainSettings.theme_loaded_color_palette
	color_palette_menu_button.text = "Current Color Palette:\n" + MainSettings.theme_current_color_palette.capitalize()
	theme_background_color_picker_button.color = MainSettings.theme_background_color
	theme_border_line_color_picker_button.color = MainSettings.theme_border_line_color
	theme_font_color_picker_button.color = MainSettings.theme_font_color
	theme_outline_color_picker_button.color = MainSettings.theme_outlines_color
	theme_primary_color_picker_button.color = MainSettings.theme_primary_color
	theme_secondary_color_picker_button.color = MainSettings.theme_secondary_color
	theme_tertiary_color_picker_button.color = MainSettings.theme_tertiary_color
	theme_quaternary_color_picker_button.color = MainSettings.theme_quaternary_color
	theme_quinary_color_picker_button.color = MainSettings.theme_quinary_color
	theme_button_default_color_picker_button.color = MainSettings.theme_button_default_color
	theme_button_disabled_color_picker_button.color = MainSettings.theme_button_disabled_color
	theme_button_focus_color_picker_button.color = MainSettings.theme_button_focus_color
	theme_button_pressed_color_picker_button.color = MainSettings.theme_button_pressed_color
	theme_button_hover_color_picker_button.color = MainSettings.theme_button_hover_color
	theme_transparency_default_color_picker_button.color = MainSettings.theme_transparency_default_color
	theme_transparency_warning_color_picker_button.color = MainSettings.theme_transparency_warning_color


func theme_toggle_changed_settings_section() -> void:
	if theme_changed_settings_check():
		theme_disable_changed_settings_section(false)
		return
	theme_disable_changed_settings_section(true)


func theme_disable_changed_settings_section(disabled_parameter: bool) -> void:
	theme_test_h_separator.visible = !disabled_parameter
	theme_test_buttons_h_box_container.visible = !disabled_parameter
	toggle_accept_button()


func theme_changed_settings_check() -> bool:
	if MainSettings.theme_title_size != theme_title_size_spin_box.value:
		return true
	if MainSettings.theme_sub_title_size != theme_sub_title_size_spin_box.value:
		return true
	if MainSettings.theme_large_size != theme_large_size_spin_box.value:
		return true
	if MainSettings.theme_medium_size != theme_medium_size_spin_box.value:
		return true
	if MainSettings.theme_small_size != theme_small_size_spin_box.value:
		return true
	if MainSettings.theme_font_color != theme_font_color_picker_button.color:
		return true
	if MainSettings.theme_outlines_color != theme_outline_color_picker_button.color:
		return true
	if MainSettings.theme_background_color != theme_background_color_picker_button.color:
		return true
	if MainSettings.theme_border_line_color != theme_border_line_color_picker_button.color:
		return true
	if MainSettings.theme_primary_color != theme_primary_color_picker_button.color:
		return true
	if MainSettings.theme_secondary_color != theme_secondary_color_picker_button.color:
		return true
	if MainSettings.theme_tertiary_color != theme_tertiary_color_picker_button.color:
		return true
	if MainSettings.theme_quaternary_color != theme_quaternary_color_picker_button.color:
		return true
	if MainSettings.theme_quinary_color != theme_quinary_color_picker_button.color:
		return true
	if MainSettings.theme_button_default_color != theme_button_default_color_picker_button.color:
		return true
	if MainSettings.theme_button_disabled_color != theme_button_disabled_color_picker_button.color:
		return true
	if MainSettings.theme_button_focus_color != theme_button_focus_color_picker_button.color:
		return true
	if MainSettings.theme_button_pressed_color != theme_button_pressed_color_picker_button.color:
		return true
	if MainSettings.theme_button_hover_color != theme_button_hover_color_picker_button.color:
		return true
	if MainSettings.theme_transparency_default_color != theme_transparency_default_color_picker_button.color:
		return true
	if MainSettings.theme_transparency_warning_color != theme_transparency_warning_color_picker_button.color:
		return true
	if MainSettings.theme_font_color != theme_font_color_picker_button.color:
		return true
	if MainSettings.theme_outlines_color != theme_outline_color_picker_button.color:
		return true
	if MainSettings.theme_border_line_color != theme_border_line_color_picker_button.color:
		return true
	if MainSettings.theme_current_color_palette != MainSettings.theme_loaded_color_palette:
		return true
	if MainSettings.theme_palette_reset_needs_saving:
		return true
	return false


func theme_test_changes_start() -> void:
	theme_test_mass_disable(true)
	disable_main_settings_tab_container_all_tabs(true)
	test_themes()
	theme_test_button.text = "Cancel Test"
	theme_save_warning_label.text = "Test Active, will revert in:"
	testing_active = true
	theme_test_change_timer.start(test_time)


func theme_test_mass_disable(disabled_parameter: bool) -> void:
	get_tree().call_group("theme_testing_lock", "set_disabled", disabled_parameter)
	get_tree().call_group("theme_testing_lock", "set_editable", !disabled_parameter)


func theme_test_changes_end() -> void:
	if not testing_active:
		return
	theme_test_mass_disable(false)
	disable_main_settings_tab_container_all_tabs(false)
	MainSettings.set_themes()
	theme_test_button.text = "Test Changes"
	theme_save_warning_label.text = "Changes not saved!"
	testing_active = false
	if not theme_test_change_timer.is_stopped():
		theme_test_change_timer.stop()
	theme_test_change_timer_label.text = ""
	theme_select_current_palette_button()
	theme_toggle_changed_settings_section()


func save_theme_settings() -> void:
	settings.theme_title_size = theme_title_size_spin_box.value
	settings.theme_sub_title_size = theme_sub_title_size_spin_box.value
	settings.theme_large_size = theme_large_size_spin_box.value
	settings.theme_medium_size = theme_medium_size_spin_box.value
	settings.theme_small_size = theme_small_size_spin_box.value
	settings.theme_current_color_palette = MainSettings.theme_current_color_palette
	var color_profile = settings.theme_color_palettes[MainSettings.theme_current_color_palette]
	color_profile.theme_font_color = theme_font_color_picker_button.color.to_html()
	color_profile.theme_outlines_color = theme_outline_color_picker_button.color.to_html()
	color_profile.theme_background_color = theme_background_color_picker_button.color.to_html()
	color_profile.theme_border_line_color = theme_border_line_color_picker_button.color.to_html()
	color_profile.theme_primary_color = theme_primary_color_picker_button.color.to_html()
	color_profile.theme_secondary_color = theme_secondary_color_picker_button.color.to_html()
	color_profile.theme_tertiary_color = theme_tertiary_color_picker_button.color.to_html()
	color_profile.theme_quaternary_color = theme_quaternary_color_picker_button.color.to_html()
	color_profile.theme_quinary_color = theme_quinary_color_picker_button.color.to_html()
	color_profile.theme_button_default_color = theme_button_default_color_picker_button.color.to_html()
	color_profile.theme_button_disabled_color = theme_button_disabled_color_picker_button.color.to_html()
	color_profile.theme_button_focus_color = theme_button_focus_color_picker_button.color.to_html()
	color_profile.theme_button_pressed_color = theme_button_pressed_color_picker_button.color.to_html()
	color_profile.theme_button_hover_color = theme_button_hover_color_picker_button.color.to_html()
	color_profile.theme_transparency_default_color = theme_transparency_default_color_picker_button.color.to_html()
	color_profile.theme_transparency_warning_color = theme_transparency_warning_color_picker_button.color.to_html()
	MainSettings.theme_palette_reset_needs_saving = false
	MainSettings.save_settings_main()
	MainSettings.load_theme_settings()
	apply_theme_settings_to_menu()


func test_themes() -> void:
	test_themes_all_font_sizes()
	test_themes_all_colors()


func test_themes_all_font_sizes() -> void:
	var test_font_small := int(theme_small_size_spin_box.value)
	var test_font_medium := int(theme_medium_size_spin_box.value)
	var test_font_large := int(theme_large_size_spin_box.value)
	var test_font_sub_title := int(theme_sub_title_size_spin_box.value)
	var test_font_title := int(theme_title_size_spin_box.value)
	MainSettings.set_themes_small_font(test_font_small)
	MainSettings.set_themes_medium_font(test_font_medium)
	MainSettings.set_themes_large_font(test_font_large)
	MainSettings.set_themes_sub_title_font(test_font_sub_title)
	MainSettings.set_themes_title_font(test_font_title)


func test_themes_all_colors() -> void:
	MainSettings.set_themes_background_color(theme_background_color_picker_button.color)
	MainSettings.set_themes_primary_color(theme_primary_color_picker_button.color)
	MainSettings.set_themes_secondary_color(theme_secondary_color_picker_button.color)
	MainSettings.set_themes_tertiary_color(theme_tertiary_color_picker_button.color)
	MainSettings.set_themes_quaternary_color(theme_quaternary_color_picker_button.color)
	MainSettings.set_themes_quinary_color(theme_quinary_color_picker_button.color)
	MainSettings.set_themes_border_line_color(theme_border_line_color_picker_button.color)
	MainSettings.set_themes_font_color(theme_font_color_picker_button.color)
	MainSettings.set_themes_outline_color(theme_outline_color_picker_button.color)
	MainSettings.set_themes_button_default_color(theme_button_default_color_picker_button.color)
	MainSettings.set_themes_button_disabled_color(theme_button_disabled_color_picker_button.color)
	MainSettings.set_themes_button_focus_color(theme_button_focus_color_picker_button.color)
	MainSettings.set_themes_button_hover_color(theme_button_hover_color_picker_button.color)
	MainSettings.set_themes_button_pressed_color(theme_button_pressed_color_picker_button.color)
	MainSettings.set_themes_transparency_default_color(theme_transparency_default_color_picker_button.color)
	MainSettings.set_themes_transparency_warning_color(theme_transparency_warning_color_picker_button.color)


func accept_button_display_settings() -> void:
	if not changed_settings_check():
		prints("No changes in Display Settings, skipping save.")
		return
	if testing_active:
		test_changes_end()
		prints("End test: Accepted")
	save_display_settings()
	toggle_changed_settings_section()
	MainSettings.set_window(
		MainSettings.current_screen,
		MainSettings.monitor_mode,
		MainSettings.borderless,
		MainSettings.window_width,
		MainSettings.window_height,
	)


func accept_button_theme_settings() -> void:
	if not theme_changed_settings_check():
		prints("No changes in Theme Settings, skipping save.")
		return
	if testing_active:
		theme_test_changes_end()
		prints("End test: Accepted")
	save_theme_settings()
	MainSettings.set_themes()
	SignalBus._on_theme_settings_color_palette_updated.emit()
	theme_toggle_changed_settings_section()
	theme_select_current_palette_button()


func theme_select_current_palette_button() -> void:
	var palette_button_list: Array = COLOR_PALETTE_LABEL_BUTTON_GROUP.get_buttons()
	if palette_button_list.size() == 0:
		return
	prints("Attempting to select palette button:", MainSettings.theme_current_color_palette)
	for button_iteration in palette_button_list:
		var button_text =  button_iteration.text.to_lower()
		if button_text == MainSettings.theme_current_color_palette:
			button_iteration.set_pressed_no_signal(true)
			color_palette_menu_button.text = "Current Color Palette:\n" + button_iteration.text.capitalize()
			continue
		button_iteration.set_pressed_no_signal(false)
	theme_custom_palette_check()


func theme_palette_button_pressed(button_pressed: Button) -> void:
	MainSettings.theme_current_color_palette = button_pressed.text.to_lower()
	color_palette_menu_button.text = "Current Color Palette:\n" + button_pressed.text
	theme_load_palette_to_menu(MainSettings.theme_current_color_palette)
	theme_toggle_changed_settings_section()


func theme_load_palette_to_menu(palette_parameter) -> void:
	var loaded_palette = settings.theme_color_palettes[palette_parameter]
	theme_background_color_picker_button.color = Color(loaded_palette.theme_background_color)
	theme_primary_color_picker_button.color = Color(loaded_palette.theme_primary_color)
	theme_secondary_color_picker_button.color = Color(loaded_palette.theme_secondary_color)
	theme_tertiary_color_picker_button.color = Color(loaded_palette.theme_tertiary_color)
	theme_quaternary_color_picker_button.color = Color(loaded_palette.theme_quaternary_color)
	theme_quinary_color_picker_button.color = Color(loaded_palette.theme_quinary_color)
	theme_border_line_color_picker_button.color = Color(loaded_palette.theme_border_line_color)
	theme_font_color_picker_button.color = Color(loaded_palette.theme_font_color)
	theme_outline_color_picker_button.color = Color(loaded_palette.theme_outlines_color)
	theme_button_default_color_picker_button.color = Color(loaded_palette.theme_button_default_color)
	theme_button_disabled_color_picker_button.color = Color(loaded_palette.theme_button_disabled_color)
	theme_button_focus_color_picker_button.color = Color(loaded_palette.theme_button_focus_color)
	theme_button_hover_color_picker_button.color = Color(loaded_palette.theme_button_hover_color)
	theme_button_pressed_color_picker_button.color = Color(loaded_palette.theme_button_pressed_color)
	theme_transparency_default_color_picker_button.color = Color(loaded_palette.theme_transparency_default_color)
	theme_transparency_warning_color_picker_button.color = Color(loaded_palette.theme_transparency_warning_color)


func theme_custom_palette_check() -> bool:
	if MainSettings.theme_current_color_palette.ends_with("custom"):
		return true
	return false


func theme_preset_palette_swaps_to_custom_when_edited(_discarded_parameter) -> void:
	if theme_custom_palette_check():
		return
	prints("Changing palette from preset to custom!")
	MainSettings.theme_current_color_palette += " custom"
	theme_select_current_palette_button()
	theme_load_palette_to_menu(MainSettings.theme_current_color_palette)
	theme_toggle_changed_settings_section()


func theme_reset_palette(palette_parameter: String) -> void:
	var preset_palette = palette_parameter.left(-7)
	prints("Reseting palette:", palette_parameter, "to", preset_palette)
	settings.theme_color_palettes[palette_parameter] = settings.theme_color_palettes[preset_palette]
	SignalBus._on_theme_settings_color_palette_updated.emit()
	if palette_parameter == MainSettings.theme_current_color_palette:
		theme_load_palette_to_menu(palette_parameter)
	MainSettings.theme_palette_reset_needs_saving = true
	theme_toggle_changed_settings_section()


func _on_reset_button_pressed() -> void:
	if reset_button.text == "Reset to Defaults":
		DataGlobal.button_based_message(reset_button, "CLICK TO CONFIRM RESET")
		return
	settings.reset_settings_display()
	reset_button.text = "Settings Reset!"
	MainSettings.save_settings_main()
	MainSettings.load_display_settings()
	apply_display_settings_to_menu()
	MainSettings.set_window(
		MainSettings.current_screen,
		MainSettings.monitor_mode,
		MainSettings.borderless,
		MainSettings.window_width,
		MainSettings.window_height,
	)
	toggle_changed_settings_section()


func _on_display_mode_option_button_item_selected(index: int) -> void:
	if index == 1:
		custom_width_spin_box.value = MainSettings.screen_native_width
		custom_height_spin_box.value = MainSettings.screen_native_height
		apply_both_resolutions(MainSettings.screen_native_width, MainSettings.screen_native_height)
	toggle_changed_settings_section()
	apply_borderless(MainSettings.borderless)


func _on_resolution_width_option_button_item_selected(index: int) -> void:
	if MainSettings.resolution_list.size() != index:
		custom_width_spin_box.value = MainSettings.resolution_list[index]
	toggle_custom_resolution_container()
	toggle_changed_settings_section()


func _on_resolution_height_option_button_item_selected(index: int) -> void:
	if MainSettings.resolution_list.size() != index:
		custom_height_spin_box.value = MainSettings.resolution_list[index]
	toggle_custom_resolution_container()
	toggle_changed_settings_section()


func _on_custom_width_spin_box_value_changed(_value: float) -> void:
	toggle_changed_settings_section()

func _on_custom_height_spin_box_value_changed(_value: float) -> void:
	toggle_changed_settings_section()


func _on_display_preference_option_button_item_selected(_index: int) -> void:
	toggle_changed_settings_section()


func _on_borderless_check_button_toggled(button_pressed: bool) -> void:
	toggle_changed_settings_section()
	prints("Borderless toggle button:", button_pressed)
	if button_pressed:
		borderless_status_label.text = "On"
		return
	borderless_status_label.text = "Off"


func _on_test_button_pressed() -> void:
	if not testing_active:
		test_changes_start()
		prints("Start test press")
		return
	if testing_active:
		test_changes_end()
		test_change_timer.stop()
		prints("End test press")


func _on_accept_button_pressed() -> void:
	prints("accepted button sees:", main_settings_tab_container.current_tab)
	match main_settings_tab_container.current_tab:
		0:
			accept_button_display_settings()
		1:
			accept_button_theme_settings()
		_:
			prints("Accept Button Error: Tab not found:", main_settings_tab_container.current_tab)


func _on_cancel_changes_button_pressed() -> void:
	match main_settings_tab_container.current_tab:
		0:
			apply_display_settings_to_menu()
			MainSettings.set_window(
				MainSettings.current_screen,
				MainSettings.monitor_mode,
				MainSettings.borderless,
				MainSettings.window_width,
				MainSettings.window_height,
			)
			toggle_changed_settings_section()
		1:
			apply_theme_settings_to_menu()
			MainSettings.set_themes()
			theme_toggle_changed_settings_section()
			theme_select_current_palette_button()
		_:
			prints("Cancel Button Error: Tab not found:", main_settings_tab_container.current_tab)


func _on_back_button_pressed() -> void:
	SignalBus._on_main_settings_back_button_pressed.emit()


func _on_theme_test_button_pressed() -> void:
	if not testing_active:
		theme_test_changes_start()
		prints("Start test press")
		return
	if testing_active:
		theme_test_changes_end()
		theme_test_change_timer.stop()
		prints("End test press")


func _on_theme_cancel_changes_button_pressed() -> void:
	apply_theme_settings_to_menu()
	theme_select_current_palette_button()
	theme_toggle_changed_settings_section()


func _on_theme_reset_button_pressed() -> void:
	if theme_reset_button.text == "Reset to Defaults":
		DataGlobal.button_based_message(theme_reset_button, "CLICK TO CONFIRM RESET")
		return
	settings.reset_settings_theme()
	theme_reset_button.text = "Settings Reset!"
	MainSettings.save_settings_main()
	MainSettings.load_theme_settings()
	apply_theme_settings_to_menu()
	MainSettings.set_themes()
	theme_toggle_changed_settings_section()


func _on_main_settings_tab_container_tab_changed(tab: int) -> void:
	current_setting_tab = tab
	prints("Current settings tab:", tab)


func _on_theme_title_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_sub_title_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_large_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_medium_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_small_size_spin_box_value_changed(_value: float) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_font_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_outline_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_main_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_secondary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_tertiary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_quaternary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_quinary_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_default_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_disabled_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_focus_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_pressed_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_button_hover_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_transparency_default_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()


func _on_theme_transparency_warning_color_picker_button_color_changed(_color: Color) -> void:
	theme_toggle_changed_settings_section()
