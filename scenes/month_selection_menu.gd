extends MenuButton


@onready var menu_popup := get_popup()

func connect_month_menu() -> void:
	connect("id_pressed", month_menu_button_actions)



func set_month_selection_menu() -> void:
	var selected_month = DataGlobal.task_tracking_current_toggled_month
	month_selection_menu_button.text = DataGlobal.month_strings[selected_month]
	month_selection_menu_popup.set_item_disabled(selected_month, true)



func month_menu_button_actions(id: int) -> void:
	var new_month: String = month_strings[id]
	var old_month: String = month_strings[last_toggled_month]
	prints("Switching from", old_month, "to", new_month)
	match id:
		1:
			month_menu_switch(1, DataGlobal.Month.JANUARY)
		2:
			month_menu_switch(2, DataGlobal.Month.FEBRUARY)
		3:
			month_menu_switch(3, DataGlobal.Month.MARCH)
		4:
			month_menu_switch(4, DataGlobal.Month.APRIL)
		5:
			month_menu_switch(5, DataGlobal.Month.MAY)
		6:
			month_menu_switch(6, DataGlobal.Month.JUNE)
		7:
			month_menu_switch(7, DataGlobal.Month.JULY)
		8:
			month_menu_switch(8, DataGlobal.Month.AUGUST)
		9:
			month_menu_switch(9, DataGlobal.Month.SEPTEMBER)
		10:
			month_menu_switch(10, DataGlobal.Month.OCTOBER)
		11:
			month_menu_switch(11, DataGlobal.Month.NOVEMBER)
		12:
			month_menu_switch(12, DataGlobal.Month.DECEMBER)
	SignalBus._on_task_editor_month_changed.emit()


func month_menu_switch(passed_id: int, passed_month: DataGlobal.Month) -> void:
			var month_keys = DataGlobal.Month.keys()
			month_selection_menu_button.text = month_keys[passed_id].capitalize()
			month_selection_menu_popup.set_item_disabled(passed_id, true)
			DataGlobal.task_tracking_current_toggled_month = passed_month
			month_selection_menu_popup.set_item_disabled(last_toggled_month, false)
			last_toggled_month = passed_id
