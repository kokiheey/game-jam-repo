extends Area2D

@export var toggles: Array[Toggle]

@onready var sprite : Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	sprite.scale *= 0.94
	for tg in toggles:
		tg.toggle()


func _on_body_exited(body: Node2D) -> void:
	sprite.scale = Vector2.ONE
	for tg in toggles:
		tg.toggle()
