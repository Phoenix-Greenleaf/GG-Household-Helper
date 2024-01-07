extends CanvasLayer

@onready var black_color_rect: ColorRect = %BlackColorRect
@onready var transition_animation_player: AnimationPlayer = %TransitionAnimationPlayer



func _ready() -> void:
	black_color_rect.visible = false


func fade_from_black() -> void:
	transition_animation_player.play("fade")


func fade_to_black(scene_path_parameter: String) -> void:
	transition_animation_player.play_backwards("fade")
	await transition_animation_player.animation_finished
	get_tree().change_scene_to_file(scene_path_parameter)


func fade_quit() -> void:
	SceneTransition.transition_animation_player.play_backwards("fade")
	await SceneTransition.transition_animation_player.animation_finished
	get_tree().quit()
