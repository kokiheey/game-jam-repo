extends Area2D

@export var dialogue_key : String = ""
var area_active : bool = false
var current_node_id : String = ""

func _ready() -> void:
	current_node_id = ""
	SignalBus.connect("dialogue_finish", Callable(self, "update_node_id"))

func _input(event):
	if current_node_id == "-1": return
	if area_active and event.is_action_pressed("interact"):
		SignalBus.emit_signal("display_dialogue", dialogue_key, current_node_id, self)

func update_node_id(caller, new_node_id):
	if caller == self:
		current_node_id = new_node_id

func _on_area_entered(area: Area2D) -> void:
	area_active = true
	print(area_active)

func _on_area_exited(area: Area2D) -> void:
	area_active = false
	print(area_active)
