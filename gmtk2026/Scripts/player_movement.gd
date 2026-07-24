extends CharacterBody2D

@export var acc: float = 700
@export var capSpeed: float = 500
@export var drag: float = 0.003
@export var rotationSpeed: float = 10
@export var gravComponent : GravityComponent
@export var sideGravityStrengh : float = 0.4

func _ready():
	add_to_group("player")

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var angle = (mouse_pos - global_position).angle()

	rotation = lerp_angle(rotation, angle, rotationSpeed * delta)
	
	var acceleration : Vector2 = Vector2.ZERO
	var forward = Vector2.RIGHT.rotated(rotation)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_action_pressed("moveForward"):
		acceleration += acc * forward
		if velocity.length() > capSpeed:
			pass
			#velocity = velocity.normalized() * capSpeed
			#acceleration += acc * forward
	
		
	if velocity.length() > 0:
			velocity = velocity.move_toward(Vector2.ZERO, drag * delta * maxf(1000,velocity.length_squared()))
	if(gravComponent.acceleration != Vector2.ZERO):
		if(forward.angle_to(gravComponent.acceleration) > 0):
			#draw_line(position, position + 0.1 * gravComponent.acceleration.orthogonal(), Color.AQUA)
			acceleration += sideGravityStrengh * gravComponent.acceleration.orthogonal()
		else:
			acceleration += sideGravityStrengh * gravComponent.acceleration.orthogonal().reflect(gravComponent.acceleration.normalized())
		acceleration += gravComponent.acceleration * (1.0 + gravComponent.acceleration.dot(forward)\
		 / gravComponent.acceleration.length() / 1.25)
	
	# print("speed", velocity.length_squared())
	velocity += acceleration * delta
	move_and_slide()
