extends Area2D

@export var dialogue_keys : Array[String] = [""]
var area_active : bool = false
var dialogue_index : int = 0
var dialogue_size : int

func _ready() -> void:
	dialogue_index = 0
	dialogue_size = dialogue_keys.size()
	SignalBus.connect("dialogue_finish", Callable(self, "update_index"))

func _input(event):
	if area_active and event.is_action_pressed("interact"):
		SignalBus.emit_signal("display_dialogue", dialogue_keys[dialogue_index])

func update_index():
	dialogue_index = min(dialogue_index + 1, dialogue_size - 1)

func _on_area_entered(area: Area2D) -> void:
	area_active = true
	print(area_active)

func _on_area_exited(area: Area2D) -> void:
	area_active = false
	print(area_active)
