extends PanelContainer


@onready var options_h_box_container: HBoxContainer = %OptionsHBoxContainer
@onready var sorting_button: Button = %SortingButton
@onready var order_spin_box: SpinBox = %OrderSpinBox
@onready var header_button: Button = %HeaderButton


var sorting_modes = [
	"None",
	"Ascend",
	"Descend",
]



func _ready() -> void:
	header_options_visible(false)


func header_options_visible(visible_parameter: bool) -> void:
	options_h_box_container.visible = visible_parameter


func _on_header_button_toggled(toggled_on: bool) -> void:
	header_options_visible(toggled_on)
