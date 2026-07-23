class_name GravitySourceComponent
extends Area2D

@export var mass := 1000.0

func _ready():
	monitorable = true
	collision_layer = 1 << 3 #fahhh you mean
