extends Node2D
class_name Box

@onready var upLeft : Area2D = $up_left
@onready var upRight : Area2D = $up_right
@onready var downLeft : Area2D = $down_left
@onready var downRight : Area2D = $down_right

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_up_left_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		downRight.hide()
	elif body is CharacterBody2D:
		position.x -= 16
		position.y -= 8
		


func _on_up_right_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		downLeft.hide()
	elif body is CharacterBody2D:
		position.x += 16
		position.y -= 8


func _on_down_left_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		upRight.hide()
	elif body is CharacterBody2D:
		position.x -= 16
		position.y += 8


func _on_down_right_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		upLeft.hide()
	elif body is CharacterBody2D:
		position.x += 16
		position.y += 8
