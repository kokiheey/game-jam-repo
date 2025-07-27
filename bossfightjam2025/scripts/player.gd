extends CharacterBody2D
class_name PlayerCharacter
@export var _sprite2D : AnimatedSprite2D

@export var SPEED := 400.0
@export var JUMP_VELOCITY := -600.0
@onready var health : int = MaxHealth
@export var MaxHealth : int = 10
@export var invincibleTime : float = 1

@onready var input := get_node("/root/Main/InputController")
var invertedMaterial := preload("res://assets/materials/player_inverted.tres")
var inverted := false
signal Death

var _invicibleTimer : Timer
var visible_state : bool = true
var isInvincible : bool = false

func _ready():
	input.change_phase.connect(_change_phase)
	if inverted:
		_sprite2D.material = invertedMaterial
		_sprite2D.material.set_shader_parameter("time", Time.get_ticks_msec())
	else:
		_sprite2D.material = null

func take_damage(damage: int):
	if isInvincible: 
		return
	health -= damage
	if health <= 0:
		Death.emit()
	else:
		isInvincible = true
		visible_state = true
		DoInvincibility(invincibleTime)

func DoInvincibility(time: float):
	if(time < 0.01):
		isInvincible = false
		return
	modulate = Color(3,3,3)
	await get_tree().create_timer(time/2).timeout
	modulate = Color.WHITE
	await get_tree().create_timer(time/2).timeout
	DoInvincibility(time/2)

func _change_phase():
	inverted = not inverted
	if inverted:
		_sprite2D.material = invertedMaterial
		_sprite2D.material.set_shader_parameter("time", Time.get_ticks_msec())
	else:
		_sprite2D.material = null

func _process(delta: float) -> void:
	if(velocity.x < 0):
		_sprite2D.flip_h = true
	else:
		_sprite2D.flip_h = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
