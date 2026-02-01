class_name PlayerWeapon
extends CharacterWeapons

func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	var mouse_dir : Vector2 = global_position.direction_to(mouse_pos)
	
	if current_weapon:
		current_weapon.aim_direction(mouse_dir)
		
		if Input.is_action_just_pressed("attack"):
			current_weapon._try_use()
