extends Button

@onready var saved_status: DataGlobal.Checkbox = DataGlobal.Checkbox.ACTIVE


func _ready() -> void:
	SignalBus.update_checkbox_button.connect(toggle_to_focused_cell)


func toggle_to_focused_cell() -> void:
	if DataGlobal.current_checkbox_state != saved_status:
		self.set_pressed_no_signal(false)
		return
	self.set_pressed_no_signal(true)
