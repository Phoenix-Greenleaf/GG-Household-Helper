extends Resource

class_name CheckboxData

@export var checkbox_status : DataGlobal.Checkbox
@export var assigned_user : Array



func update_checkbox_data(
	checkbox_status_parameter : DataGlobal.Checkbox = DataGlobal.current_checkbox_state,
	assigned_user_parameter : Array = DataGlobal.current_checkbox_profile,
	) -> void:
	
	checkbox_status = checkbox_status_parameter
	assigned_user = assigned_user_parameter
