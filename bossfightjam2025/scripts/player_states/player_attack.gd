extends State
class_name PlayerAttack
@export var anim_s: AnimatedSprite2D
func Enter():
	anim_s.play("attack")
	
