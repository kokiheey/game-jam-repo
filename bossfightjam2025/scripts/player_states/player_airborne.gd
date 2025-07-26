extends State
class_name player_airborne
@export var anim_s: AnimatedSprite2D
@onready var player: PlayerCharacter = get_parent().get_parent()
var input: InputController
func Enter():
	#animP.play("rising")
	input = get_node("/root/Main/InputController")
	if input:
		input.axis.connect(move)

func Exit():
	if input:
		input.axis.disconnect(move)

func _process(delta: float):
	if player.velocity.y > 0:
		#anim_s.play("falling")
		print("falling")
	if player.is_on_floor():
		StateTransitioned.emit(name, "player_idle")

func move(direction: Vector2):
	player.velocity.x = direction.x * player.SPEED
