extends Node
class_name InputController

signal primary()
signal axis(direction: Vector2)

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
		else:
			match event.keycode:
				KEY_A:
					left_axis = false
					_emit_axis()
				KEY_D:
					right_axis = false
					_emit_axis()

func _emit_axis():
	var x := 0
	var y := 0
	x = -int(left_axis) + int(right_axis)
	y = -int(up_axis) + int(down_axis)
	axis.emit(Vector2(x, y))
