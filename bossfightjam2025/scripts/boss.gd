extends CharacterBody2D
class_name Boss

@export var player: PlayerCharacter
@export var SPEED: float 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var health: int

signal boss_death

func getTargetedPlayer() -> PlayerCharacter:
	return player


func check_state():
	if health <= 0:
		boss_death.emit()

func _ready():
	sprite.play("idle")
