extends CharacterBody2D


const SPEED = 36.0

var current_animation : String = ""
@export_enum("up","up_left","up_right","left","right","down","down_left","down_right") var startAnimation : String
@onready var animation_player : AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animation_player.play(startAnimation)
	animation_player.stop()
	animation_player.frame = 1

func _animation_process(direction: Vector2):
	var x : float = direction.x
	var y : float = direction.y
	var new_animation : String
	if x == 0 and y == 0: 
		new_animation = ""
	elif x == 0:
		new_animation = "down" if y > 0 else "up"
	elif y == 0:
		new_animation = "right" if x > 0 else "left"
	else:
		if x > 0:
			new_animation = "down_right" if y > 0 else "up_right"
		else:
			new_animation = "down_left" if y > 0 else "up_left"
	if new_animation != current_animation:
		if new_animation == "":
			animation_player.stop()
			animation_player.frame = 1
		else:
			animation_player.frame = 0
			animation_player.play(new_animation)
		current_animation = new_animation

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	_animation_process(direction)
	if direction:
		self.velocity = direction * SPEED
	else:
		self.velocity = Vector2.ZERO

	move_and_slide()
