extends Node
class_name MovementComponent

signal dash_finished

@export var SPEED = 300.0
@export var ACCELERATION = 4000.0
@export var FRICTION = 4000.0
@export var DASH_SPEED = 1000.0
@export var DASH_DURATION = 0.2
@export var DASH_COOLDOWN = 0.5

var velocity : Vector2 = Vector2.ZERO
var input_vector : Vector2 = Vector2.ZERO
var last_move_direction : Vector2 = Vector2.ZERO
var is_dashing : bool = false
var can_dash : bool = true

func set_input_vector(direction: Vector2) -> void:
	input_vector = direction

func process_movement(player: CharacterBody2D, delta: float) -> void:
	if is_dashing:
		player.velocity = velocity
		player.move_and_slide()
		return
	
	if input_vector == Vector2.ZERO:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	else:
		last_move_direction = input_vector
		player.velocity = player.velocity.move_toward(input_vector.normalized() * SPEED, ACCELERATION * delta)
	
	player.move_and_slide()


func dash():
	is_dashing = true
	can_dash = false
	velocity = last_move_direction * DASH_SPEED
	_start_dash_timer()

func _start_dash_timer():
	await get_tree().create_timer(DASH_DURATION).timeout
	is_dashing = false
	emit_signal("dash_finished")
	_start_dash_cooldown()

func _start_dash_cooldown():
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true
