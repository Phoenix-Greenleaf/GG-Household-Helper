extends ScrollContainer


@onready var interal_range: Range = get_h_scroll_bar()


func _ready() -> void:
	interal_range.value_changed.connect(send_scroll_signal)


func send_scroll_signal(value_param: float) -> void:
	TaskSignalBus._on_task_grid_scrolled.emit(value_param)
