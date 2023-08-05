extends Tree
# motion on the floor to classify as TreeTabler


var column_header: Array = []
var default_column_header: Array = [
	"Default_Task",
	"Default_Section",
	"Default_Group",
	"Default_Task Description",
	"Default_Responsible Parties",
	"Default_Time of Day",
	"Default_Priority",
	"Default_Location",
	"Default_Days in Cycle",
	"Default_Last Completed",
	"Default_Days when skipping?",
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

var number_of_columns: int 
var number_of_rows: int

var section_1: Array
var section_2: Array
var section_3: Array

var sections_array: Array = [[section_1],[section_2],[section_3]]
var groups: Array
var tree_address: Array

enum {SECTION_COLUMN = 1}



func _ready() -> void:
	create_new_blank_tree()


func create_new_blank_tree():
	number_of_rows = DataGlobal.test_data_array.size()
	prints("Number of rows:", number_of_rows)
	DataGlobal.print_test_array()

	dumb_to_smart_array(DataGlobal.test_data_array)
	set_table_headers()
	
	var root: TreeItem = create_item()
	var tree_section_1: TreeItem = root.create_child()
	var tree_section_2: TreeItem = root.create_child()
	var tree_section_3: TreeItem = root.create_child()
	tree_section_1.set_text(0, "Sect 1")
	tree_section_2.set_text(0, "Sect 2")
	tree_section_3.set_text(0, "Sect 3")
	
	for row_loop in section_1.size():
		var child: TreeItem = tree_section_1.create_child()
		for column_loop in section_1[row_loop].size():
			child.set_text(column_loop, section_1[row_loop][column_loop])
#			prints("S1 Loop: Row", row_loop, ", Col", column_loop, ", Item", section_1[row_loop][column_loop])
	
	for row_loop in section_2.size():
		var child: TreeItem = tree_section_2.create_child()
		for column_loop in section_2[row_loop].size():
			child.set_text(column_loop, section_2[row_loop][column_loop])
		
	for row_loop in section_3.size():
		var child: TreeItem = tree_section_3.create_child()
		for column_loop in section_3[row_loop].size():
			child.set_text(column_loop, section_3[row_loop][column_loop])



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


func set_table_headers() -> void:
	number_of_columns = column_header.size()
	prints("Columns:", number_of_columns)
	self.columns = number_of_columns
	var column: int = 0
	for header in column_header:
		set_column_title(column, header)
		column += 1


func delete_current_tree() -> void:
	clear()


func print_human_tree_address():
	var human_tree_address: Array = []
	for computer_address in tree_address:
		human_tree_address.append(computer_address.get_text(0))
	prints("Magic array:", human_tree_address)


func dumb_to_smart_array(target: Array):
	column_header = target[0] #headers isolated
	
	for item in target.size(): #section separation
		if item != 0:  #skip the header row
			print(target[item][SECTION_COLUMN])
			match target[item][SECTION_COLUMN]:
				"Section 1":
					section_1.append(target[item])
				"Section 2":
					section_2.append(target[item])
				"Section 3":
					section_3.append(target[item])
				_:
					print("You didn't say the magic word")

func smart_to_dumb_array():
	pass


##signal town

func _on_cell_selected() -> void:
	var selected_cell: TreeItem = get_selected()
	var selected_cell_column: int = get_selected_column()
	print(selected_cell.get_text(selected_cell_column))
	
	
func _on_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var selected_column = get_column_title(column)
	print(selected_column)

