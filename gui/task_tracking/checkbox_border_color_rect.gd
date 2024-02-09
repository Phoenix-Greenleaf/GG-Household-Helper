extends ColorRect

var clear_color := Color(0, 0, 0, 0)
var target_square_size: float = 40.0

var current_x: float
var current_y: float
var current_width: float = 6.0
var current_start: float


@export var border_color : Color


func _ready() -> void:
	self.color = clear_color
	var current_square_size = target_square_size - current_width
	current_x = current_square_size
	current_y = current_square_size
	current_start = current_width / 2


func _draw() -> void:
	if not border_color:
		prints("No borders needed", self.name)
		return
	draw_rect(Rect2(current_start, current_start, current_x, current_y), border_color, false, current_width)


func update_border(update_color: Color = clear_color) -> void:
	border_color = update_color
	queue_redraw()


func resize_border(x: float, y: float) -> void:
	if current_x + current_width == x and current_y + current_width == y:
		return
	current_x = x - current_width
	current_y = y - current_width


