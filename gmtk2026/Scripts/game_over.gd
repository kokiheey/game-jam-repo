extends Control

func _on_new_game_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/game.tscn")


func _on_back_to_menu_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
