extends Node2D

@export var follow_distance := 60
@export var follow_speed := 6

@onready var area = $Area2D
@onready var timer = $Timer

var player: Node2D = null
var following := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)

func _process(delta):
	if !following or player == null:
		return

	var behind = player.global_position - Vector2.RIGHT.rotated(player.rotation) * follow_distance
	global_position = global_position.lerp(behind, follow_speed * delta)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		timer.start()

func _on_timer_timeout():
	following = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("yo")

	if body.is_in_group("player"):
		print("yo")
		player = body
		timer.start()
