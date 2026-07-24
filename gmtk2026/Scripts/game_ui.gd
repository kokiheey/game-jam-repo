extends Control

@onready var TIME_LABEL : Label    = $CountdownPanel/TimeLabel

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_time(time : float) -> void:
	TIME_LABEL.text = str(snapped(time, 0.1))
