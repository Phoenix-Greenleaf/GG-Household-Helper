extends GridContainer

@export var data_for_spreadsheet : TaskSpreadsheetData

func _ready() -> void:
	if !data_for_spreadsheet:
		test_spreadsheet_initialization()
	else:
		print("Spreadsheet data found!")
	

func test_spreadsheet_initialization() -> void:
	print("No data found for spreadsheet, running test instead.")
	var test_year = 1992
	prints("Testing Year", test_year)
	var test = TaskSpreadsheetData.new(test_year)
	test.initialization_test()
