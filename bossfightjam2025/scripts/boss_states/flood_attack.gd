extends State
class_name FloodAttack

@export var attack_windup: float = 2.0
@export var attack_winddown: float = 1.0

@onready var boss: Boss = get_parent().get_parent()
#Mozda kasnije koristiti za windup animaciju
@onready var string_holder: StaticBody2D = get_parent().get_parent().get_node("string_holder")
var flood_attack = preload("res://scenes/boss/flood.tscn")

var attack_windup_timer: Timer
var attack_winddown_timer: Timer

func Enter():
	#Play windup animation
	attack_windup_timer = Timer.new()
	attack_windup_timer.one_shot = true
	attack_windup_timer.wait_time = attack_windup
	attack_windup_timer.timeout.connect(AttackStart)
	add_child(attack_windup_timer)
	attack_windup_timer.start()

func AttackStart():
	#Play attack animation and spawn attack
	var attack = flood_attack.instantiate()
	attack.attack_end.connect(AttackEnd)
	attack.global_position = Vector2(0, 0)
	get_tree().current_scene.add_child(attack)

func AttackEnd():
	attack_winddown_timer = Timer.new()
	attack_winddown_timer.one_shot = true
	attack_winddown_timer.wait_time = attack_winddown
	attack_winddown_timer.timeout.connect(Switch)
	add_child(attack_winddown_timer)
	attack_winddown_timer.start()

func Switch():
	StateTransitioned.emit(name, "Follow")
