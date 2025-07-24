extends CharacterBody2D
class_name PlayerCharacter
@export var _sprite2D : Sprite2D

@export var SPEED := 300.0
@export var JUMP_VELOCITY := -400.0


func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

func move(direction: Vector2):
	velocity.x = direction.x * SPEED
	


func _physics_process(delta: float) -> void:
	if(velocity.x < 0):
		_sprite2D.flip_h = true
	else:
		_sprite2D.flip_h = false
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
