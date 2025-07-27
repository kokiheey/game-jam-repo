extends State
class_name player_attack
@export var anim_s: AnimatedSprite2D
@export var lifespan: float = 0.4
@onready var attack_sfx:AudioStreamPlayer = $"../../Attack"
var attack_box := preload("res://scenes/player_attack_box.tscn")

func _ready():
	attack_sfx.bus = "SFX"

func Enter():
	anim_s.play("attack")
	attack_sfx.pitch_scale = randf_range(0.8, 1.2)
	if not attack_sfx.playing: attack_sfx.play()
	var attack = attack_box.instantiate()
	attack.position = Vector2.ZERO
	get_parent().get_parent().add_child(attack)
	var death:Timer = Timer.new()
	death.one_shot = true
	death.wait_time = lifespan
	add_child(death)
	death.start()
	await death.timeout
	attack.queue_free()
	StateTransitioned.emit(name, "player_idle")

func Exit():
	attack_sfx.stop()
