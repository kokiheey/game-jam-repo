extends Control

@export var main_scene : PackedScene

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)
