extends Control
@onready var main = $".."

func _on_resume_button_up() -> void:
	main.pauseMenu()



func _on_quit_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
