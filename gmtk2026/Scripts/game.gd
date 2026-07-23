extends Node2D

@onready var PAUSE_MENU = $GUI/PauseMenu

var paused : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
