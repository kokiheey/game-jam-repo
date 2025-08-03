class_name ReplayManager
extends Node

@export var restart_time: float = 5.0


@export var replay_toggles: Array[Toggle]
@export var player: CharacterBody2D
@onready var player_sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
@onready var objects = $"../Objects"
@export var spawn_position: Node2D
@export var MAX_GHOSTS: int = 3
var toggle_data_on: Dictionary = {}
var toggle_data_off: Dictionary = {}

var frames: int
var time_label_scene = preload("res://Scenes/time_label.tscn")
var time_label: Label
var replay_timer: Timer

var ghost_prefab = preload("res://Scenes/player_sprite.tscn")
var ghosts_position: Dictionary = {}
var ghosts_animations: Dictionary = {}

var ghosts: int
var ghost_bodies: Array[AnimatedSprite2D]
func _ready():
	ghosts = 0
	frames = 0
	
	for index in MAX_GHOSTS:
		var new_ghost = ghost_prefab.instantiate()
		ghost_bodies.append(new_ghost)
		new_ghost.global_position = spawn_position.position
		ghost_bodies[index].hide()
		objects.add_child(new_ghost)
	for ob in objects.get_children():
		if ob is Toggle:
			var tg = ob as Toggle
			replay_toggles.append(tg)
			print("sigma")
			tg.on_toggled_on.connect(_on_toggled_on)
			tg.on_toggled_off.connect(_on_toggled_off)
	replay_timer = Timer.new()
	replay_timer.wait_time = restart_time
	replay_timer.one_shot = false
	replay_timer.timeout.connect(replay)
	add_child(replay_timer)
	replay_timer.start()
	time_label = time_label_scene.instantiate()
	time_label.text = str("%.0f" % ceil(replay_timer.time_left))
	add_child(time_label)
	

func _physics_process(delta: float):
	if frames == 10:
		for tg in replay_toggles:
			tg.on_toggles = 0
	frames += 1
	time_label.text = str("%.0f" % ceil(replay_timer.time_left))
	if not toggle_data_on.has(ghosts):
		toggle_data_on[ghosts] = {}
	if not toggle_data_off.has(ghosts):
		toggle_data_off[ghosts] = {}
	if not ghosts_position.has(ghosts): 
		ghosts_position[ghosts] = {}
	if not ghosts_animations.has(ghosts):
		ghosts_animations[ghosts] = {}
		
		
	
		
	ghosts_animations[ghosts][frames] = player_sprite.animation
	ghosts_position[ghosts][frames] = player.global_position
	
	

	for i in MAX_GHOSTS:
		if i == ghosts: 
			ghost_bodies[i].hide()
			continue
		if not ghosts_position.has(i):
			ghost_bodies[i].hide()
			continue
		ghost_bodies[i].modulate.a = 1.0 - (((ghosts - i + MAX_GHOSTS) % MAX_GHOSTS) / float(MAX_GHOSTS))
		if i != ghosts: ghost_bodies[i].show()
		if ghosts_position[i].has(frames): 
			ghost_bodies[i].global_position = ghosts_position[i][frames]
		if ghosts_animations[i].has(frames) and frames >= 2:
			if ghosts_animations[i][frames] != ghosts_animations[i][frames-1]:
				if ghosts_position[i][frames] != ghosts_position[i][frames-1]:
					ghost_bodies[i].play(ghosts_animations[i][frames])
			if ghosts_position[i][frames] == ghosts_position[i][frames-1]:
				ghost_bodies[i].stop()
				ghost_bodies[i].frame = 1
		if toggle_data_off[i].has(frames):
			toggle_data_off[i][frames].toggle_off(true)
			print("ghost ", i, " off on ", frames)
		if toggle_data_on[i].has(frames):
			toggle_data_on[i][frames].toggle_on(true)
			print("ghost ", i, " on on ", frames)

func _on_toggled_on(sender: Toggle):
	if frames < 5:
		toggle_data_on[(ghosts - 1 + MAX_GHOSTS) % MAX_GHOSTS][frames] = sender
		print("record on ", (ghosts - 1 + MAX_GHOSTS) % MAX_GHOSTS, " ", frames)
	else:
		toggle_data_on[ghosts][frames] = sender
		print("record on ", ghosts, " ", frames)

func _on_toggled_off(sender: Toggle):
	if frames < 5:
		toggle_data_off[(ghosts - 1 + MAX_GHOSTS) % MAX_GHOSTS][frames] = sender
		print("record off ", (ghosts - 1 + MAX_GHOSTS) % MAX_GHOSTS, " ", frames)
	else:
		toggle_data_off[ghosts][frames] = sender
		print("record off ", ghosts, " ", frames)

func replay():
	frames = 0
	ghosts += 1
	ghosts %= MAX_GHOSTS
	
	if toggle_data_off.has(ghosts):
		if toggle_data_off[ghosts].has(2): toggle_data_off[ghosts][2].toggle_off(true)
	if toggle_data_on.has(ghosts):
		if toggle_data_on[ghosts].has(2): toggle_data_on[ghosts][2].toggle_on(true)
	
	toggle_data_off[ghosts] = {}
	toggle_data_on[ghosts] = {}
	ghosts_position[ghosts] = {}
	ghosts_animations[ghosts] = {}
	
	
	player.global_position = spawn_position.global_position
	
	#for tg in replay_toggles:
	#	tg.toggle_off(true)
