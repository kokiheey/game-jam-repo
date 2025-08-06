extends Area2D

@export var dialogue_key : String = ""
var area_active : bool = false

func _input(event):
	if area_active and event.is_action_pressed("interact"):
		SignalBus.emit_signal("display_dialogue", dialogue_key)

func _on_area_entered(area: Area2D) -> void:
	area_active = true
	print(area_active)

func _on_area_exited(area: Area2D) -> void:
	area_active = false
	print(area_active)
