class_name HurtBoxComponent
extends Area2D

@export var healthComponent: HealthComponent

func damage(damage_amount: float):
	if healthComponent:
		healthComponent.take_damage(damage_amount)
