extends CharacterBody2D

@export var shipColor : Color = Color("ff0000ff")
@export var acc: float = 700
@export var capSpeed: float = 500
@export var drag: float = 0.003
@export var rotationSpeed: float = 10
@export var gravComponent : GravityComponent
@export var sideGravityStrengh : float = 0.4
@export var recoil : float = 300.0

@export var Player : CharacterBody2D

@onready var shipSprite : Polygon2D = $Polygon2D

@export var ANGLE_DIFF : Vector2 = Vector2(0, 0)

@onready var healthComp : HealthComponent = $HealthComponent
@onready var attackComp : Attack = $Attack

func _on_attacked_enemy(area : HurtBoxComponent):
	velocity += recoil * (global_position - area.global_position).normalized()

func _ready():
	attackComp.attackedEnemy.connect(_on_attacked_enemy)
	healthComp.died.connect(func():
		queue_free()
	)
	shipSprite.color = shipColor
	add_to_group("enemy")

func _physics_process(delta):
	print("Location : ", global_position)
	#AKO JE PLAYER BLIZU SAFE ZONA UKLJUCI SAFE ZONE COLLISION ZA ENEMY-e
	if Player.global_position.length() > 300:
		set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)
	
	if Player.global_position.distance_to(global_position) > 500:
		$HurtBoxComponent.vulnerable = false
	else:
		$HurtBoxComponent.vulnerable = true
	
	var angle = (Player.global_position + ANGLE_DIFF - global_position).angle()
	
	rotation = lerp_angle(rotation, angle, rotationSpeed * delta)
	
	var acceleration : Vector2 = Vector2.ZERO
	var forward = Vector2.RIGHT.rotated(rotation)
	
	acceleration += acc * forward
	
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
