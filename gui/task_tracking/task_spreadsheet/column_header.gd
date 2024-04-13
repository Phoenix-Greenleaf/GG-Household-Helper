extends PanelContainer


@onready var options_h_box_container: HBoxContainer = %OptionsHBoxContainer
@onready var sorting_button: Button = %SortingButton
@onready var order_spin_box: SpinBox = %OrderSpinBox
@onready var header_button: Button = %HeaderButton

var sorting_mode_index: int


var sorting_modes = [
	"None",
	"Ascend",
	"Descend",
]



func _ready() -> void:
	header_options_visible(false)
	initialize_sorting_modes()


func initialize_sorting_modes() -> void:
	sorting_mode_index = 0
	set_header_text()


func set_header_text() -> void:
	sorting_button.text = sorting_modes[sorting_mode_index]


func set_sorting_mode(mode_index_parameter: int) -> void:
	sorting_mode_index = mode_index_parameter
	set_header_text()


func header_options_visible(visible_parameter: bool) -> void:
	options_h_box_container.visible = visible_parameter


func _on_header_button_toggled(toggled_on: bool) -> void:
	header_options_visible(toggled_on)


func _on_sorting_button_pressed() -> void:
	sorting_mode_index += 1
	if sorting_mode_index == sorting_modes.size():
		initialize_sorting_modes()
	else:
		set_header_text()
	SignalBus._on_task_editor_header_sorting_button_pressed.emit(sorting_mode_index)
