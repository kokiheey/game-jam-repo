class_name Box
extends Node2D

@export var follow_distance := 60
@export var follow_speed := 6

@onready var area = $Area2D
@onready var timer = $Timer
@onready var circle = $Circle_Timer
@onready var PickupArea = $Area2D/PickupArea

@export var COLLECTION_TIME : float = 2.0

var grad_texture : GradientTexture2D
var player: Node2D = null
var following := false
var charging := false

@export var off0 : float = 0.8
@export var off1 : float = 0.94
@export var off2 : float = 0.99
@export var off3 : float = 1.0

signal picked_up

func _ready():
	timer.wait_time = COLLECTION_TIME
	
	area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)
	
	grad_texture = circle.texture as GradientTexture2D
	circle.hide()
	PickupArea.show()

func _process(delta):
	if charging and !following:
		var progress = (timer.time_left / COLLECTION_TIME)
		var larp = lerp(0.0, 1.0, progress)
		var grad = grad_texture.gradient
		grad.set_offset(0, off0 - progress)
		grad.set_offset(1, off1 - progress)
		grad.set_offset(2, off2 - progress)
		grad.set_offset(3, off3 - progress)
		circle.show()
	
	if !following or player == null:
		return
	
	PickupArea.hide()
	
	var behind = player.global_position - Vector2.RIGHT.rotated(player.rotation) * follow_distance
	global_position = global_position.lerp(behind, follow_speed * delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		charging = true
		timer.start()

func _on_timer_timeout():
	following = true
	charging = false
	picked_up.emit()
	circle.scale = Vector2.ZERO

func _on_area_2d_body_exited(body: Node2D) -> void:
	timer.paused = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	timer.paused = false
