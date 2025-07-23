extends State
class_name Follow

@export var boss: Boss
@onready var player := boss.getTargetedPlayer()
var targetPosition : Vector2


func Enter():
	pass
func Exit():
	pass
func Update():
	if !player:
		player = boss.getTargetedPlayer()
	targetPosition = Vector2(player.position.x, boss.position.y)
	var direction :=  targetPosition - boss.position
	direction = direction.normalized()
	boss.velocity = direction * boss.SPEED
	print("kys nigga")
	boss.move_and_slide()
	
func _ready():
	on_enter = Enter
	on_exit = Exit
	on_update = Update
