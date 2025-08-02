extends Toggle
class_name RisingDoor   

@export var door_body: StaticBody2D
@export var raised_transform: Transform2D
@onready var lowered_transform: Transform2D = transform


func _ready():
	toggled = false


func toggle():
	toggled = not toggled
	on_toggled.emit(self)
	if toggled:
		#tween to raised_position
		transform = raised_transform
	else:
		transform = lowered_transform
