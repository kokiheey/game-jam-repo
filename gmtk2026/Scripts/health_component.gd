class_name HealthComponent
extends Node


signal healthChanged(amount: float)
signal died
@export var MAX_HEALTH: float = 100.0
var health: float
func _ready():
	health = MAX_HEALTH

func take_damage(damage: float):
	health -= damage
	healthChanged.emit(damage)
	if(health <= 0):
		died.emit()
	
func heal(heal_amount: float):
	take_damage(-heal_amount)
