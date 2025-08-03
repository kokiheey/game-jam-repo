extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var mute : bool = false

func mute_music(toggled: bool) -> void:
	if toggled:
		mute = true
	else:
		mute = false
	
	if mute:
		player.stop()
	else:
		player.play()

func play_music(stream: AudioStream) -> void:
	if player.stream != stream:
		player.stream = stream
		if !mute: player.play()
