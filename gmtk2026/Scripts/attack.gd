class_name Attack
extends Area2D

@export var attackData : AttackData

func _on_area_entered(area):
	if area is HurtBoxComponent:
		var hurtBox = area as HurtBoxComponent
		attackData.attack_position = global_position
		hurtBox.damage(attackData)
