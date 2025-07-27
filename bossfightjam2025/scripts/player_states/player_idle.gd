extends State
class_name player_idle
@export var anim_s: AnimatedSprite2D
@onready var player: PlayerCharacter = get_parent().get_parent()
@onready var walk_sfx: AudioStreamPlayer = $"../../Walk"

var input: InputController

func _ready():
	walk_sfx.bus = "SFX"

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
		if not input.primary_up.is_connected(endJump): input.primary_up.connect(endJump)


func jump():
	if player.is_on_floor():
		walk_sfx.stop()
		player.velocity.y = player.JUMP_VELOCITY
		StateTransitioned.emit(name, "player_airborne")

func endJump():
	if not player.is_on_floor() and player.velocity.y < 0:
		player.velocity.y /= 1.4

func Update():
	if player.velocity.x != 0:
		walk_sfx.pitch_scale = randf_range(0.8, 1.2)
		if not walk_sfx.playing: walk_sfx.play()
		anim_s.play("run")
	else: 
		anim_s.play("idle")
		walk_sfx.stop()

func move(direction: Vector2):
	player.velocity.x = direction.x * player.SPEED
	
func attack():
	StateTransitioned.emit(name, "player_attack")
