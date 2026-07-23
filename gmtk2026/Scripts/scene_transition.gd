extends CanvasLayer

func change_scene(target: String) -> void:
	get_tree().paused = true
	
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file(target)
	
	$AnimationPlayer.play_backwards("dissolve")
	
	get_tree().paused = false

func quit_game() -> void:
	get_tree().paused = true
	
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	
	get_tree().quit()
