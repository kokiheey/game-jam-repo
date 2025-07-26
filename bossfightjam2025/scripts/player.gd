extends CharacterBody2D
class_name PlayerCharacter
@export var _sprite2D : AnimatedSprite2D

@export var SPEED := 300.0
@export var JUMP_VELOCITY := -400.0
@export var health := 10
@onready var input := get_node("/root/Main/InputController")
var invertedMaterial := preload("res://assets/materials/player_inverted.tres")
var inverted := false
signal Death

func _ready():
	input.change_phase.connect(_change_phase)
	if inverted:
		_sprite2D.material = invertedMaterial
		_sprite2D.material.set_shader_parameter("time", Time.get_ticks_msec())
	else:
		_sprite2D.material = null

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		Death.emit()

func _change_phase():
	inverted = not inverted
	if inverted:
		_sprite2D.material = invertedMaterial
		_sprite2D.material.set_shader_parameter("time", Time.get_ticks_msec())
	else:
		_sprite2D.material = null

func _physics_process(delta: float) -> void:
	if(velocity.x < 0):
		_sprite2D.flip_h = true
	else:
		_sprite2D.flip_h = false
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
