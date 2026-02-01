extends Area2D
class_name HitboxComponent

@export var health: health_component

func damage(attack: Attack):
	if health:
		print("took damage")
		health.damage(attack)
