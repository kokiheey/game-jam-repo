extends Node2D

@export var MISSION_TIME : float = 5

@onready var GAME_OVER_UI  : Control = $GUI/GameOver
@onready var PAUSE_MENU    : Control = $GUI/PauseMenu
@onready var GAME_UI       : Control = $GUI/GameUI
@onready var MISSION_TIMER : Timer   = $MissionTimer

var isGameOver : bool = false
var paused : bool = false

func _ready() -> void:
	MISSION_TIMER.wait_time = MISSION_TIME
	MISSION_TIMER.start()

func _process(delta: float) -> void:
	if isGameOver : 
		return
	
	print(MISSION_TIMER.time_left)
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
