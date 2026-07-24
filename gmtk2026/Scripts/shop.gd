extends Control

signal pressedSpeed

func _on_speed_pressed() -> void:
	print("yo")
	pressedSpeed.emit()
