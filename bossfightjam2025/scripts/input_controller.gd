extends Node
class_name InputController


signal primary_up()
signal primary()
signal attack()
signal change_phase()
signal axis(direction: Vector2)
signal pause()
var left_axis : bool
var right_axis : bool
var up_axis : bool
var down_axis : bool



func _input(event):
	if event is InputEventKey:
		if event.pressed:	
			match event.keycode:
				KEY_SPACE:
					primary.emit()
				KEY_A:
					left_axis = true
					_emit_axis()
				KEY_D:
					right_axis = true
					_emit_axis()
				KEY_J:
					if not event.is_echo():
						change_phase.emit()
				KEY_K:
					if not event.is_echo():
						attack.emit()
				KEY_ESCAPE:
					if not event.is_echo():
						pause.emit()
		else:
			match event.keycode:
				KEY_A:
					left_axis = false
					_emit_axis()
				KEY_D:
					right_axis = false
					_emit_axis()
				KEY_SPACE:
					primary_up.emit()

func _emit_axis():
	var x := 0
	var y := 0
	x = -int(left_axis) + int(right_axis)
	y = -int(up_axis) + int(down_axis)
	axis.emit(Vector2(x, y))
