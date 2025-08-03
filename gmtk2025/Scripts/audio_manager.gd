extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer2

var mute : bool = false
var mutesfx : bool = false

func mute_music(toggled: bool) -> void:
	mute = toggled
	
	if mute:
		player.stop()
	else:
		player.play()

func mute_sfx(toggled: bool) -> void:
	mutesfx = toggled

func play_sfx(stream: AudioStream) -> void:
	sfx.stream = stream
	sfx.play()

func play_music(stream: AudioStream) -> void:
	if player.stream != stream:
		player.stream = stream
		if !mute: player.play()
