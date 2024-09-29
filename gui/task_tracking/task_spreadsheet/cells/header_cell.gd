extends PanelContainer

@onready var label: Label = %Label

var saved_column: String

var column_item_count: int
var widest_item: float
var tallied_cells: Array


func _ready() -> void:
	TaskSignalBus._on_task_cells_resized_workaround.connect(start_column_size_sync)


func set_header_title(column_param: String, title_param: String) -> void:
	label.text = title_param
	saved_column = column_param


func start_column_size_sync(column_param: String) -> void:
	if column_param != saved_column:
		return
	prints("Size Sync:", column_param)
	column_item_count = TaskTrackingGlobal.most_recent_query.size()
	tallied_cells = []
	widest_item = get_combined_minimum_size().x
	TaskSignalBus._on_task_cells_resized_comparison_started.emit(column_param, self)


func tally_cell(size_param: float, cell_param: Control) -> void:
	if size_param > widest_item:
		widest_item = size_param
	tallied_cells.append(cell_param)
	if column_item_count == tallied_cells.size():
		finish_column_size_sync()


func finish_column_size_sync() -> void:
	header_sync_size()
	for cell_iteration in tallied_cells:
		cell_iteration.sync_size(widest_item)


func header_sync_size() -> void:
	var min_size: Vector2 = Vector2(widest_item, 0)
	custom_minimum_size = min_size
