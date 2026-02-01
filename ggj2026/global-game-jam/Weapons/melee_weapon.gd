class_name MeleeWeapon
extends Weapon

@export var hit_force : float
@export var attack_damage: float = 5.0
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var hit_box : Area2D = $Hitbox

func _use():
	#spawn hitbox
	anim.play("attack")
	hit_box.area_entered.connect(attack)

func attack(other: Area2D):
	if other is HitboxComponent:
		var attack := Attack.new()
		attack.attack_damage = attack_damage
		other.damage(attack)
	
