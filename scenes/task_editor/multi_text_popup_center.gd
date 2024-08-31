extends CenterContainer


@export var text_edit: TextEdit


func _ready() -> void:
	visible = false


func _on_cancel_multi_text_button_pressed() -> void:
	visible = false
	text_edit.clear()
