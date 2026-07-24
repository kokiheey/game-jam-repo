extends Node2D

@export var follow_distance := 60
@export var follow_speed := 6

@onready var area = $Area2D
@onready var timer = $Timer
@onready var circle = $Circle_Timer

@export var timer_time := 2
@export var circle_size := 0.035

var player: Node2D = null
var following := false
var charging := false

func _ready():
	timer.wait_time = timer_time
	timer.one_shot = true
	
	area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

	circle.scale = Vector2.ZERO

func _process(delta):
	if charging and !following:
		var progress = 1.0 - (timer.time_left / timer.wait_time)
		var scale_amount = lerp(0.0, float(circle_size), progress)
		circle.scale = Vector2.ONE * scale_amount
	
	if !following or player == null:
		return

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
		
	circle.scale = Vector2.ZERO

func _on_area_2d_body_exited(body: Node2D) -> void:
	timer.paused = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	timer.paused = false
