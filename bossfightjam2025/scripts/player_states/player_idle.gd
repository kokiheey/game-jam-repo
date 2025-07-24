extends State
class_name player_idle
@export var animP: AnimationPlayer
@onready var player: PlayerCharacter = get_parent().get_parent()
var input: InputController
func Enter():
	animP.play("idle")
	
	input = get_node("/root/Main/InputController")
	if input:
		input.primary.connect(jump)
		input.axis.connect(move)

func Exit():
	if input:
		input.primary.disconnect(jump)
		input.axis.disconnect(move)
	
func jump():
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY

func move(direction: Vector2):
	if(direction != Vector2.ZERO): animP.play("run")
	else: animP.play("idle")
	player.velocity.x = direction.x * player.SPEED
