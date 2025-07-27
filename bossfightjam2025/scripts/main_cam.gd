extends Camera2D

@export var shake_duration := 0.25
@export var shake_magnitude := 8.0

@onready var player : CharacterBody2D = get_node("/root/Main/player")

var _shake_time := 0.0

func _process(delta: float) -> void:
	if _shake_time > 0.0:
		_shake_time -= delta
		offset = Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude)
		)
	else:
		offset = Vector2.ZERO

func shake():
	_shake_time = shake_duration

func _ready():
	player.connect("damageShake", shake)
	make_current()
