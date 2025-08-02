extends Control

@onready var settings_page : CenterContainer = $SettingsContainer

func _ready() -> void:
	pass

func _on_play_button_up() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_exit_button_up() -> void:
	get_tree().quit()
