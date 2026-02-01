extends Area2D

@export var interact_name : String = ""
@export var is_interactable : bool = true
@export var interaction_label : Label

func _ready() -> void:
	interaction_label.text = interact_name
	interaction_label.hide()

var interact: Callable = func():
	pass
