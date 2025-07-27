extends Control

@onready var main = $".."


func _on_restart_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main.tscn")
	


func _on_quit_button_up() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
