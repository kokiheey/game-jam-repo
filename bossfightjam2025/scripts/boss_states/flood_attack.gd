extends State
class_name FloodAttack

@export var attack_windup: float = 2.0
@export var attack_winddown: float = 1.0

var flood_attack = preload("res://scenes/boss/flood.tscn")

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
	var attack = flood_attack.instantiate()
	attack.global_position = Vector2(0, 0)
	get_tree().current_scene.add_child(attack)
	pass
