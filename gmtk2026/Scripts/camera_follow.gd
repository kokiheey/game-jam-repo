extends Camera2D

@export var dir_offset := 80
@export var smooth_speed := 2.5

func _process(delta):
	var center = get_viewport_rect().size / 2.0
	var mouse = get_viewport().get_mouse_position()

	var dir = mouse - center

	if dir.length() > dir_offset:
		dir = dir.normalized() * dir_offset

	offset = offset.lerp(dir, smooth_speed * delta)
