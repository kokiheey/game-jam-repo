extends Node

@onready var PLAYER : CharacterBody2D = $Player
@onready var SHIPWAYPOINT : Sprite2D = $ShipWaypoint
@onready var BOX_WAYPOINT : Sprite2D = $BoxWaypoint
@onready var BOX : Box = $Box
@onready var PAUSE_MENU : Control = $CanvasLayer/PauseMenu

@onready var tutorial = $Tutorial

var pickedUpBox : bool = false
var enteredShip : bool = false
var paused : bool = false

func _ready() -> void:
	SHIPWAYPOINT.TARGET_POSITION = Vector2(0, 0)
	BOX_WAYPOINT.TARGET_POSITION = $BlackHole.global_position
	BOX.hide()
	tutorial.start()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		pause_menu()

func _on_ship_body_entered(body: Node2D) -> void:
	if pickedUpBox:
		tutorial.shouldStop = false
		tutorial.next_step()
	enteredShip = true


func _on_ship_body_exited(body: Node2D) -> void:
	enteredShip = false

func _on_box_picked_up() -> void:
	pickedUpBox = true
	BOX_WAYPOINT.TARGET_POSITION = Vector2.ZERO

func _on_black_hole_trigger_body_entered(body: Node2D) -> void:
	BOX.show()
	BOX_WAYPOINT.TARGET_POSITION = BOX.global_position
	
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
