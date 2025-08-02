extends CharacterBody2D


const SPEED = 36.0
@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D

func _animation_process(direction: Vector2):
	var x : float = direction.x
	var y : float = direction.y

	if x == 0 and y == 0:
		animation_player.stop()
		animation_player.frame = 1
	elif x == 0:
		if y > 0: animation_player.play("down")
		else: animation_player.play("up")
	elif y == 0:
		if x > 0: animation_player.play("right")
		else: animation_player.play("left")
	else:
		if x > 0 and y > 0: animation_player.play("down_right")
		elif x > 0 and y < 0: animation_player.play("up_right")
		elif x < 0 and y > 0: animation_player.play("down_left")
		elif x < 0 and y < 0: animation_player.play("up_left")

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	_animation_process(direction)
	if direction:
		self.velocity = direction * SPEED
	else:
		self.velocity = Vector2.ZERO

	move_and_slide()
