class_name HealthComponent
extends Node


signal healthChanged(amount: float)
signal died
@export var MAX_HEALTH: float = 100.0
var health: float
func _ready():
	health = MAX_HEALTH

func take_damage(attackData: AttackData):
	health -= attackData.attack_damage
	healthChanged.emit(health)
	if(health <= 0):
		died.emit()
	
func heal(heal_amount: float):
	health += heal_amount
