extends MenuButton

@export var task_editor: Control
@export var data_manager_center: Control

@onready var popup := get_popup()

var save_files_index: int = 0
var save_files_text: String = "Save Files"
var change_logs_index: int = 1
var change_logs_text: String = "Change Logs"
var task_settings_index: int = 2
var task_settings_text: String = "Task Settings"
var task_data_manager_index: int = 4
var task_data_manager_text: String = "Database Manager"
var to_task_menu_index: int = 6
var to_task_menu_text: String = "Task Tracking Menu"
var to_main_menu_index: int = 7
var to_main_menu_text: String = "Main Menu"
var quit_index: int = 8
var quit_text: String = "Quit"



func _ready() -> void:
	connect_menu_button_popup()
	popup.hide_on_item_selection = false

func connect_menu_button_popup() -> void:
	popup.connect("id_pressed", menu_button_actions)


func menu_button_actions(id: int) -> void:
	match id:
		save_files_index:
			TaskTrackingGlobal.submit_changed_data_to_database()
			popup.hide()
		change_logs_index:
			print("Change Logs Pressed")
			popup.hide()
		task_settings_index:
			to_task_settings_menu()
		task_data_manager_index:
			data_manager_center.visible = true
			popup.hide()
		to_task_menu_index:
			to_task_menu()
		to_main_menu_index:
			to_main_menu()
		quit_index:
			quit_function()


func to_task_settings_menu() -> void:
	if not save_protection(task_settings_index):
		return
	get_tree().change_scene_to_file("res://scenes/task_tracking_settings_menu.tscn")


func to_task_menu() -> void:
	if not save_protection(to_task_menu_index):
		return
	get_tree().change_scene_to_file("res://scenes/task_tracking_main_menu.tscn")


func to_main_menu() -> void:
	if not save_protection(to_main_menu_index):
		return
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func quit_function() -> void:
	if not save_protection(quit_index):
		return
	get_tree().quit()


func save_protection(index_parameter: int) -> bool:
	if task_editor.save_warning_button.text == "DATA NEEDS SAVING!":
		match task_editor.quit_counter:
			0:
				popup.set_item_text(index_parameter, "Not Saved!")
			1:
				popup.set_item_text(index_parameter, "Confirm Quit")
			2:
				popup.visible = false
				return true
		task_editor.quit_counter += 1
		return false
	else:
		popup.visible = false
		return true


func correct_menu_item(item_index: int, item_text: String) -> void:
	if popup.get_item_text(item_index) != item_text:
		popup.set_item_text(item_index, item_text)


func _on_pressed() -> void:
	correct_menu_item(save_files_index, save_files_text)
	correct_menu_item(change_logs_index, change_logs_text)
	correct_menu_item(task_settings_index, task_settings_text)
	correct_menu_item(task_data_manager_index, task_data_manager_text)
	correct_menu_item(to_task_menu_index, to_task_menu_text)
	correct_menu_item(to_main_menu_index, to_main_menu_text)
	correct_menu_item(quit_index, quit_text)
	task_editor.quit_counter = 0
