extends CharacterBody2D

@export var SPEED : float = 60

@onready var animationPlayer : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	if direction != Vector2.ZERO:
		_play_animation(direction)
	else:
		_stop_animation()

	velocity = direction * SPEED
	move_and_slide()

func _stop_animation():
	if animationPlayer.is_playing():
		animationPlayer.stop()
		animationPlayer.frame = 0

func _play_animation(direction: Vector2):
	var anim_name := ""

	if direction.x > 0:
		anim_name = "walk_right" 
	elif direction.x < 0:
		anim_name = "walk_left"
	elif direction.y > 0:
		anim_name = "walk_down"
	else:
		anim_name = "walk_up"

	if animationPlayer.animation != anim_name || !animationPlayer.is_playing():
		animationPlayer.play(anim_name)
		animationPlayer.frame = 1
