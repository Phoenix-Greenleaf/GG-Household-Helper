extends Node2D

@onready var logo_video_stream_player: VideoStreamPlayer = %LogoVideoStreamPlayer


func _ready() -> void:
	logo_video_stream_player.finished.connect(loop_video_the_long_way)
	pass



func loop_video_the_long_way() -> void:
	logo_video_stream_player.play()
