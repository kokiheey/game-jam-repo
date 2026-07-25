extends Control

@export var GAME : Node2D

@export var Options : Control

func _on_resume_button_pressed() -> void:
	GAME.pause_menu()

func _on_options_button_pressed() -> void:
	Options.open()

func _on_back_to_menu_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
