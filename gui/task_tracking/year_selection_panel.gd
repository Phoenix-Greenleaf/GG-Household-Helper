extends PanelContainer

@onready var option_button: OptionButton = %OptionButton
@onready var spin_box: SpinBox = %SpinBox
@onready var accept_button: Button = %AcceptButton
@onready var cancel_button: Button = %CancelButton

@export var opening_button: Button
@export var node_for_position_sync: Control

var selected_year: int: set = set_selected_year
var positioning_node_width: int



func _ready() -> void:
	visible = false
	opening_button.pressed.connect(toggle_panel_visibility)
	TaskSignalBus._on_new_database_loaded.connect(populate_existing_years)
	if SqlManager.database_name == "":
		return
	populate_existing_years()


func _process(_delta: float) -> void:
	if visible and node_for_position_sync:
			sync_position()


func set_selected_year(value):
		selected_year = value
		toggle_accept_button()


func open_panel() -> void:
	update_menu_button_witdth()
	visible = true


func toggle_panel_visibility() -> void:
	if visible:
		visible = false
		return
	open_panel()


func toggle_accept_button() -> void:
	if not selected_year or selected_year == TaskTrackingGlobal.current_toggled_year:
		accept_button.disabled = true
		return
	if accept_button.disabled:
		accept_button.disabled = false


func populate_existing_years() -> void:
	if TaskTrackingGlobal.existing_years_index.is_empty():
		option_button.add_item("2000", 2000)
		return
	for unique_year in TaskTrackingGlobal.existing_years_index:
		option_button.add_item(unique_year, int(unique_year))


func year_accepted() -> void:
	TaskTrackingGlobal.current_toggled_year = selected_year
	reset_values()
	visible = false


func reset_values() -> void:
	spin_box.set_value_no_signal(2000)
	selected_year = 2000
	reset_option_button()


func reset_option_button() -> void:
	option_button.clear()
	option_button.add_item("Existing Years", 0)
	var item_index: int = option_button.get_item_index(0)
	option_button.select(item_index)


func sync_position() -> void:
	var offset_x: int = 0
	var offset_y: int = 0
	var menu_transform: Transform2D
	menu_transform = node_for_position_sync.get_global_transform_with_canvas()
	var menu_origin = menu_transform.origin
	var menu_position_x: int = menu_origin.x
	var menu_position_y: int = menu_origin.y
	var sync_x: int = offset_x + menu_position_x + positioning_node_width
	var sync_y: int = offset_y + menu_position_y
	var sync_vector := Vector2i(sync_x, sync_y)
	position = sync_vector


func update_menu_button_witdth() -> void:
	positioning_node_width = int(node_for_position_sync.size.x)


func _on_spin_box_value_changed(value: float) -> void:
	selected_year = value


func _on_option_button_item_selected(index: int) -> void:
	var selected_id: int = option_button.get_item_id(index)
	selected_year = selected_id


func _on_cancel_button_pressed() -> void:
	visible = false


func _on_accept_button_pressed() -> void:
	year_accepted()
