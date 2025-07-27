extends State
class_name player_idle
@export var anim_s: AnimatedSprite2D
@onready var player: PlayerCharacter = get_parent().get_parent()
var input: InputController
func Enter():
	if not player.is_on_floor():
		StateTransitioned.emit(name, "player_airborne")
	
	if(player.velocity.x != 0): anim_s.play("run")
	else: anim_s.play("idle")
	
	input = get_node("/root/Main/InputController")
	if input:
		if not input.primary.is_connected(jump): input.primary.connect(jump)
		if not input.axis.is_connected(move): input.axis.connect(move)
		if not input.attack.is_connected(attack): input.attack.connect(attack)


func jump():
	if player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
		StateTransitioned.emit(name, "player_airborne")

func Update():
	if(player.velocity.x != 0): anim_s.play("run")
	else: anim_s.play("idle")

func move(direction: Vector2):
	player.velocity.x = direction.x * player.SPEED
	
func attack():
	StateTransitioned.emit(name, "player_attack")
