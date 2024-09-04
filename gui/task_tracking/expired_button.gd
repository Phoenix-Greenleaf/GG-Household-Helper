extends Button

@onready var saved_status: TaskTrackingGlobal.Checkbox = TaskTrackingGlobal.Checkbox.EXPIRED


func _ready() -> void:
	TaskSignalBus._on_checkbox_selection_changed.connect(toggle_to_focused_cell)


func toggle_to_focused_cell() -> void:
	if TaskTrackingGlobal.current_checkbox_state != saved_status:
		self.set_pressed_no_signal(false)
		return
	self.set_pressed_no_signal(true)
