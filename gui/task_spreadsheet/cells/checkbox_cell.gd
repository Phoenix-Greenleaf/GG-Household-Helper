extends VBoxContainer

#debating on making the "Current checkbox button" into a checkbox_cell
#to reduce repeat code. Separate may have a benifit but we shall see. 


@export var saved_position : int
@export var saved_task : TaskData
@export var saved_profile : Array
@export var saved_state : DataGlobal.Checkbox
@export var saved_color : Color

@onready var top := $TopColorRect
@onready var bottom := $BottomColorRect

var white := Color(1, 1, 1)
var black := Color(0, 0, 0)


func _ready() -> void:
	name = "CheckboxCell"


func update_checkbox() -> void:
	saved_color = saved_profile[1]
	match saved_state:
		DataGlobal.Checkbox.ACTIVE:
			top.set_color(white)
			bottom.set_color(white)
		DataGlobal.Checkbox.IN_PROGRESS:
			top.set_color(white)
			bottom.set_color(saved_color)
		DataGlobal.Checkbox.COMPLETED:
			top.set_color(saved_color)
			bottom.set_color(saved_color)
		DataGlobal.Checkbox.EXPIRED:
			top.set_color(black)
			bottom.set_color(black)
		_:
			print("Checkbox_cell update color match failure!")
