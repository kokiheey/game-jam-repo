extends CharacterBody2D
class_name Boss

@export var player: PlayerCharacter
@export var SPEED: float 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func getTargetedPlayer() -> PlayerCharacter:
	return player


func _ready():
	sprite.play("idle")
