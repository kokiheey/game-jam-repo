extends CharacterBody2D
class_name Boss

@export var player: PlayerCharacter
@export var SPEED: float 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var gravity: bool
var health: int

signal boss_death

func getTargetedPlayer() -> PlayerCharacter:
	return player


func check_state():
	if health <= 0:
		boss_death.emit()
		collision_layer = 0b00000001
		gravity = true

func _ready():
	sprite.play("idle")
	gravity = false

func _process(delta:float):
	if gravity: velocity += get_gravity() * delta
