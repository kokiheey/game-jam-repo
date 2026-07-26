class_name Attack
extends Area2D
signal attackedEnemy(area: HurtBoxComponent)

@export var attackData : AttackData
@export var team : int = 0
func _ready():
	#area_entered.connect(_on_area_entered)
	set_deferred("monitoring", true)

func _physics_process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	
	for area in areas:
		if area is HurtBoxComponent:
			var hurtBox = area as HurtBoxComponent
			if not team & hurtBox.team:
				attackedEnemy.emit(hurtBox)
				attackData.attack_position = global_position
				hurtBox.damage(attackData)


#func _on_area_entered(area):
#	if area is HurtBoxComponent:
#		var hurtBox = area as HurtBoxComponent
#		if not team & hurtBox.team:
#			attackData.attack_position = global_position
#			hurtBox.damage(attackData)
