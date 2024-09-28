extends ScrollContainer

@onready var interal_range: Range = get_h_scroll_bar()



func _ready() -> void:
	TaskSignalBus._on_task_grid_scrolled.connect(follow_grid_scrolling)


func follow_grid_scrolling(value_param: float) -> void:
	interal_range.value = value_param
