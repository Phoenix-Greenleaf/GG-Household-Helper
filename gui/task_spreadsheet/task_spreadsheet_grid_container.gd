extends GridContainer



func _ready() -> void:
	var test1 = TaskData.new()
	var checkbox_check_1 = test1.month_checkbox_dictionary.January[13]
	prints("Checkbox test 1:", checkbox_check_1)
	var status_keys = DataGlobal.Checkbox.keys()
	var checkbox_status = checkbox_check_1.checkbox_status
	prints("Checkbox is currently", status_keys[checkbox_status])
	prints("Checkbox assigned to", checkbox_check_1.assigned_user[0])

