extends Node2D

@onready var GAME_OVER_UI  : Control = $GUI/GameOver
@onready var PAUSE_MENU    : Control = $GUI/PauseMenu
@onready var GAME_UI       : Control = $GUI/GameUI
@onready var MISSION_TIMER : Timer   = $MissionTimer
@onready var PLAYER : CharacterBody2D = $Player
@onready var WAYPOINT : Sprite2D = $Waypoint
@onready var PARTICLES : GPUParticles2D = $GPUParticles2D

@export var MISSION_TIME : float = 1000
@export var celestialBodies : Array[PackedScene]
@export var CBtoSpawn : int = 10
@export var package : PackedScene

var currentPackage : Box
var activeBodies : Array[Node2D]


var carryingPackage : bool = false
var isGameOver : bool = false
var paused : bool = false

func _on_picked_up() -> void:
	WAYPOINT.TARGET_POSITION = Vector2(0, 0)
	carryingPackage = true


func _ready() -> void:
	MISSION_TIMER.wait_time = MISSION_TIME
	generate()
	MISSION_TIMER.start()

func generate():
	if(currentPackage != null):
		currentPackage.picked_up.disconnect(_on_picked_up)
	
	currentPackage = package.instantiate() as Box
	currentPackage.picked_up.connect(_on_picked_up)
	var randomDir : Vector2 = Vector2.RIGHT.rotated(randf_range(-PI, PI))
	currentPackage.global_position = PLAYER.global_position + randomDir * randf_range(200, 5000)
	WAYPOINT.TARGET_POSITION = currentPackage.global_position
	
	for body in activeBodies:
		body.queue_free()
	activeBodies.clear()
	
	for i in range(CBtoSpawn):
		var body = celestialBodies.pick_random().instantiate() as Node2D
		body.global_position = PLAYER.global_position + randomDir.rotated(randf_range(-PI/4, PI/4))*randf_range(200, 5000)
		call_deferred("add_child", body)
	call_deferred("add_child", currentPackage)
	
func _process(delta: float) -> void:
	PARTICLES.global_position = PLAYER.global_position

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




func _on_ship_body_entered(body: Node2D) -> void:
	if  body.is_in_group("player") and carryingPackage:
		currentPackage.queue_free()
		carryingPackage = false
		generate()
