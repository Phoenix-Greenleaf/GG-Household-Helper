extends Button

@onready var saved_status: DataGlobal.Checkbox = DataGlobal.Checkbox.IN_PROGRESS


func _ready() -> void:
	SignalBus._on_task_editor_checkbox_selection_changed.connect(toggle_to_focused_cell)


func toggle_to_focused_cell() -> void:
	if DataGlobal.current_checkbox_state != saved_status:
		self.set_pressed_no_signal(false)
		return
	self.set_pressed_no_signal(true)
