extends Area2D

@export var toggles: Array[Toggle]

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	sprite.frame = 1
	if body is CharacterBody2D: for tg in toggles:
		tg.toggle_on(false)

func _on_body_exited(body: Node2D) -> void:
	sprite.frame = 0
	if body is CharacterBody2D : for tg in toggles:
		tg.toggle_off(false)

func _on_area_entered(area: Area2D) -> void:
	if not area.get_parent() is Box and  area.get_parent().name != "PlayerSprite":
		return
	sprite.frame = 1
	if area.get_parent() is Box and area.name == "Area2D":
		for tg in toggles:
			tg.toggle_on(false)

func _on_area_exited(area: Area2D) -> void:
	if not area.get_parent() is Box and  area.get_parent().name != "PlayerSprite":
		return 
	sprite.frame = 0
	if area.get_parent() is Box and area.name == "Area2D": 
		for tg in toggles:
			tg.toggle_off(false)
