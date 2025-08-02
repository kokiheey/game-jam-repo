extends Area2D

@export var toggles: Array[Toggle]

func _on_body_entered(body: Node2D) -> void:
	position.y += 1;
	for tg in toggles:
		tg.toggle()

func _on_body_exited(body: Node2D) -> void:
	position.y -= 1;
	for tg in toggles:
		tg.toggle()
