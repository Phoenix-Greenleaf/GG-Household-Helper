extends Tree


@onready var month_menu_button:= $"../../SideMenuVBox/MonthSelectionMenu" as MenuButton
@onready var month_menu_popup:= month_menu_button.get_popup()

#var default_import = preload("user directory some day")
#var default_import = preload("res://data/default_input_1.csv") # but for now, just the res directory
var default_data: Array #= default_import.records


var column_header: Array = []


var Checkbox: Dictionary = DataGlobal.Checkbox
var Section: Dictionary = DataGlobal.Section
var Month: Dictionary = DataGlobal.Month
var TimeOfDay: Dictionary = DataGlobal.TimeOfDay
var Priority: Dictionary = DataGlobal.Priority


var editor_modes: Dictionary = {"Checkbox": 0, "Info": 1}

var year_for_data: int = 1990
var current_toggled_section: int = DataGlobal.Section.YEARLY
var current_toggled_mode = editor_modes["Checkbox"]
var current_toggled_month: String = "January"
var last_toggled_month: int = 1


var info_columns: Array = [5, 6, 7, 8, 9, 10, 11]
var number_of_info_columns = info_columns.size()
var first_checkbox_column: int = 12


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

enum {SECTION_COLUMN = 1, GROUP_COLUMN = 2, MONTH_COLUMN = 3}



func _ready() -> void:
	connect_month_menu()
	create_new_blank_tree()


func connect_month_menu() -> void:
	month_menu_popup.connect("id_pressed", month_menu_button_actions)

func month_menu_button_actions(id: int) -> void:
	match id:
		1:
			month_menu_switch(1, "January")
		2:
			month_menu_switch(2, "February")
		3:
			month_menu_switch(3, "March")
		4:
			month_menu_switch(4, "April")
		5:
			month_menu_switch(5, "May")
		6:
			month_menu_switch(6, "June")
		7:
			month_menu_switch(7, "July")
		8:
			month_menu_switch(8, "August")
		9:
			month_menu_switch(9, "September")
		10:
			month_menu_switch(10, "October")
		11:
			month_menu_switch(11, "November")
		12:
			month_menu_switch(12, "December")
	prints("Switching between months")
	switch_sections("Daily")


func month_menu_switch(passed_id: int, month_text: String) -> void:
			month_menu_button.text = month_text
			month_menu_popup.set_item_disabled(passed_id, true)
			current_toggled_month =  month_text
			month_menu_popup.set_item_disabled(last_toggled_month, false)
			last_toggled_month = passed_id



func create_new_blank_tree() -> void: #initializes on yearly, could be a setting
	number_of_rows = default_data.size()
	prints("Number of rows:", number_of_rows)
	dumb_to_smart_array(default_data)
	set_table_headers()
	new_assign_by_group("Yearly")
	
	
func switch_sections(new_section: String) -> void:
	clear_current_tree()
	set_table_headers()
	new_assign_by_group(new_section)
	


func new_assign_by_group(section_to_assign: String) -> void:
	var root_node: TreeItem = create_item()
	var tree_groups: Dictionary = {}
	match section_to_assign:
		"Yearly":
			create_group_roots(yearly_groups, tree_groups, root_node)
			create_tree_items(yearly_section, tree_groups)
			remove_unused_checkboxes(30)
		"Monthly":
			create_group_roots(monthly_groups, tree_groups, root_node)
			create_tree_items(monthly_section, tree_groups)
			remove_unused_checkboxes(19)
		"Weekly":
			create_group_roots(weekly_groups, tree_groups, root_node)
			create_tree_items(weekly_section, tree_groups)
			remove_unused_checkboxes(26)
		"Daily":
			create_group_roots(daily_groups, tree_groups, root_node)
			create_tree_items(daily_section, tree_groups)
			remove_unused_checkboxes(31 - days_in_month_finder())
		_:
			print("Assignment Error: No Section Match")
	

func create_group_roots(current_groups_section: Array, current_tree_groups: Dictionary, current_root: TreeItem) -> void:
	for current_root_group in current_groups_section:
		current_tree_groups[current_root_group] = current_root.create_child()
		current_tree_groups[current_root_group].set_text(0, current_root_group)


func create_tree_items(current_section: Array, current_tree_groups: Dictionary) -> void:
	for row_loop in current_section.size():
		var current_assignment_group = current_section[row_loop][GROUP_COLUMN]
		var child: TreeItem = current_tree_groups[current_assignment_group].create_child()
		var info_offset: int = 0
		var adjusted_column: int = 0
		var adjusted_header_size = current_section[row_loop].size() - number_of_info_columns
		
		if current_toggled_mode == editor_modes["Checkbox"]:
			for column_loop in (adjusted_header_size):
				if info_columns.has(column_loop):
					info_offset += 1
					continue
				adjusted_column = column_loop - info_offset
				child.set_text(adjusted_column, current_section[row_loop][column_loop])
		elif current_toggled_mode == editor_modes["Info"]:
			for column_loop in current_section[row_loop].size():
				child.set_text(column_loop, current_section[row_loop][column_loop])
		else: print("create_tree_items error")
		
		if current_section[row_loop][MONTH_COLUMN] != current_toggled_month:
			if current_section[row_loop][MONTH_COLUMN] != "All":
				child.visible = false


