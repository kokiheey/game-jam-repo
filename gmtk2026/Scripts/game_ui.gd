extends Control

@onready var TIME_LABEL = $CountdownPanel/TimeLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_time(time : float) -> void:
	TIME_LABEL.text = str(snapped(time, 0.1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
