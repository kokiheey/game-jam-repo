extends Control

@export var GAME : Node2D

func _on_resume_button_pressed() -> void:
	GAME.pause_menu()

func _on_back_to_menu_button_pressed() -> void:
	Engine.time_scale = 1
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
