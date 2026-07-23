extends CharacterBody2D

@export var acc: float = 700
@export var capSpeed: float = 500
@export var drag: float = 500
@export var rotationSpeed: float = 10

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var angle = (mouse_pos - global_position).angle()

	rotation = lerp_angle(rotation, angle, rotationSpeed * delta)

	if Input.is_action_pressed("moveForward"):
		var forward = Vector2.RIGHT.rotated(rotation)
		velocity += forward * acc * delta

		if velocity.length() > capSpeed:
			velocity = velocity.normalized() * capSpeed
	else:
		if velocity.length() > 0:
			velocity = velocity.move_toward(Vector2.ZERO, drag * delta)

	move_and_slide()
