extends Tree



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



var current_toggled_section: int = DataGlobal.Section.YEARLY

# arrays for the number of checkboxes
var month_header: Array
var week_header: Array
var day_header: Array

var month_keys: Array = Month.keys()

var active_color = Color(1, 1, 1)
var complete_color = Color(0, 1, 0)

var number_of_columns: int 
var number_of_rows: int

var yearly_section: Array
var monthly_section: Array
var weekly_section: Array
var daily_section: Array

var yearly_groups: Array
var monthly_groups: Array
var weekly_groups: Array
var daily_groups: Array


var tree_address: Array # for get_all_tree_items / print_human_tree

enum {SECTION_COLUMN = 1, GROUP_COLUMN = 2}



func _ready() -> void:
	create_new_blank_tree()





func create_new_blank_tree(): #initializes on yearly, could be a setting
	number_of_rows = DataGlobal.test_data_array.size()
	prints("Number of rows:", number_of_rows)
#	DataGlobal.print_test_array()
	dumb_to_smart_array(DataGlobal.test_data_array)
	set_table_headers()
#	group_and_assign() #the previous version
	new_assign_by_group("Yearly")
	
	
func switch_sections(new_section: String):
	clear_current_tree()
	new_assign_by_group(new_section)




func new_assign_by_group(section_to_assign: String):
	var root_node: TreeItem = create_item()
	var tree_groups: Dictionary = {}
	match section_to_assign:
		"Yearly":
			create_group_roots(yearly_groups, tree_groups, root_node)
			create_tree_items(yearly_section, tree_groups)
		"Monthly":
			create_group_roots(monthly_groups, tree_groups, root_node)
			create_tree_items(monthly_section, tree_groups)
		"Weekly":
			create_group_roots(weekly_groups, tree_groups, root_node)
			create_tree_items(weekly_section, tree_groups)
		"Daily":
			create_group_roots(daily_groups, tree_groups, root_node)
			create_tree_items(daily_section, tree_groups)
		_:
			print("Assignment Error: No Section Match")
	

func create_group_roots(current_groups_section: Array, current_tree_groups: Dictionary, current_root: TreeItem):
	for current_root_group in current_groups_section:
		current_tree_groups[current_root_group] = current_root.create_child()
		current_tree_groups[current_root_group].set_text(0, current_root_group)


func create_tree_items(current_section: Array, current_tree_groups: Dictionary):
	for row_loop in current_section.size():
		var current_assignment_group = current_section[row_loop][GROUP_COLUMN]
		var child: TreeItem = current_tree_groups[current_assignment_group].create_child()
		for column_loop in current_section[row_loop].size():
			child.set_text(column_loop, current_section[row_loop][column_loop])


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
	var current_column: int = 0
	for header_string in column_header: #switch to default?
		set_column_title(current_column, header_string)
		current_column += 1


func clear_current_tree() -> void:
	# save some details to for restoring scroll position, etc. upon return
	clear()


func print_human_tree_address():
	var human_tree_address: Array = []
	for computer_address in tree_address:
		human_tree_address.append(computer_address.get_text(0))
	prints("Magic array:", human_tree_address)


func dumb_to_smart_array(target: Array):
	column_header = target[0] #headers isolated
	
	for task_row in target.size(): #section separation
		if task_row != 0:  #skip the header row
			print(target[task_row][SECTION_COLUMN])
			match target[task_row][SECTION_COLUMN]:
				"Yearly":
					yearly_section.append(target[task_row])
					if not yearly_groups.has(target[task_row][GROUP_COLUMN]):
						yearly_groups.append(target[task_row][GROUP_COLUMN])
				"Monthly":
					monthly_section.append(target[task_row])
					if not monthly_groups.has(target[task_row][GROUP_COLUMN]):
						monthly_groups.append(target[task_row][GROUP_COLUMN])
				"Weekly":
					weekly_section.append(target[task_row])
					if not weekly_groups.has(target[task_row][GROUP_COLUMN]):
						weekly_groups.append(target[task_row][GROUP_COLUMN])
				"Daily":
					daily_section.append(target[task_row])
					if not daily_groups.has(target[task_row][GROUP_COLUMN]):
						daily_groups.append(target[task_row][GROUP_COLUMN])
				_:
					print("You didn't say the magic word")



func smart_to_dumb_array():
	pass


##signal town
##Tree Signals

func _on_cell_selected() -> void:
	var selected_cell: TreeItem = get_selected()
	var selected_cell_column: int = get_selected_column()
	prints("Cell Selected:", selected_cell.get_text(selected_cell_column))
	
	
func _on_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var selected_column = get_column_title(column)
	print(selected_column)



## Section Selection signals

func _on_yearly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if current_toggled_section != DataGlobal.Section.YEARLY:
			current_toggled_section = DataGlobal.Section.YEARLY
			switch_sections("Yearly")
			prints("Yearly Section Toggled")
		else:
			prints("ALREADY TOGGLED")


func _on_monthly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if current_toggled_section != DataGlobal.Section.MONTHLY:
			current_toggled_section = DataGlobal.Section.MONTHLY
			switch_sections("Monthly")
			prints("Monthly Section Toggled")
		else:
			prints("ALREADY TOGGLED")


func _on_weekly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if current_toggled_section != DataGlobal.Section.WEEKLY:
			current_toggled_section = DataGlobal.Section.WEEKLY
			switch_sections("Weekly")
			prints("Weekly Section Toggled")
		else:
			prints("ALREADY TOGGLED")


func _on_daily_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if current_toggled_section != DataGlobal.Section.DAILY:
			current_toggled_section = DataGlobal.Section.DAILY
			switch_sections("Daily")
			prints("Daily Section Toggled")
		else:
			prints("ALREADY TOGGLED")
