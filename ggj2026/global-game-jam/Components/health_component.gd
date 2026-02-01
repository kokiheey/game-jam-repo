extends Node
class_name health_component
@export var MAX_HEALTH: float = 10.0
var health: float

signal dead
func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		dead.emit()
