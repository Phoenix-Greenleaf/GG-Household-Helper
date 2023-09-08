extends PanelContainer

@onready var task_set_name_label: Label = $MarginContainer/VBox/TaskSetNameLabel
@onready var task_set_year_label: Label = $MarginContainer/VBox/TaskSetYearLabel


@export var saved_resource: TaskSpreadsheetData 


func _ready() -> void:
	update_button()

func update_button() -> void:
	if saved_resource:
		task_set_name_label.text = saved_resource.spreadsheet_title
		task_set_year_label.text = str(saved_resource.spreadsheet_year)
	else:
		task_set_name_label.text = "Button Test"
		task_set_year_label.text = "2020"
