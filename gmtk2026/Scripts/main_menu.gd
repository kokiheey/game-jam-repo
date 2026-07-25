extends Control

@export var Options : Control

func _on_play_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/game.tscn")

func _on_options_button_pressed() -> void:
	Options.open()

func _on_exit_button_pressed() -> void:
	SceneTransition.quit_game()
