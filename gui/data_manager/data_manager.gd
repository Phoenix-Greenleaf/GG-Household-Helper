extends PanelContainer


@onready var close_manager_button: Button = %CloseManager
@onready var import_task_file_dialog: FileDialog = $ImportTaskFileDialog



var csv_conversion: Array = []

func _ready() -> void:
	close_manager_button.pressed.connect(emit_exit_signal)
	import_task_file_dialog.visible = false


func emit_exit_signal() -> void:
	SignalBus.emit_signal("data_manager_close")
	prints("data manager close Emitted")


func import_csv(csv_to_import):
	var source_csv = FileAccess.open(csv_to_import,FileAccess.READ)
	if not source_csv:
		printerr("Failed to open CSV: ", source_csv)
		return FAILED #globalscope enum
	var rows = []
	while not source_csv.eof_reached():
		var single_row = source_csv.get_csv_line()
		rows.append(single_row)
	source_csv.close()
	
	#Removing trailing empty line, test if this is needed
	if not rows.is_empty() and rows.back().size() == 1 and rows.back()[0] == "":
		rows.pop_back()
	
	csv_conversion = []
	csv_conversion = rows

func import_task(save_path):
	var spreadsheet_year : int = csv_conversion[0][0]
	var spreadsheet_title : String = csv_conversion[0][1]
	var data = TaskSpreadsheetData.new(spreadsheet_year, spreadsheet_title)
	
	
	
	var filename = save_path + ".res"
	var save_error = ResourceSaver.save(data, filename)
	if save_error != OK:
		printerr("Failed to save resource: ", save_error)
	return save_error








func _on_import_task_csv_pressed() -> void:
	import_task_file_dialog.visible = true


func _on_import_task_file_dialog_file_selected(path: String) -> void:
	pass # Replace with function body.
