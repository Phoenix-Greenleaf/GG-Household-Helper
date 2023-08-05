extends Tree


var column_header: Array = [
	"Task",
	"Section",
	"Group",
	"Task Description",
	"Responsible Parties",
	"Time of Day",
	"Priority",
	"Location",
	"Days in Cycle",
	"Last Completed",
	"Days when skipping?",
]

var Checkbox: Dictionary = DataGlobal.Checkbox
var Section: Dictionary = DataGlobal.Section
var Month: Dictionary = DataGlobal.Month
var TimeOfDay: Dictionary = DataGlobal.TimeOfDay
var Priority: Dictionary = DataGlobal.Priority





# arrays for the number of checkboxes
var month_header: Array
var week_header: Array
var day_header: Array

var month_keys: Array = Month.keys()

var active_color = Color(1, 1, 1)
var complete_color = Color(0, 1, 0)

var number_of_columns: int = column_header.size()
var number_of_rows: int

var sections: Dictionary
var groups: Dictionary
var subgroups: Dictionary
var tree_address: Array


func _ready() -> void:
	create_new_blank_tree()

	
	





func create_new_test_tree() -> void:
#	var month_label: String = month_keys[month]
#		month_label = month_label.capitalize()
#	year_task_data = YearTaskData.new()
#	var year_item: TreeItem = create_item()
#	year_item.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)
#	year_item.set_checked(0,true)
	set_table_headers()
	var root: TreeItem = create_item()
	prints("Root Parent is null:", root.get_parent())
	
	var group_1: TreeItem = root.create_child()
	group_1.set_text(0,"Group 1")

	
	var group_2: TreeItem = root.create_child()
	group_2.set_text(0,"Group 2")

	
	var group_3: TreeItem = root.create_child()
	group_3.set_text(0,"Group 3")

	
	var subgroup_1: TreeItem = group_1.create_child()
	subgroup_1.set_text(0,"SubGroup 1")
#	print(subgroup_1.get_parent().get_text(0))
	
	var subgroup_2: TreeItem = group_1.create_child()
	subgroup_2.set_text(0,"SubGroup 2")
#	print(subgroup_2.get_parent().get_text(0))
	
	get_all_tree_items()
	

	
#
#	var first_tree_item = root.get_first_child()
#	var tree_item_count: int = 1
#	var current_item_text: String = first_tree_item.get_text(0)
#	prints("First child:", current_item_text, "  Count:", tree_item_count)
#	while first_tree_item != null:
#		first_tree_item = first_tree_item.get_next()
#		if first_tree_item != null:
#			tree_item_count += 1
#			current_item_text = first_tree_item.get_text(0)
#		else:
#			current_item_text = "Get NULLd son"
#		prints("Next child:", current_item_text, "  Count:", tree_item_count)
#	prints("Tree Item Count:", tree_item_count)


func create_new_blank_tree():
	set_table_headers()
	number_of_rows = DataGlobal.test_data_array.size()
	prints("Number of rows:", number_of_rows)
	DataGlobal.print_test_array()
	var sectioning_test = ["Section 1", "Section 2", "Section 3"]
	
	var root: TreeItem = create_item()
	
	
	for row in number_of_rows:
		if row != 0:
			var child: TreeItem = root.create_child()
			var tree_row: int = 0
			for column in DataGlobal.test_data_array[row].size():
				child.set_text(column, DataGlobal.test_data_array[row][column])
				tree_row += 1
	
	pass












func get_all_tree_items(target: TreeItem = get_root(), level: int = 1):
	
	var child = target.get_children()
	var address_number = 0
	if child.is_empty():
		prints("End of the line-erino for:", target.get_text(0))
	else:
		for items in child:
			tree_address.append(items)
			prints("Level", level, "Added:", items.get_text(address_number))
			address_number += 1
			get_all_tree_items(items)
	
	
	
	
	
	
	
	
#	for column in number_of_columns:
#		root.get_next()
	



# the old test blank
#func create_new_test_tree() -> void:
#	var item_one: TreeItem = create_item()
#	item_one.set_text(0, "Item One")
#	item_one.set_text(1, "One One")
#
#	var item_two: TreeItem = create_item(item_one)
#	item_two.set_text(0, "Item Two")
#	item_two.set_text(1, "Two Two")
#
#	var item_three: TreeItem = create_item()
#	item_three.set_text(2, "Threesies but also testing for spppppaaaaccccceee")
#
#	set_table_headers()





func set_table_headers() -> void:
	prints("Columns:", number_of_columns)
	self.columns = number_of_columns
	var column: int = 0
	for header in column_header:
		set_column_title(column, header)
		column += 1


func delete_current_tree() -> void:
	clear()


#func get_all_children(node: Node, level: int = 0):
#	var _level: int = level # retains local level property
#	for N in node.get_children():
#		print(".".repeat(_level) + N.name)
#		if N.get_child_count() > 0:
#			get_all_children(N, _level + 1)

func print_human_tree_address():
	var human_tree_address: Array = []
	for computer_address in tree_address:
		human_tree_address.append(computer_address.get_text(0))
	prints("Magic array:", human_tree_address)











func _on_cell_selected() -> void:
	var selected_cell: TreeItem = get_selected()
	var selected_cell_column: int = get_selected_column()
	print(selected_cell.get_text(selected_cell_column))
	
	
func _on_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var selected_column = get_column_title(column)
	print(selected_column)

