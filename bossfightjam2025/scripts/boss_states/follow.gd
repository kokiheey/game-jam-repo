extends State
class_name Follow

@export var boss: Boss
@export var minimum_distance: float
@export var available_attacks: Array[State]
@onready var player := boss.getTargetedPlayer()

var targetPosition: Vector2



func Enter():
	#play Idle animation
	var transitionTimer := Timer.new()
	transitionTimer.wait_time = randf_range(1.0, 3.0)
	transitionTimer.one_shot = true
	transitionTimer.timeout.connect(startAttack)
	add_child(transitionTimer)
	transitionTimer.start()
	
func Exit():
	pass
func Update():
	if !player:
		player = boss.getTargetedPlayer()
	targetPosition = Vector2(player.position.x, boss.position.y)
	var direction :=  targetPosition - boss.position
	if direction.length_squared() < minimum_distance * minimum_distance:
		direction = Vector2.ZERO
	direction = direction.normalized()
	boss.velocity = direction * boss.SPEED
	boss.move_and_slide()

func startAttack():
	var attack_state = available_attacks.pick_random()
	StateTransitioned.emit(name, attack_state.name)
