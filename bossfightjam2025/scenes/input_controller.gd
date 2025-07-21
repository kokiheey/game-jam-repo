extends Node
class_name InputController

signal primary()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			primary.emit()
