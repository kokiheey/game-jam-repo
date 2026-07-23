extends Control

func _on_play_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/game.tscn")


func _on_exit_button_pressed() -> void:
	SceneTransition.quit_game()
