extends RigidBody2D
@export var player: CharacterBody2D
@export var movespeed : float = 50
@onready var health = $health_component

signal death(position: Vector2)
func onDeath():
	death.emit(global_position)
	queue_free()

func _ready() -> void:
	health.dead.connect(onDeath)

func _process(delta: float) -> void:
	var distance: Vector2 = global_position - player.global_position
	var dir: Vector2 = distance.normalized()
	if distance.length_squared() > 25:
		position += delta * movespeed * -dir
	
