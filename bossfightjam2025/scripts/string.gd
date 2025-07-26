extends Node
class_name string

@export var body_up: PhysicsBody2D
@export var body_down: PhysicsBody2D
@onready var top: RigidBody2D = $string_piece_S
@onready var bottom: RigidBody2D = $string_piece_E

@onready var top_joint: PinJoint2D = $S
@onready var bottom_joint: PinJoint2D = $E

func _ready():
	top_joint.node_a = body_up.get_path()
	bottom_joint.node_b = body_down.get_path()

func cut():
	top_joint.enabled = false
