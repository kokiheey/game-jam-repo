extends Node2D
class_name Player
@export var inputController : InputController

func _ready():
	inputController.primary.connect(_onPrimary)
	
	
func _onPrimary():
	attack()
	
	
func attack():
	
