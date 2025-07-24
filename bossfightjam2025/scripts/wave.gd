extends Node2D
class_name Wave

@export var Width: float
@export var Speed: float
@export var MaxScale: float
@onready var sprite := $WaveSprite as Sprite2D

var radius := 0.0

func _ready():
	sprite.scale = Vector2.ZERO

func _process(delta: float):
	radius += Speed * delta
	sprite.scale = Vector2(radius, radius)
	if sprite.scale.length_squared() > MaxScale * MaxScale:
		queue_free()
