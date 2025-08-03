extends Node2D
class_name Box

@onready var upLeft : Area2D = $up_left
@onready var upRight : Area2D = $up_right
@onready var downLeft : Area2D = $down_left
@onready var downRight : Area2D = $down_right

var can_move := true
var disabled_directions := {
	"up_left": false,
	"up_right": false,
	"down_left": false,
	"down_right": false
}

func move(offset: Vector2):
	can_move = false
	position += offset
	await get_tree().create_timer(0.1).timeout
	can_move = true

func _on_up_left_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["down_right"] = true
	elif body is CharacterBody2D and !disabled_directions["up_left"] and can_move:
		move(Vector2(-16, -8))

func _on_up_right_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["down_left"] = true
	elif body is CharacterBody2D and !disabled_directions["up_right"] and can_move:
		move(Vector2(16, -8))

func _on_down_left_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["up_right"] = true
	elif body is CharacterBody2D and !disabled_directions["down_left"] and can_move:
		move(Vector2(-16, 8))

func _on_down_right_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["up_left"] = true
	elif body is CharacterBody2D and !disabled_directions["down_right"] and can_move:
		move(Vector2(16, 8))
