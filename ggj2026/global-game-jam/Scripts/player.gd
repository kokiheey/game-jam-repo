extends CharacterBody2D
class_name PlayerController

@export var MOVE_SPEED := 400.0

var direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var move_direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1
	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		move_direction.y += 1
	
	direction = move_direction;
	velocity = move_direction.normalized() * MOVE_SPEED
	move_and_slide()
