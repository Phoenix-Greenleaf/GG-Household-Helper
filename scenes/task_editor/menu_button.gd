extends MenuButton


@onready var popup := get_popup()



func _ready() -> void:
	connect_menu_button_popup()
	popup.hide_on_item_selection = false

func connect_menu_button_popup() -> void:
	popup.connect("id_pressed", menu_button_actions)


func menu_button_actions(id: int) -> void:
	match id:
		0:
			menu_to_main_menu_with_save_protection()
		1:
			print("Save File Pressed")
			save_active_data()
			popup.hide()
		2:
			print("Change Logs Pressed")
			popup.hide()
		3:
			menu_quit_with_save_protection()
		5:
			data_manager_center.visible = true
			popup.hide()
		6:
			menu_to_task_menu_with_save_protection()
		8:
			save_active_data()
			popup.visible = false
			get_tree().change_scene_to_file("res://scenes/task_tracking_settings.tscn")


func menu_quit_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(quit_index, "Not Saved!")
			1:
				popup.set_item_text(quit_index, "Confirm Quit")
			2:
				popup.visible = false
				get_tree().quit()
		quit_counter += 1
	else:
		popup.visible = false
		get_tree().quit()


func menu_to_main_menu_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(to_main_menu_index, "Not Saved!")
			1:
				popup.set_item_text(to_main_menu_index, "Confirm Quit")
			2:
				popup.visible = false
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		quit_counter += 1
	else:
		popup.visible = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func menu_to_task_menu_with_save_protection() -> void:
	if save_warning_button.text == "DATA NEEDS SAVING!":
		match quit_counter:
			0:
				popup.set_item_text(to_task_menu_index, "Not Saved!")
			1:
				popup.set_item_text(to_task_menu_index, "Confirm Quit")
			2:
				popup.visible = false
				get_tree().change_scene_to_file("res://scenes/task_tracking_menu.tscn")
		quit_counter += 1
	else:
		popup.visible = false
		get_tree().change_scene_to_file("res://scenes/task_tracking_menu.tscn")


func _on_pressed() -> void:
	popup.set_item_text(quit_index, "Quit")
	popup.set_item_text(to_main_menu_index, "Main Menu")
	popup.set_item_text(to_task_menu_index, "Task Tracking Menu")
	quit_counter = 0
	pass # Replace with function body.
