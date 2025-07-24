extends State
class_name Follow

@export var boss: Boss
@export var minimum_distance: float
@onready var player := boss.getTargetedPlayer()
var targetPosition: Vector2


func Enter():
	pass
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
