class_name Box
extends Node2D

@export var follow_distance := 60
@export var follow_speed := 6

@onready var area = $Area2D
@onready var circle = $Circle_Timer
@onready var PickupArea = $Area2D/PickupArea

@export var COLLECTION_TIME : float = 2.0

var grad_texture : GradientTexture2D
var player: Node2D = null
var following := false
var charging := false
var progress : float = 0.0

var off0 : float = 0.7
var off1 : float = 0.94
var off2 : float = 0.99
var off3 : float = 1.0

signal picked_up

func _ready():
	circle.hide()
	PickupArea.show()
	grad_texture = circle.texture as GradientTexture2D
	var grad = grad_texture.gradient

func _process(delta):
	print(progress)
	if progress == 1.0:
		following = true
		charging = false
		circle.hide()
		PickupArea.hide()
		picked_up.emit()
	
	if following:
		var behind = player.global_position - Vector2.RIGHT.rotated(player.rotation) * follow_distance
		global_position = global_position.lerp(behind, follow_speed * delta)
	else:
		if charging:
			progress = min(1, progress + (1 / COLLECTION_TIME) * delta)
		else:
			progress = max(0, progress - (1 / COLLECTION_TIME) * delta)
		circle.show()
		changePickupProgress(1.0 - progress)

func changePickupProgress(_progress : float) -> void:
	var grad = grad_texture.gradient
	grad.set_offset(0, max(0, off0 - _progress))
	grad.set_offset(1, max(0.01, off1 - _progress))
	grad.set_offset(2, max(0.02, off2 - _progress))
	grad.set_offset(3, max(0.03, off3 - _progress))

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		charging = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		charging = true
