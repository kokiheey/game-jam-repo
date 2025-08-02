class_name ReplayManager
extends Node

@export var replay_toggles: Array[Toggle]
@export var player: CharacterBody2D
@export var spawn_position: Node2D
@export var MAX_GHOSTS: int = 2
var toggle_data: Dictionary
var frames: int

var ghost_prefab = preload("res://Scenes/player_sprite.tscn")
var ghosts_position: Dictionary
var ghosts: int
var ghost_bodies: Array[AnimatedSprite2D]
func _ready():
	ghosts = 0
	
	frames = 0
	for ob in get_tree().get_root().get_children():
		if ob is Toggle:
			var tg = ob as Toggle
			replay_toggles.append(tg)
			tg.on_toggled.connect(_on_toggled)

func _physics_process(delta: float):
	frames += 1
	if toggle_data.has(frames):
		toggle_data[frames].toggle()
	
	ghosts_position[ghosts][frames] = player.global_position
	for i in ghost_bodies.size():
		ghost_bodies[i].global_position = ghosts_position[i][frames]
	
func _on_toggled(sender: Toggle):
	toggle_data[frames] = sender

func replay():
	frames = 0
	ghosts += 1
	var new_ghost = ghost_prefab.instantiate()
	ghost_bodies.append(new_ghost)
	new_ghost.global_position = spawn_position.position
	get_tree().get_root().add_child(new_ghost)
	
	
	for tg in replay_toggles:
		tg.toggled = false
		tg.update()
