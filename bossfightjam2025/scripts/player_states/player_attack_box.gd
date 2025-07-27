extends Area2D
class_name PlayerAttackShape


func _ready():
	body_entered.connect(tryAttack)
	
	
func tryAttack(body: Node):
	if body.get_parent() is BossString:
		var string: BossString = body.get_parent() as BossString
		string.cut()
