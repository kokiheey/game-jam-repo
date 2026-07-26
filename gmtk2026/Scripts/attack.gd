class_name Attack
extends Area2D

@export var attackData : AttackData

func _ready():
	area_entered.connect(_on_area_entered)
	set_deferred("monitoring", true)

func _on_area_entered(area):
	if area is HurtBoxComponent:
		print("goy")
		var hurtBox = area as HurtBoxComponent
		attackData.attack_position = global_position
		hurtBox.damage(attackData)
