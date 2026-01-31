extends Node
class_name InputController

signal attack_requested
signal dash_requested

var direction : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right","move_up", "move_down")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		emit_signal("attack_requested")
	elif event.is_action_pressed("dash"):
		emit_signal("dash_requested")
