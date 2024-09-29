extends OptionButton

var saved_task_id: String
var saved_column: String
var saved_user_id: int
var saved_dropdown_text: String
var saved_dropdown_item_id: int


func _ready() -> void:
	TaskSignalBus._on_task_editing_lock_toggled.connect(disable_cell)
	TaskSignalBus._on_task_cells_resized_comparison_started.connect(send_in_size_for_comparison)


func disable_cell(editing_locked: bool) -> void:
	disabled = editing_locked


func set_dropdown_cell(task_id_param: String, column_param: String, dropdown_param: String, dropdown_items: Array, user_id_param: int) -> void:
	saved_task_id = task_id_param
	saved_column = column_param
	#saved_dropdown_item_id = 0
	saved_dropdown_text = dropdown_param.capitalize()
	if user_id_param != -1:
		saved_user_id = user_id_param
	var item_id: int = 0
	if not dropdown_items[0]:
		return
	for item_iteration in dropdown_items:
		if item_iteration == null:
			continue
		add_item(item_iteration, item_id)
		if item_iteration == saved_dropdown_text:
			saved_dropdown_item_id = item_id
		item_id += 1
	selected = saved_dropdown_item_id



func send_in_size_for_comparison(column_param: String, header_param: Control) -> void:
	if column_param != saved_column:
		return
	header_param.tally_cell(size.x, self)


func sync_size(size_param: float) -> void:
	size.x = size_param
