extends Node2D

@export var MISSION_TIME : float = 1000

@onready var GAME_OVER_UI  : Control = $GUI/GameOver
@onready var PAUSE_MENU    : Control = $GUI/PauseMenu
@onready var GAME_UI       : Control = $GUI/GameUI
@onready var MISSION_TIMER : Timer   = $MissionTimer
@onready var PLAYER : CharacterBody2D = $Player

@export var celestialBodies : Array[PackedScene]
@export var CBtoSpawn : int = 10
@export var package : PackedScene
var activeBodies : Array[Node2D]

var isGameOver : bool = false
var paused : bool = false

func _ready() -> void:
	MISSION_TIMER.wait_time = MISSION_TIME
	generate()
	MISSION_TIMER.start()
	
func generate():
	var pkg = package.instantiate() as Node2D
	var randomDir : Vector2 = Vector2.RIGHT.rotated(randf_range(-PI, PI))
	pkg.global_position = PLAYER.global_position + randomDir * randf_range(200, 5000)
	for body in activeBodies:
		body.queue_free()
	activeBodies.clear()
	
	for i in range(CBtoSpawn):
		var body = celestialBodies.pick_random().instantiate() as Node2D
		body.global_position = PLAYER.global_position + randomDir.rotated(randf_range(-PI/4, PI/4))*randf_range(200, 5000)
		add_child(body)
	add_child(pkg)
	
func _process(delta: float) -> void:
	if isGameOver : 
		return
	
	GAME_UI.update_time(MISSION_TIMER.time_left)
	
	if Input.is_action_just_pressed("Pause"):
		pause_menu()

func pause_menu():
	paused = !paused
	pause_game(paused)
	
	if paused:
		PAUSE_MENU.show()
	else:
		PAUSE_MENU.hide()

func pause_game(pause : bool):
	if pause:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1

# GAME OVER - kada istekne timer
func _on_mission_timer_timeout() -> void:
	isGameOver = true
	pause_game(true)
	GAME_OVER_UI.show()
