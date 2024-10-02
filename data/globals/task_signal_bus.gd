extends Node


signal _on_task_grid_populated(row_data: Dictionary)
signal _on_task_grid_column_count_changed(new_count: int)
signal _on_description_button_pressed(cell: Button)
signal _on_new_database_loaded
signal _on_task_grid_column_toggled
signal _on_task_grid_cell_changes_applied(task_id: String, column: String, data_changes: Array)
signal _on_data_modified
signal _on_data_saved
signal _on_section_changed
signal _on_month_changed
signal _on_year_changed
signal _on_checkbox_mode_changed
signal _on_task_editing_lock_toggled(lock_active: bool)
signal _on_task_grid_scrolled(value: float)
signal _on_task_editing_settings_changed
signal _on_database_manager_remote_close_pressed
signal _on_database_manager_remote_open_pressed
signal _on_data_cell_modified(cell_id, column_name: String, original_value, new_value)
signal _on_data_cell_remote_updated(cell_id, column_name: String, new_value)
signal _on_new_task_added(new_id: int, task_data: Dictionary)


signal _on_task_cells_resized_workaround_all_columns
signal _on_task_cells_resized_workaround(column: String)
signal _on_task_cells_resized_comparison_started(column: String, column_header: Control)
signal _on_task_cells_resized_final_size(cell_size: Vector2)














signal _on_data_set_saved





signal _on_checkbox_selection_changed
signal _on_profile_selection_changed
signal _on_task_delete_button_primed_and_pressed















signal _on_active_database_switched # retire this for on_new_database_loaded
signal _on_column_visibility_toggled(column: String, toggle: bool)
signal _on_save_button_pressed
signal _on_grid_reload_pressed
signal _on_group_dropdown_items_changed
signal _on_assigned_user_dropdown_items_changed
