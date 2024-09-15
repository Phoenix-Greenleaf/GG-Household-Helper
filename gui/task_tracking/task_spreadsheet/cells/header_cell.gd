extends PanelContainer

@onready var label: Label = %Label



func set_header_title(title_param: String) -> void:
	label.text = title_param
