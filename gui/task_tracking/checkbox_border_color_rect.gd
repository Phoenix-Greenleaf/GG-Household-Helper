extends ColorRect

var clear_color := Color(0, 0, 0, 0)
var current_x: int = 40
var current_y: int = 40
var current_width: int = 5


@export var border_color : Color


func _ready() -> void:
	self.color = clear_color
	


func _draw() -> void:
	if not border_color:
		prints("No borders needed", self.name)
		return
	draw_rect(Rect2(0, 0, current_x, current_y), border_color, false, current_width)


func update_border(update_color: Color = clear_color) -> void:
	border_color = update_color
	queue_redraw()
	prints("Border updated", self.name)

func resize_border(x: int, y: int) -> void:
	if current_x == x and current_y == y:
		prints("Border size happy")
		return
	current_x = x
	current_y = y
	prints("Border resized", self.name)


