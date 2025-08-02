class_name ReplayManager
extends Node

@onready var objects = $"../Objects"
@export var replay_toggles: Array[Toggle]
@export var player: CharacterBody2D
@export var spawn_position: Node2D
@export var MAX_GHOSTS: int = 2
var toggle_data_on: Dictionary = {}
var toggle_data_off: Dictionary = {}
var frames: int

var ghost_prefab = preload("res://Scenes/player_sprite.tscn")
var ghosts_position: Dictionary = {}
var ghosts: int
var ghost_bodies: Array[AnimatedSprite2D]
func _ready():
	ghosts = 0
	frames = 0
	for ob in objects.get_children():
		if ob is Toggle:
			var tg = ob as Toggle
			replay_toggles.append(tg)
			print("sigma")
			tg.on_toggled_on.connect(_on_toggled_on)
			tg.on_toggled_off.connect(_on_toggled_off)

func _physics_process(delta: float):
	frames += 1
	if toggle_data_on.has(frames):
		toggle_data_on[frames].toggle_on(true)
	if toggle_data_off.has(frames):
		toggle_data_off[frames].toggle_off(true)
	
	if not ghosts_position.has(ghosts): 
		ghosts_position[ghosts] = {}
	ghosts_position[ghosts][frames] = player.global_position
	for i in ghost_bodies.size():
		if ghosts_position[i].has(frames): 
			ghost_bodies[i].global_position = ghosts_position[i][frames]
	
func _on_toggled_on(sender: Toggle):
	toggle_data_on[frames] = sender

func _on_toggled_off(sender: Toggle):
	toggle_data_off[frames] = sender

func replay():
	frames = 0
	ghosts += 1
	var new_ghost = ghost_prefab.instantiate()
	ghost_bodies.append(new_ghost)
	new_ghost.global_position = spawn_position.position
	get_tree().get_root().add_child(new_ghost)
	
	player.global_position = spawn_position.global_position
	for tg in replay_toggles:
		tg.toggle_off(true)


func _on_timer_timeout() -> void:
	replay()
