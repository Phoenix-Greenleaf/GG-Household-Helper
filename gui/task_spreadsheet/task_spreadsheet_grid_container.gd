extends GridContainer

@export var data_for_spreadsheet : TaskSpreadsheetData

func _ready() -> void:
	ready_connections()
	if !data_for_spreadsheet:
#		test_spreadsheet_initialization()
		print("No Tasksheet found for TaskGrid....")
	else:
		var title = DataGlobal.current_tasksheet_data.spreadsheet_title
		var year = DataGlobal.current_tasksheet_data.spreadsheet_year
		prints("TaskGrid found:", title, ":", year)
	
func ready_connections() -> void:
	if DataGlobal.current_tasksheet_data:
		data_for_spreadsheet = DataGlobal.current_tasksheet_data
	SignalBus._on_current_tasksheet_data_changed.connect(update_grid_spreadsheet)


#func test_spreadsheet_initialization() -> void:
#	print("No data found for spreadsheet, running test instead.")
#	var test_year = 1992
#	prints("Testing Year", test_year)
#	var test = TaskSpreadsheetData.new(test_year)
#	test.initialization_test()


func update_grid_spreadsheet() -> void:
	data_for_spreadsheet = DataGlobal.current_tasksheet_data
	var title = DataGlobal.current_tasksheet_data.spreadsheet_title
	var year = DataGlobal.current_tasksheet_data.spreadsheet_year
	prints("TaskGrid updated:", title, ":", year)
