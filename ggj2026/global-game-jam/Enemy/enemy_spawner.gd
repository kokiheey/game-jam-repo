extends Node2D
@export var min_time := 2.0
@export var max_time := 6.0
@export var radius := 100
@export var player : CharacterBody2D
@export var root: Node2D
@onready var timer = $Timer
@onready var enemy = preload("res://Scenes/enemy.tscn")
var rng : RandomNumberGenerator
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	var time := rng.randf_range(min_time, max_time)
	timer.wait_time = time
	timer.start()
	timer.timeout.connect(timer_out)

func timer_out():
	#spawn enemy
	var enemyInstance = enemy.instantiate()
	enemyInstance.player = player
	enemyInstance.global_position = Vector2(
		player.global_position.x + rng.randf_range(-radius, radius),
		player.global_position.y + rng.randf_range(-radius, radius)
	)
	root.add_child(enemyInstance)
	var time = rng.randf_range(min_time, max_time)
	timer.wait_time = time
	
