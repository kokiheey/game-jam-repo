extends Node2D

var velocity := Vector2.ZERO
var last_parent_pos := Vector2.ZERO
var angle_velocity := 0.0
@export var stiffness := 16.0  # how stiff the "spring" is
@export var damping := 200.0    # resist swing

func _ready():
	last_parent_pos = global_position

func perpendicular(v: Vector2) -> Vector2:
	return Vector2(-v.y, v.x)

var gravity_strength := 20.0  # tweak for effect

func _process(delta):
	var parent = get_parent()
	var parent_velocity = parent.velocity

	var offset = position.rotated(rotation)
	var inertia_force = perpendicular(offset.normalized()).dot(parent_velocity) * offset.length()

	angle_velocity += inertia_force * delta * 0.1

	# Gravity torque pulls rotation to 0 (down)
	angle_velocity -= rotation * gravity_strength * delta

	angle_velocity -= rotation * stiffness * delta
	angle_velocity *= exp(-damping * delta)
	angle_velocity = clamp(angle_velocity, -10, 10)

	rotation += angle_velocity * delta
