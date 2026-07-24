class_name Box
extends Node2D

@export var LoadingColor : Color = Color("e9e9e9")
@export var BorderColor : Color = Color("e9e9e9")
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

const off0 : float = 0.7
const off1 : float = 0.94
const off2 : float = 0.99
const off3 : float = 1.0

signal picked_up

func _ready():
	circle.hide()
	PickupArea.show()
	var pickup_texture = PickupArea.texture as GradientTexture2D
	pickup_texture.gradient.set_color(0, "00000000")
	pickup_texture.gradient.set_color(1, BorderColor)
	pickup_texture.gradient.set_color(2, BorderColor)
	pickup_texture.gradient.set_color(3, "00000000")
	#PickupArea.hide()
	grad_texture = circle.texture as GradientTexture2D
	changePickupProgress(1)

func _process(delta):
	if progress == 0.0:
		circle.hide()
		
	if progress == 1.0:
		following = true
		charging = false
		circle.hide()
		PickupArea.hide()
		picked_up.emit()
	
	if following and player:
		var behind = player.global_position - Vector2.RIGHT.rotated(player.rotation) * follow_distance
		global_position = global_position.lerp(behind, follow_speed * delta)
	else:
		if charging:
			progress += (1 / COLLECTION_TIME) * delta
		else:
			progress -= (1 / COLLECTION_TIME) * delta
		
		progress = max(0, min(1, progress))
		circle.show()
		changePickupProgress(1.0 - progress)

func changePickupProgress(_progress : float) -> void:
	var grad = grad_texture.gradient
	grad.set_offset(0, maxf(0.00, off0 - _progress))
	grad.set_offset(1, maxf(0.01, off1 - _progress))
	grad.set_offset(2, maxf(0.02, off2 - _progress))
	grad.set_offset(3, maxf(0.03, off3 - _progress))
	
	var visible : Color = LoadingColor
	var fade : Color = LoadingColor
	fade.a = 0
	
	grad.set_color(0, fade)
	grad.set_color(1, visible)
	grad.set_color(2, visible)
	grad.set_color(3, fade)
	
	#print("0 - ", grad.get_offset(0), " ", grad.get_color(0).a)
	#print("1 - ", grad.get_offset(1), " ", grad.get_color(1).a)
	#print("2 - ", grad.get_offset(2), " ", grad.get_color(2).a)
	#print("3 - ", grad.get_offset(3), " ", grad.get_color(3).a)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if following: return
	if body.is_in_group("player"):
		player = null
		charging = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if following: return
	if body.is_in_group("player"):
		player = body
		charging = true
