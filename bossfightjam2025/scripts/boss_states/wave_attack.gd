extends State
class_name WaveAttack

@export var attack_windup: float = 2.0
@export var attack_winddown: float = 1.0

@onready var boss: Boss = get_parent().get_parent()

var wave_attack = preload("res://scenes/wave.tscn")

var attack_windup_timer: Timer
var attack_winddown_timer: Timer

func Enter():
	#Play windup animation
	
	attack_windup_timer = Timer.new()
	attack_windup_timer.one_shot = true
	attack_windup_timer.wait_time = attack_windup
	attack_windup_timer.timeout.connect(Attack)
	add_child(attack_windup_timer)
	attack_windup_timer.start()

func Attack():
	#Play attack animation and spawn attack
	var attack = wave_attack.instantiate()
	attack.global_position = boss.global_position
	get_tree().current_scene.add_child(attack)
	
	print("Spawned wave: ", attack.name)
	attack.tree_exited.connect(func(): print("Wave exited tree"))
	
	attack_winddown_timer = Timer.new()
	attack_winddown_timer.one_shot = true
	attack_winddown_timer.wait_time = attack_winddown
	attack_winddown_timer.timeout.connect(Switch)
	add_child(attack_winddown_timer)
	attack_winddown_timer.start()
	
	
func Switch():
	StateTransitioned.emit(name, "Follow")
