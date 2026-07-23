class_name GravityComponent
extends Area2D

@export var maxAcceleration = 4000.0
@export var gravityStrength : float = 1000000.0
var acceleration : Vector2
var bodies : Array[GravitySourceComponent]

func _on_area_entered(area):
	print("hi")
	if area is GravitySourceComponent:
		bodies.append(area as GravitySourceComponent)

func _on_area_exited(area):
	if area is GravitySourceComponent:
		bodies.erase(area)

func _ready():
	monitoring = true
	collision_mask = 1 << 3 #fah you mean
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
@warning_ignore("unused_parameter")
func _process(delta: float):
	acceleration = Vector2.ZERO
	for body in bodies:
		var dist : Vector2 = body.global_position - global_position
		acceleration += gravityStrength * dist.normalized() * body.mass / dist.length()
		acceleration = acceleration.clampf(-maxAcceleration, maxAcceleration)
		print("sup", acceleration, "yarayara ", dist.length_squared(), dist.normalized())
