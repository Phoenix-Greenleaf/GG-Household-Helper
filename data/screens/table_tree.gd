extends Tree


func _ready() -> void:
	create_new_blank_tree()
	
	





func create_new_blank_tree() -> void:
	var item_one = create_item()
	item_one.set_text(0, "Item One")
	item_one.set_text(1, "One One")
	
	var item_two = create_item(item_one)
	item_two.set_text(0, "Item Two")
	item_two.set_text(1, "Two Two")
	
	var item_three = create_item()
	item_three.set_text(2, "Threesies")
	
	set_column_title(0, "Test 1")
	set_column_title(1, "Test 2")
	set_column_title(2, "Test 3")


func delete_current_tree() -> void:
	clear()


func _on_cell_selected() -> void:
	var selected_cell = get_selected()
	var selected_cell_column = get_selected_column()
	print(selected_cell.get_text(selected_cell_column))
	
	
func _on_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var selected_column = get_column_title(column)
	print(selected_column)
