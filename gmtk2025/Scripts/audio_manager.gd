extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

func mute_music(toggled: bool) -> void:
	if toggled:
		player.playing = false
	else:
		player.playing = true

func play_music(stream: AudioStream) -> void:
	if player.stream != stream:
		player.stream = stream
		player.play()
