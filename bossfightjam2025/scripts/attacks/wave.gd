extends Node2D
class_name Wave

@export var Width: float
@export var Speed: float
@export var MaxScale: float
@export var damage: int = 1

@onready var sprite := $WaveSprite as Sprite2D
@onready var pos_area := $PositiveArea
@onready var neg_area := $NegativeArea
var radius := 0.0
var inverted := true
var invertedMaterial := preload("res://assets/materials/player_inverted.tres")
func _ready():
	scale = Vector2.ZERO
	pos_area.body_entered.connect(try_damage)
	if inverted:
		sprite.material = invertedMaterial

func _process(delta: float):
	radius += Speed * delta
	scale = Vector2(radius, radius)
	if scale.length_squared() > MaxScale * MaxScale:
		queue_free()

func try_damage(body: Node2D):
	if body is PlayerCharacter and not neg_area.get_overlapping_bodies().has(body) and body.inverted != inverted:
		body.take_damage(damage)
