extends Node
@onready var input:InputController = $InputController
@onready var pause_menu = $PauseMenu
var paused: bool = false


func _ready():
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	input.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.hide()
	input.pause.connect(pauseMenu)

func pauseMenu():
	paused = not paused
	if paused:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()
