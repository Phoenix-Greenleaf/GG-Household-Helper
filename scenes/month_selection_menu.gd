extends MenuButton

#@export var task_editor: Control
@export var section_label: Control
@export var section_divider: Control

@onready var menu_popup := get_popup()

var stored_month: DataGlobal.Month


func _ready() -> void:
	connect_signals()
	update_month_selection_menu()
	check_section()


func connect_signals() -> void:
	TaskSignalBus._on_section_changed.connect(check_section)
	TaskSignalBus._on_month_changed.connect(update_month_selection_menu)
	menu_popup.id_pressed.connect(month_menu_button_actions)


func update_month_selection_menu() -> void:
	var current_month: DataGlobal.Month = TaskTrackingGlobal.current_toggled_month
	if current_month == DataGlobal.Month.ALL:
		return
	text = DataGlobal.month_strings[current_month]
	rotate_disabled_month_items()


func rotate_disabled_month_items() -> void:
	var item_index: int
	if stored_month:
		menu_popup.set_item_disabled(stored_month_index(), false)
	stored_month = TaskTrackingGlobal.current_toggled_month
	menu_popup.set_item_disabled(stored_month_index(), true)


func stored_month_index() -> int:
	return menu_popup.get_item_index(stored_month)


func month_menu_button_actions(pressed_id: int) -> void:
	TaskTrackingGlobal.current_toggled_month = pressed_id


func check_section() -> void:
	if TaskTrackingGlobal.current_toggled_section == DataGlobal.Section.MONTHLY:
		toggle_month_selection_visibility(false)
		return
	toggle_month_selection_visibility(true)


func toggle_month_selection_visibility(is_visible: bool) -> void:
	section_label.visible = is_visible
	section_divider.visible = is_visible
	visible = is_visible
