extends PanelContainer


@onready var options_h_box_container: HBoxContainer = %OptionsHBoxContainer
@onready var sorting_button: Button = %SortingButton
@onready var order_spin_box: SpinBox = %OrderSpinBox
@onready var header_button: Button = %HeaderButton
@onready var sorting_panel_container: PanelContainer = %SortingPanelContainer
@onready var order_panel_container: PanelContainer = %OrderPanelContainer

var column_pair: String
var sorting_mode_index: int
var sorting_modes = [
	"None",
	"Ascend",
	"Descend",
]



func _ready() -> void:
	header_options_visible(false)
	initialize_sorting_modes()
	connect_signals()


func initialize_sorting_modes() -> void:
	sorting_mode_index = 0
	set_sorting_button_text()


func set_sorting_button_text() -> void:
	sorting_button.text = sorting_modes[sorting_mode_index]


func connect_signals() -> void:
	SignalBus._on_task_editor_column_visibility_toggled.connect(toggle_column_visibility)


func set_sorting_mode(mode_index_parameter: int) -> void:
	sorting_mode_index = mode_index_parameter
	set_sorting_button_text()


func set_order_spin_box_value(value_parameter: int) -> void:
	order_spin_box.value = value_parameter


func header_options_visible(visible_parameter: bool) -> void:
	options_h_box_container.visible = visible_parameter


func sorting_enabled(sorting_parameter: bool = true) -> void:
	sorting_panel_container.visible = sorting_parameter


func ordering_enabled(ordering_parameter: bool = true) -> void:
	order_panel_container.visible = ordering_parameter


func toggle_column_visibility(column_parameter: String, visible_parameter: bool) -> void:
	get_tree().call_group(column_parameter, "set_visible", visible_parameter)


func _on_header_button_toggled(toggled_on: bool) -> void:
	header_options_visible(toggled_on)


func _on_sorting_button_pressed() -> void:
	sorting_mode_index += 1
	if sorting_mode_index == sorting_modes.size():
		initialize_sorting_modes()
	else:
		set_sorting_button_text()
	SignalBus._on_task_editor_header_sorting_button_pressed.emit(sorting_mode_index)


func _on_order_spin_box_value_changed(value: float) -> void:
	SignalBus._on_task_editor_header_order_spin_box_value_changed.emit(value)


func _on_resized() -> void:
	prints("Resizing Header Cell:", name, "   Size:", size)
	SignalBus._on_task_editor_grid_column_resized.emit(column_pair)
