extends State
class_name WaveAttack

@export var AttackWindup: float = 2.0
@export var AttackWindDown: float = 1.0
func Enter():
	#Play windup animation
	
	var attack_windup_timer := Timer.new()
	attack_windup_timer.one_shot = true
	attack_windup_timer.wait_time = AttackWindup
	attack_windup_timer.timeout.connect(Attack)
	add_child(attack_windup_timer)
	attack_windup_timer.start()

func Attack():
	#Play attack animation and spawn attack
	var attack_winddown_timer := Timer.new()
	attack_winddown_timer.one_shot = true
	attack_winddown_timer.wait_time = AttackWindDown
	attack_winddown_timer.timeout.connect(Switch)
	add_child(attack_winddown_timer)
	attack_winddown_timer.start()
	
	
func Switch():
	StateTransitioned.emit("Follow")
