extends Toggle
class_name RisingDoor   

@export var door_body: StaticBody2D
@export var raised_transform: Transform2D
@onready var lowered_transform: Transform2D = transform.origin
var toggled: bool = false


func toggle():
    toggled = not toggled
    if toggled:
        #tween to raised_position
        transform = raised_transform
    else:
        transform = lowered_transform

