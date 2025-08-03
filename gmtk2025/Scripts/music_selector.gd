extends Node

@export var music: AudioStream

func _ready() -> void:
	AudioManager.play_music(music)
