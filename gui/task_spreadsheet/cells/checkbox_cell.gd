extends VBoxContainer

#debating on making the "Current checkbox button" into a checkbox_cell
#to reduce repeat code. Separate may have a benifit but we shall see. 



func update_checkbox_colors(update_state: DataGlobal.Checkbox, update_color: Color) -> void:
	var white := Color(1, 1, 1)
	var black := Color(0, 0, 0)
	var top := $TopColorRect
	var bottom := $BottomColorRect
	match update_state:
		DataGlobal.Checkbox.ACTIVE:
			top.set_color(white)
			bottom.set_color(white)
		DataGlobal.Checkbox.IN_PROGRESS:
			top.set_color(white)
			bottom.set_color(update_color)
		DataGlobal.Checkbox.COMPLETED:
			top.set_color(update_color)
			bottom.set_color(update_color)
		DataGlobal.Checkbox.EXPIRED:
			top.set_color(black)
			bottom.set_color(black)
		_:
			print("Checkbox_cell update color match failure!")
