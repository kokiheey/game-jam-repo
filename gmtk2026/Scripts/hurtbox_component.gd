class_name HurtBoxComponent
extends Area2D

@export var healthComponent : HealthComponent
@export var invulnerabilityTime : float = 2.0
@export var team : int = 0
var vulnerable : bool = true
signal attackReceived(attackData : AttackData)

var invulnerabilityTimer : Timer


func _ready():
	
	invulnerabilityTimer = Timer.new()
	add_child(invulnerabilityTimer)
	invulnerabilityTimer.one_shot = true
	invulnerabilityTimer.timeout.connect(func(): 
		vulnerable = true
	)
	set_deferred("monitorable", true)

func damage(attackData : AttackData):
	if not vulnerable:
		return
	vulnerable = false
	invulnerabilityTimer.start(invulnerabilityTime)
	attackReceived.emit(attackData)
	if healthComponent:
		healthComponent.take_damage(attackData)
