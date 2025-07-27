extends Node2D
class_name Pillar

@export var speed: float = 1600
@export var damage: int = 1
signal destroyed

@onready var flood: Flood = get_parent()
@onready var hurt_box: Area2D = $Hurtbox
@onready var pillar_sprite: Sprite2D = $Sprite2D

var margin: int = 120
var direction := Vector2.ZERO
var inverted: bool

func _ready() -> void:
	randomize()
	inverted = !flood.inverted
	if inverted:
		pillar_sprite.modulate = flood.invertedColor
	else:
		pillar_sprite.modulate = flood.normalColor
	print(inverted)
	hurt_box.body_entered.connect(try_damage)
	var leftToRight: bool = randi_range(0, 1)
	var screen_w = get_viewport_rect().size.x
	var screen_h = get_viewport_rect().size.y
	scale = Vector2(1, 1)
	if leftToRight:
		direction = Vector2(-1, 0)
		position = Vector2(screen_w + margin, screen_h)
	else:
		direction = Vector2(1, 0)
		position = Vector2(-margin, screen_h)

func _process(delta: float) -> void:
	position += direction * speed * delta
	var screen_w = get_viewport_rect().size.x
	if position.x < -margin or position.x > screen_w + margin:
		emit_signal("destroyed")
		queue_free()
		
func try_damage(body: Node2D):
	if body is CharacterBody2D and body.inverted != inverted:
		body.take_damage(damage)
