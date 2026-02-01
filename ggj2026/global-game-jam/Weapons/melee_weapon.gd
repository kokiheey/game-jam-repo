class_name MeleeWeapon
extends Weapon

@export var damage : int
@export var hit_force : float

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var hit_box : Area2D = $Hitbox

func _use():
	anim.play("attack")
	
func  detect_hits():
	pass
