extends Node2D

@export var MISSION_TIME : float = 20

@onready var PAUSE_MENU    : Control = $GUI/PauseMenu
@onready var GAME_UI       : Control = $GUI/GameUI
@onready var MISSION_TIMER : Timer   = $MissionTimer

var paused : bool = false

func _ready() -> void:
	MISSION_TIMER.wait_time = MISSION_TIME
	MISSION_TIMER.start()

func _process(delta: float) -> void:
	print(MISSION_TIMER.time_left)
	GAME_UI.update_time(MISSION_TIMER.time_left)
	
	if Input.is_action_just_pressed("Pause"):
		pause_menu()


func pause_menu():
	paused = !paused
	if paused:
		PAUSE_MENU.show()
		Engine.time_scale = 0
	else:
		PAUSE_MENU.hide()
		Engine.time_scale = 1
