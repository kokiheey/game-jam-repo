extends State
class_name player_airborne
@export var anim_s: AnimatedSprite2D
@onready var player: PlayerCharacter = get_parent().get_parent()
var input: InputController
func Enter():
	anim_s.play("rising")
	input = get_node("/root/Main/InputController")
	if input:
		input.axis.connect(move)
		input.attack.connect(attack)

func Exit():
	if input:
		input.axis.disconnect(move)
		input.attack.disconnect(attack)

func Update():
	if player.velocity.y > 100:
		if player.velocity.x != 0:
			anim_s.play("falling_side")
		else:
			anim_s.play("falling_idle")
	elif player.velocity.y < -100:
		anim_s.play("rising")
	else: anim_s.play("floating")
	if player.is_on_floor():
		StateTransitioned.emit(name, "player_idle")

func move(direction: Vector2):
	player.velocity.x = direction.x * player.SPEED

func attack():
	StateTransitioned.emit(name, "player_attack")
