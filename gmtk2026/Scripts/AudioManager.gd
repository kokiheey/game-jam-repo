extends Node

var AllSoundsIndex : int = AudioServer.get_bus_index("Master")
var MusicIndex     : int = AudioServer.get_bus_index("Music")
var SFXIndex       : int = AudioServer.get_bus_index("SFX")

var AllSoundsVolume : int = 100
var MusicVolume     : int = 100
var SFXVolume       : int = 100

var hurt : AudioStreamPlayer
var move : AudioStreamPlayer

func _ready() -> void:
	hurt = AudioStreamPlayer.new()
	hurt.stream = preload("res://Assets/SFX/hurt.ogg")
	add_child(hurt)

func playHurt():
	hurt.play()

func update():
	AudioServer.set_bus_volume_linear(AllSoundsIndex, float(AllSoundsVolume) / 100)
	AudioServer.set_bus_volume_linear(MusicIndex, float(MusicVolume) / 100)
	AudioServer.set_bus_volume_linear(SFXIndex, float(SFXVolume) / 100)
