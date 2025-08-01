extends CharacterBody2D


const SPEED = 20.0


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		self.velocity = direction * SPEED
		#za flipovanje karaktera
		if direction == "ui_left":
			pass
		elif direction == "ui_left":
			pass
		elif direction == "ui_up":
			pass
		else:
			pass
		#----------
	else:
		self.velocity = Vector2.ZERO

	move_and_slide()