func remove_unused_checkboxes(number_to_remove: int) -> void:
	if current_toggled_mode == editor_modes["Info"]:
		columns -= 31
	else:
		columns -= number_to_remove


func days_in_month_finder() -> int:
	match current_toggled_month: 
		"February":
			var leap_year_check = year_for_data % 4
			if leap_year_check == 0:
				return 29
			else:
				return 28
		"April", "June", "September", "November":
			return 30
		"January", "March", "May", "July", "August", "October", "December":
			return 31
		_:
			print("Days_in_month_finder match error")
			return 6



func get_all_tree_items(target: TreeItem = get_root(), level: int = 1) -> void:
	
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
	if current_toggled_mode == editor_modes["Checkbox"]:
		number_of_columns = column_header.size() - number_of_info_columns
	elif current_toggled_mode == editor_modes["Info"]:
		number_of_columns = column_header.size()
		
	columns = number_of_columns
	var current_column: int = 0
	var info_offset: int = 0
	var adjusted_column: int = 0
	for header_string in column_header:
		if current_toggled_mode == editor_modes["Checkbox"]:
			if info_columns.has(current_column):
				current_column += 1
				info_offset += 1
			else:
				adjusted_column = current_column - info_offset
				set_column_title(adjusted_column, header_string)
				current_column += 1
#				prints("Printed column title - offset:", current_column, info_offset)
		
		elif current_toggled_mode == editor_modes["Info"]:
			set_column_title(current_column, header_string)
			current_column += 1
		else: print("set_table_headers error")


func clear_current_tree() -> void:
	# save some details to for restoring scroll position, etc. upon return
	clear()


func print_human_tree_address() -> void:
	var human_tree_address: Array = []
	for computer_address in tree_address:
		human_tree_address.append(computer_address.get_text(0))
	prints("Magic array:", human_tree_address)


func dumb_to_smart_array(target: Array) -> void:
	column_header = target[0] #headers isolated
	
	for task_row in target.size(): 
		if task_row == 0: #skip the header row
			continue
		match target[task_row][SECTION_COLUMN]: #section separation
			"Yearly":
				yearly_section.append(target[task_row]) #add task to section
				if not yearly_groups.has(target[task_row][GROUP_COLUMN]): #create group if group not found
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


func smart_to_dumb_array() -> void:
	pass


func section_enum_to_string() -> String:
	var section_enum: int = current_toggled_section
	var section_keys: Array = DataGlobal.Section.keys()
	var current_section_key: String = section_keys[section_enum]
	return current_section_key.capitalize()



func custom_drawing(_drawn_treeitem: TreeItem, position_and_size: Rect2):
	var x_size = position_and_size.size.x
	var y_size = position_and_size.size.y
	var x_position = position_and_size.position.x
	var y_position = position_and_size.position.y
	var half_y_size = y_size / 2
	var half_y_position = y_position + half_y_size
	var half_size := Vector2(x_size, half_y_size)
	var top_position := Vector2(x_position, y_position)
	var bottom_position := Vector2(x_position, half_y_position)
	var top_rect := Rect2(top_position, half_size)
	var bottom_rect := Rect2(bottom_position, half_size)
	var current_color: Color = DataGlobal.current_checkbox_profile[1]
	var white := Color(1, 1, 1)
	draw_rect(top_rect, white)
	draw_rect(bottom_rect, current_color)

##signal town


##Tree Signals

func _on_cell_selected() -> void:
	var selected_cell: TreeItem = get_selected()
	var selected_cell_column: int = get_selected_column()
	prints("Cell Selected:", selected_cell.get_text(selected_cell_column))
	if selected_cell_column >= (first_checkbox_column - number_of_info_columns):
		selected_cell.set_cell_mode(selected_cell_column, TreeItem.CELL_MODE_CUSTOM)
		selected_cell.set_custom_draw(selected_cell_column, self, "custom_drawing")
#		selected_cell.set_custom_color(selected_cell_column, DataGlobal.current_checkbox_profile[1])
	
	
	
func _on_column_title_clicked(column: int, _mouse_button_index: int) -> void:
	var selected_column = get_column_title(column)
	print(selected_column)



## Section Selection signals

func _on_yearly_button_toggled(button_pressed: bool) -> void:
	if (button_pressed): #check to see if this toggle/if statement is needed
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


func _on_checkbox_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if current_toggled_mode != editor_modes["Checkbox"]:
			current_toggled_mode = editor_modes["Checkbox"]
			switch_sections(section_enum_to_string())
			prints("Checkbox Mode toggled")
		else:
			prints("ALREADY TOGGLED")


func _on_info_mode_button_toggled(button_pressed: bool) -> void:
	if (button_pressed):
		if current_toggled_mode != editor_modes["Info"]:
			current_toggled_mode = editor_modes["Info"]
			switch_sections(section_enum_to_string())
			prints("Info Mode toggled")
		else:
			prints("ALREADY TOGGLED")
