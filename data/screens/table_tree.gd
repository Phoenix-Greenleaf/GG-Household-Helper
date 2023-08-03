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

var month_header: Array
var week_header: Array
var day_header: Array

var month_keys: Array = DataGlobal.Month.keys()

var year_task_data: YearTaskData

func _ready() -> void:
	create_new_blank_tree()

	
	





func create_new_blank_tree() -> void:
#	var month_label: String = month_keys[month]
#		month_label = month_label.capitalize()
	year_task_data = YearTaskData.new()
	var year_item: TreeItem = create_item()
	year_item.set_cell_mode(0,TreeItem.CELL_MODE_CHECK)
	year_item.set_checked(0,true)
	
	
	
	
	
	



# the old test blank
func create_new_test_tree() -> void:
	var item_one: TreeItem = create_item()
	item_one.set_text(0, "Item One")
	item_one.set_text(1, "One One")
	
	var item_two: TreeItem = create_item(item_one)
	item_two.set_text(0, "Item Two")
	item_two.set_text(1, "Two Two")
	
	var item_three: TreeItem = create_item()
	item_three.set_text(2, "Threesies but also testing for spppppaaaaccccceee")
	
	set_table_headers()





func set_table_headers() -> void:
	var number_of_columns: int = column_header.size()
	print(number_of_columns)
	self.columns = number_of_columns
	var column: int = 0
	for header in column_header:
		set_column_title(column, header)
		column += 1


func delete_current_tree() -> void:
	clear()


func _on_cell_selected() -> void:
	var selected_cell: TreeItem = get_selected()
	var selected_cell_column: int = get_selected_column()
	print(selected_cell.get_text(selected_cell_column))
	
	
func _on_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var selected_column = get_column_title(column)
	print(selected_column)
