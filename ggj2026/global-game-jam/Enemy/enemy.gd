extends RigidBody2D
@export var player: CharacterBody2D
@export var movespeed : float = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance: Vector2 = global_position - player.global_position
	var dir: Vector2 = distance.normalized()
	if distance.length_squared() > 25:
		position += delta * movespeed * -dir
	
