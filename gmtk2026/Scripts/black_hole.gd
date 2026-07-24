extends Node2D

@onready var sprite : Sprite2D = $Sprite2D

var MIN_LIGHT : float = 0.5
var MAX_LIGHT : float = 1
var time_passed : float = 0.0
var duration : float = 2.0

func _ready() -> void:
	time_passed = randf_range(0.0, duration)

func _process(delta: float) -> void:	
	time_passed += delta
	var current_time = pingpong(time_passed, duration)
	var curved_offset = Tween.interpolate_value(
		MIN_LIGHT, 
		MAX_LIGHT - MIN_LIGHT,
		current_time, 
		duration, 
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
	)
	var grad_texture = sprite.texture as GradientTexture2D
	grad_texture.gradient.set_offset(4, curved_offset)
