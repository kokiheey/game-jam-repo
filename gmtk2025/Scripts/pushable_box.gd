extends Node2D
class_name Box

@onready var upLeft : Area2D = $up_left
@onready var upRight : Area2D = $up_right
@onready var downLeft : Area2D = $down_left
@onready var downRight : Area2D = $down_right
@export var push_sound : AudioStream

func _ready():
	upLeft.body_exited.connect(_on_up_left_body_exited)
	upRight.body_exited.connect(_on_up_right_body_exited)
	downLeft.body_exited.connect(_on_down_left_body_exited)
	downRight.body_exited.connect(_on_down_right_body_exited)
	
var can_move := true
var offset := Vector2.ZERO
var disabled_directions := {
	"up_left": false,
	"up_right": false,
	"down_left": false,
	"down_right": false
}

func move(offset: Vector2):
	can_move = false
	position += offset
	can_move = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		print(offset)
		move(offset)
		if offset != Vector2.ZERO:
			AudioManager.play_sfx(push_sound)

func _on_up_left_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["down_right"] = true
	elif body is CharacterBody2D and !disabled_directions["up_left"] and can_move:
		offset = Vector2(-16, -8)

func _on_up_right_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["down_left"] = true
	elif body is CharacterBody2D and !disabled_directions["up_right"] and can_move:
		offset = Vector2(16, -8)

func _on_down_left_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["up_right"] = true
	elif body is CharacterBody2D and !disabled_directions["down_left"] and can_move:
		offset = Vector2(-16, 8)

func _on_down_right_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["up_left"] = true
	elif body is CharacterBody2D and !disabled_directions["down_right"] and can_move:
		offset = Vector2(16, 8)

func _on_up_left_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["down_right"] = false
	offset = Vector2.ZERO

func _on_up_right_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["down_left"] = false
	offset = Vector2.ZERO

func _on_down_left_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["up_right"] = false
	offset = Vector2.ZERO

func _on_down_right_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		disabled_directions["up_left"] = false
	offset = Vector2.ZERO
