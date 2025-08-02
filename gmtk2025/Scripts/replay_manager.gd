class_name ReplayManager
extends Node

@export var replay_toggles: Array[Toggle]
var toggle_data: Dictionary
var frames: int

func _ready():
	frames = 0
	for ob in get_tree().get_root().get_children():
		if ob is Toggle:
			var tg = ob as Toggle
			replay_toggles.append(tg)
			tg.on_toggled.connect(_on_toggled)

func _physics_process(delta: float):
	frames += 1
	
func _on_toggled(sender: Toggle):
	toggle_data[frames] = sender
