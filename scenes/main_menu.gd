extends Control


func _on_new_continue_button_pressed() -> void:
	print("New / Continue Pressed")
	get_tree().change_scene_to_file("res://scenes/editor.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()



func _on_data_manager_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/data_manager_screen.tscn")
