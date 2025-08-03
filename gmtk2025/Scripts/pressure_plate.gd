extends Area2D

@export var toggles: Array[Toggle]

@onready var sprite : Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	sprite.scale *= 0.88
	if body is CharacterBody2D: for tg in toggles:
		tg.toggle_on(false)

func _on_body_exited(body: Node2D) -> void:
	sprite.scale = Vector2.ONE
	if body is CharacterBody2D : for tg in toggles:
		tg.toggle_off(false)

func _on_area_entered(area: Area2D) -> void:
	sprite.scale *= 0.88
	for tg in toggles:
		tg.toggle_on(false)

func _on_area_exited(area: Area2D) -> void:
	sprite.scale = Vector2.ONE
	for tg in toggles:
		tg.toggle_off(false)
