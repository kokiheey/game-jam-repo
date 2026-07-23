extends CharacterBody2D

@export var acc: float = 700
@export var capSpeed: float = 500
@export var drag: float = 500
@export var rotationSpeed: float = 10
@export var gravComponent : GravityComponent
func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var angle = (mouse_pos - global_position).angle()

	rotation = lerp_angle(rotation, angle, rotationSpeed * delta)
	
	var acceleration : Vector2 = Vector2.ZERO
	var forward = Vector2.RIGHT.rotated(rotation)
	if Input.is_action_pressed("moveForward"):
		acceleration += acc * forward
		if velocity.length() > capSpeed:
			velocity = velocity.normalized() * capSpeed
	else:
		if velocity.length() > 0:
			velocity = velocity.move_toward(Vector2.ZERO, drag * delta)
	
	acceleration += gravComponent.acceleration
	
	velocity += acceleration * delta
	move_and_slide()
