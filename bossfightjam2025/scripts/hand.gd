extends Node2D

var prev_velocity: Vector2
var angle_velocity := 0.0
@onready var parent := get_parent()
@export var stiffness := 16.0  # how stiff the "spring" is
@export var damping := 1.0    # resist swing
@export var gravity := 100.0
@export var mass := 1000.0

func perpendicular(v: Vector2) -> Vector2:
	return Vector2(-v.y, v.x)

func _ready():
	prev_velocity = parent.velocity

func _process(delta):
	var parent_velocity = parent.velocity
	var p_acceleration = (parent_velocity.x - prev_velocity.x) / delta
	var inertia = p_acceleration / mass

	angle_velocity += inertia * delta
	
	angle_velocity -= rotation * gravity * delta
	angle_velocity = lerp(angle_velocity, 0.0, delta*damping)
	rotation += angle_velocity * delta
