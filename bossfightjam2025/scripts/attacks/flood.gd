extends Node2D
class_name Flood

@export var scale_up_time := 0.5
@export var hold_time := 2.0
@export var scale_down_time := 0.5
@export var target_scale := Vector2(1, -10)

func _ready() -> void:
	self.global_position = Vector2(0, 1080)
	scale = Vector2(1, 0)

	var tween = create_tween()
	tween.tween_property(self, "scale", target_scale, scale_up_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(hold_time)
	tween.tween_property(self, "scale", Vector2(1, 0), scale_down_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "_on_attack_finished"))


func _on_attack_finished():
	print("Flood attack finished")
	queue_free() # or signal end, or deactivate, etc.
