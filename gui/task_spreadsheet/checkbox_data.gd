extends Resource

class_name CheckboxData

@export var checkbox_status = DataGlobal.Checkbox
@export var assigned_user : Array


func _init(
	checkbox_status_parameter = DataGlobal.Checkbox.ACTIVE,
	assigned_user_parameter = DataGlobal.user_profiles[0],
	) -> void:
	checkbox_status = checkbox_status_parameter
	assigned_user = assigned_user_parameter
