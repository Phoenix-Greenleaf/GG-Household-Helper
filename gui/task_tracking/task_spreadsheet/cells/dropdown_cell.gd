extends OptionButton

var saved_task_id: String
var saved_column: String
var saved_user_id: int
var saved_dropdown_text: String
var saved_dropdown_item_id: int


func set_dropdown_cell(task_id_param: String, column_param: String, dropdown_param: String, dropdown_items: Array, user_id_param: int) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	saved_dropdown_text = dropdown_param
	if user_id_param != -1:
		saved_user_id = user_id_param
	var item_id: int = 0
	for item_iteration in dropdown_items:
		add_item(item_iteration, item_id)
		item_id += 1
		if item_iteration == saved_dropdown_text:
			saved_dropdown_item_id = item_id
	selected = saved_dropdown_item_id
