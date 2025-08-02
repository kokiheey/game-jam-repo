extends StaticBody2D


@export var toggles: Array[Toggle]

func _on_area_2d_body_entered(body: Node2D) -> void:
	self.position.y += 1;
	for tg in toggles:
		tg.toggle()


func _on_area_2d_body_exited(body: Node2D) -> void:
	self.position.y -= 1;
	for tg in toggles:
		tg.toggle()
