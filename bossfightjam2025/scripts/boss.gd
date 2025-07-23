extends CharacterBody2D
class_name Boss

@export var player: PlayerCharacter
@export var SPEED: float 


func getTargetedPlayer() -> PlayerCharacter:
	return player
