extends Node2D
class_name Wave

@export var Width: float
@export var Speed: float
@onready var sprite := $WaveSprite as Sprite2D

var radius := 0.0

func _process(delta: float):
	radius += Speed * delta
	sprite.scale = Vector2(radius, radius)
