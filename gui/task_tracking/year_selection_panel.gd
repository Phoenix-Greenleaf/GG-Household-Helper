extends PanelContainer

@onready var option_button: OptionButton = %OptionButton
@onready var spin_box: SpinBox = %SpinBox
@onready var accept_button: Button = %AcceptButton
@onready var cancel_button: Button = %CancelButton

@export var opening_button: Button

var selected_year: int: set = set_selected_year




func _ready() -> void:
	opening_button.pressed.connect(open_panel)


func set_selected_year(value):
		selected_year = value
		toggle_accept_button()


func open_panel() -> void:
	visible = true


func toggle_accept_button() -> void:
	if not selected_year or selected_year == TaskTrackingGlobal.current_toggled_year:
		accept_button.disabled = true
		return
	if accept_button.disabled:
		accept_button.disabled = false


func populate_existing_years() -> void:
	var existing_years: Array = SqlManager.get_unique_elements_from_column("daily_tasks, weekly_tasks, monthly_tasks", "year")
	for unique_year in existing_years:
		option_button.add_item(unique_year, int(unique_year))


func year_accepted() -> void:
	TaskTrackingGlobal.current_toggled_year = selected_year
	reset_values()
	visible = false


func reset_values() -> void:
	spin_box.set_value_no_signal(2000)
	selected_year = 2000
	reset_option_button()


func reset_option_button() -> void:
	option_button.clear()
	option_button.add_item("Existing Years", 0)
	var item_index: int = option_button.get_item_index(0)
	option_button.select(item_index)



func _on_spin_box_value_changed(value: float) -> void:
	selected_year = value


func _on_option_button_item_selected(index: int) -> void:
	var selected_id: int = option_button.get_item_id(index)
	selected_year = selected_id


func _on_cancel_button_pressed() -> void:
	visible = false


func _on_accept_button_pressed() -> void:
	year_accepted()
