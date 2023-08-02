extends Resource
class_name YearTaskData



@export var year_task_data_name: String
@export var year: int

var yearly_data: Array
var monthly_data: Array
var month_data_bundle: Array


#someone please tell me a better way to create these month_arrays with code
var january: Array
var february: Array
var march: Array
var april: Array
var may: Array
var june: Array
var july: Array
var august: Array
var september: Array
var october: Array
var november: Array
var december: Array

var january_day: Array
var february_day: Array
var march_day: Array
var april_day: Array
var may_day: Array
var june_day: Array
var july_day: Array
var august_day: Array
var september_day: Array
var october_day: Array
var november_day: Array
var december_day: Array

var january_week: Array
var february_week: Array
var march_week: Array
var april_week: Array
var may_week: Array
var june_week: Array
var july_week: Array
var august_week: Array
var september_week: Array
var october_week: Array
var november_week: Array
var december_week: Array


var section_keys: Array = DataGlobal.Section.keys()
var month_keys: Array = DataGlobal.Month.keys()

@export var column_header: Array = [
	"Task",
	"Section",
	"Group",
	"Task Description",
	"Responsible Parties",
	"Time of Day",
	"Priority",
	"Location",
	"Days in Cycle",
	"Last Completed",
	"Days when skipping?",
]


func _init(year_init: int = 1990, name_init:= "blank") -> void:
	year = year_init
	year_task_data_name = name_init
	print("New YearTaskData named '", year_task_data_name, "' for year ", year, " initializing:")
	print()
	
	# also tell me how to refactor this nested mess
	month_data_bundle = [january, february, march, april, may, june, july, august,
			september, october, november, december]
	january = [january_week, january_day]
	february = [february_week, february_day]
	march = [march_week, march_day]
	april = [april_week, april_day]
	may = [may_week, may_day]
	june = [june_week, june_day]
	july = [july_week, july_day]
	august = [august_week, august_day]
	september = [september_week, september_day]
	october = [october_week, october_day]
	november = [november_week, november_day]
	december = [december_week, december_day]
	print("Month data bundle initialized")
	print()
	
	for current_section_value in DataGlobal.Section.values():
#		var section_label: String = section_keys[current_section_value]
#		section_label = section_label.capitalize()
		match current_section_value:
				DataGlobal.Section.YEARLY:
					yearly_data.append(TaskData.new(year, current_section_value))
				DataGlobal.Section.MONTHLY:
					monthly_data.append(TaskData.new(year, current_section_value))
				DataGlobal.Section.WEEKLY:
					january_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.JANUARY))
					february_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.FEBRUARY))
					march_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.MARCH))
					april_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.APRIL))
					may_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.MAY))
					june_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.JUNE))
					july_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.JULY))
					august_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.AUGUST))
					september_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.SEPTEMBER))
					october_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.OCTOBER))
					november_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.NOVEMBER))
					december_week.append(TaskData.new(year, current_section_value, DataGlobal.Month.DECEMBER))
				DataGlobal.Section.DAILY:
					january_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.JANUARY))
					february_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.FEBRUARY))
					march_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.MARCH))
					april_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.APRIL))
					may_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.MAY))
					june_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.JUNE))
					july_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.JULY))
					august_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.AUGUST))
					september_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.SEPTEMBER))
					october_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.OCTOBER))
					november_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.NOVEMBER))
					december_day.append(TaskData.new(year, current_section_value, DataGlobal.Month.DECEMBER))

	print("Year Task Data initialized and availible.")
