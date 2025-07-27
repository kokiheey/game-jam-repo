extends Node
@onready var input:InputController = $InputController
@onready var pause_menu = $PauseMenu
@onready var restart_menu = $RestartMenu
@onready var win_menu = $WinMenu

@onready var player = $player
@onready var boss = $Boss
var paused: bool = false
var dead: bool = false

func _ready():
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	input.process_mode = Node.PROCESS_MODE_ALWAYS
	restart_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.hide()
	restart_menu.hide()
	win_menu.hide()
	
	input.pause.connect(pauseMenu)
	player.Death.connect(Died)
	boss.boss_death.connect(Won)

func pauseMenu():
	paused = not paused
	if paused:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()

func Died():
	paused = true
	if paused:
		get_tree().paused = true
		restart_menu.show()
	else:
		get_tree().paused = false
		restart_menu.hide()

func Won():
	win_menu.show()
