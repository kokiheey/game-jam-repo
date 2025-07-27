extends State
class_name Vulnerable

var strings: Array[BossString]
@onready var string_holder: StaticBody2D = $"../../string_holder"
@onready var boss: Boss = $"../.."
@export var initial_velocity: float = 100.0
@export var sctime:float = 1.0
var string_cut:bool = false

@onready var hurt_sfx: AudioStreamPlayer = $"../../Hurt"

func Enter():
	string_cut = false
	var down_tween = create_tween()
	down_tween.tween_property(boss, "position", Vector2(boss.position.x, 600), sctime) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN_OUT)
func Exit():
	var down_tween = create_tween()
	down_tween.tween_property(boss, "position", Vector2(boss.position.x, 0), sctime) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN_OUT)

func _ready():
	for child in string_holder.get_children():
		if child is BossString:
			strings.append(child)
			child.Cut.connect(on_string_cut)
	boss.health = strings.size()

func on_string_cut(string: BossString):
	if string_cut: return
	hurt_sfx.play()
	string.die()
	boss.health -= 1
	boss.check_state()
	string_cut = true
	StateTransitioned.emit(name, "Follow")
