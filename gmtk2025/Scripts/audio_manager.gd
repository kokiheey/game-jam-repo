extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

func play_music(stream: AudioStream) -> void:
	if player.stream != stream:
		player.stream = stream
		player.play()
