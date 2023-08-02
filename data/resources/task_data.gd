extends Resource
class_name TaskData

@export var task_id: int
@export var task: String
@export var section: DataGlobal.Section
@export var month: DataGlobal.Month
@export var year: int
@export var group: String
@export var task_description: String
@export var responsible_parties: String
@export var time_of_day: DataGlobal.TimeOfDay
@export var priority: DataGlobal.Priority
@export var location: String
@export var cycle: Array
@export var days_when_skipped: int
@export var last_completed: int 

var checkbox_data: Array

var section_keys: Array = DataGlobal.Section.keys()
var month_keys: Array = DataGlobal.Month.keys()



func _init(year_init: int, section_init: DataGlobal.Section,
		_month_init: DataGlobal.Month = DataGlobal.Month.ALL) -> void:
	year = year_init
	section = section_init
	month = _month_init
	
	var section_label: String = section_keys[section]
	var month_label: String = month_keys[month]
	section_label = section_label.capitalize()
	month_label = month_label.capitalize()
	print( "TaskData initializing: ", year, " ", month_label, " ", section_label)
	
	match section:
		DataGlobal.Section.YEARLY:
			create_checkbox_data()
			print_complete(section_label)
		DataGlobal.Section.MONTHLY:
			create_checkbox_data(12)
			print_complete(section_label)
		DataGlobal.Section.WEEKLY:
			create_checkbox_data(5)
			print_complete(section_label)
		DataGlobal.Section.DAILY:
			match month:
				DataGlobal.Month.APRIL, DataGlobal.Month.JUNE, \
				DataGlobal.Month.SEPTEMBER, DataGlobal.Month.NOVEMBER:
					create_checkbox_data(30)
				DataGlobal.Month.FEBRUARY:
					if (year % 4) == 0:
						create_checkbox_data(29)
					else:
						create_checkbox_data(28)
				DataGlobal.Month.JANUARY, DataGlobal.Month.MARCH, DataGlobal.Month.MAY, DataGlobal.Month.JULY, DataGlobal.Month.AUGUST, DataGlobal.Month.OCTOBER, DataGlobal.Month.DECEMBER:
					create_checkbox_data(31)
				_:
					create_checkbox_data(69)
			print_complete(section_label)
		_:
			print("Some kind of oops: ", section_label)




func print_complete(section_label: String) -> void:
	var completext = " section completed"
	print(section_label, completext)
	print()


func create_checkbox_data(checkbox_length: int = 1) -> void:
	checkbox_data.resize(checkbox_length)
	checkbox_data.fill(DataGlobal.Checkbox.ASSIGNED)
	print(checkbox_length, " checkbox(es) created")
