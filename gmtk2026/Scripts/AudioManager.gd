extends Node

var AllSoundsIndex : int = AudioServer.get_bus_index("Master")
var MusicIndex     : int = AudioServer.get_bus_index("Music")
var SFXIndex       : int = AudioServer.get_bus_index("SFX")

var AllSoundsVolume : int = 100
var MusicVolume     : int = 100
var SFXVolume       : int = 100

func update():
	AudioServer.set_bus_volume_linear(AllSoundsIndex, AllSoundsVolume)
	AudioServer.set_bus_volume_linear(MusicIndex, MusicVolume)
	AudioServer.set_bus_volume_linear(SFXIndex, SFXVolume)
