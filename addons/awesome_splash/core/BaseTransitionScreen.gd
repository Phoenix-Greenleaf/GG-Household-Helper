extends Node2D

enum TrainsitionType {NONE, FADE, DIAMOND, BLUR, BLUR_AND_FADE, PIXEL}
enum TransitionStatus {NONE, APPEAR, DISSAPPEAR}

# It's not good to put move_to_scene variable in this class
# I want it in a section like skip or custom node
# but I don't find PackedScene in Variant.Type enum.
@export var move_to_scene: PackedScene

@export var trainsition_type: TrainsitionType = TrainsitionType.FADE \
	: set = _set_transition_type

var fade_value: float : set = _set_fade_value
var current_time: float = 0.0
var animation_time: float = 0.0
var status: int = TransitionStatus.NONE


var blur_intensity: float = 4.0
var diamond_size: float = 32.0
var min_pixel: float = 1.0
var max_pixel: float = 128.0
var transition_time: float = 1.0
var fade_color: Color = Color.WHITE


var viewport_container: SubViewportContainer
var viewport: SubViewport
var transition_shader = preload("res://addons/awesome_splash/assets/shader/transition.gdshader")
var shader_meterial: ShaderMaterial


### BUILD IN ENGINE METHODS ====================================================

func _process(delta):
	if status == TransitionStatus.NONE or animation_time <= 0:
		set_process(false)
		return
	
	current_time += delta
	var value = current_time / animation_time
	value = min(value, 1.0)
	
	if status == TransitionStatus.APPEAR:
		self.fade_value = 1 - value
		if current_time >= animation_time:
			set_process(false)
			_on_finished_animation_screen_appear()
	
	if status == TransitionStatus.DISSAPPEAR:
		self.fade_value = value
		if current_time >= animation_time:
			set_process(false)
			_on_finished_animation_screen_disappear()

# overridden function
# call once when node selected. Added to ordinary export
func _get_property_list():
	if not Engine.is_editor_hint() or not is_inside_tree():
		return []
	
	var property_list = []
	
	if trainsition_type == TrainsitionType.FADE:
		property_list.append({
			"name": "transition_time",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "fade_color",
			"type": TYPE_COLOR ,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
		})
	
	if trainsition_type == TrainsitionType.DIAMOND:
		property_list.append({
			"name": "diamond_size",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
	
		property_list.append({
			"name": "transition_time",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "fade_color",
			"type": TYPE_COLOR ,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
		})
	
	if trainsition_type == TrainsitionType.BLUR:
		property_list.append({
			"name": "blur_intensity",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "transition_time",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
	if trainsition_type == TrainsitionType.BLUR_AND_FADE:
		property_list.append({
			"name": "blur_intensity",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "transition_time",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "fade_color",
			"type": TYPE_COLOR ,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
		})
		
	if trainsition_type == TrainsitionType.PIXEL:
		property_list.append({
			"name": "min_pixel",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "max_pixel",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
		property_list.append({
			"name": "transition_time",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			})
		
	return property_list


### PRIVATE METHODS ============================================================

func _setup_transition():
	shader_meterial = ShaderMaterial.new()
	shader_meterial.shader = transition_shader
	shader_meterial.set_shader_parameter("color", fade_color)
	shader_meterial.set_shader_parameter("diamond_size", diamond_size)
	shader_meterial.set_shader_parameter("blur_intensity", blur_intensity)
	shader_meterial.set_shader_parameter("min_pixel", min_pixel)
	shader_meterial.set_shader_parameter("max_pixel", max_pixel)
	shader_meterial.set_shader_parameter("transition_type", trainsition_type)
	
	viewport = SubViewport.new()
	viewport_container = SubViewportContainer.new()
	add_child(viewport_container)
	viewport_container.material = shader_meterial
	viewport_container.add_child(viewport)
	viewport.transparent_bg = true
	
	get_viewport().size_changed.connect(self._update_screen_size_changed)


func _update_screen_size_changed():
	var viewport_size = get_viewport_rect().size
	viewport.size = viewport_size


func _start_animation_screen_will_appear():
	if trainsition_type == TrainsitionType.NONE:
		_on_finished_animation_screen_appear()
	else:
		status = TransitionStatus.APPEAR
		animation_time = transition_time
		current_time = 0.0
		set_process(true)


func _start_animation_screen_will_disappear():
	if trainsition_type == TrainsitionType.NONE:
		_on_finished_animation_screen_disappear()
	else:
		status = TransitionStatus.DISSAPPEAR
		animation_time = transition_time
		current_time = 0.0
		set_process(true)


func _on_finished_animation_screen_appear():
	status = TransitionStatus.NONE


func _on_finished_animation_screen_disappear():
	status = TransitionStatus.NONE


### SETGET METHODS =============================================================
func _set_transition_type(value: int):
	trainsition_type = value
	notify_property_list_changed() # Call to update UI inspector

func _set_fade_value(value: float):
	fade_value = value
	self.shader_meterial.set_shader_parameter("process_value", value)
