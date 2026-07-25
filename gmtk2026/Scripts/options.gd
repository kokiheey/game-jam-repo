extends Control

@onready var AllSoundsLabel : Label = $Panel/MarginContainer/VBoxContainer/VBoxContainer/AllSoundsOption/HBoxContainer2/AllSoundsLabel
@onready var MusicLabel : Label = $Panel/MarginContainer/VBoxContainer/VBoxContainer/MusicOption/HBoxContainer/MusicLabel
@onready var SFXLabel : Label = $Panel/MarginContainer/VBoxContainer/VBoxContainer/SFXOption/HBoxContainer/SFXLabel

@onready var AllSoundsText : Label = $Panel/MarginContainer/VBoxContainer/VBoxContainer/AllSoundsOption/AllSoundsText
@onready var MusicText : Label = $Panel/MarginContainer/VBoxContainer/VBoxContainer/MusicOption/MusicText
@onready var SFXText : Label = $Panel/MarginContainer/VBoxContainer/VBoxContainer/SFXOption/SFXText

@onready var AllSoundsSlider : Slider = $Panel/MarginContainer/VBoxContainer/VBoxContainer/AllSoundsOption/HBoxContainer2/AllSounds
@onready var MusicSlider : Slider = $Panel/MarginContainer/VBoxContainer/VBoxContainer/MusicOption/HBoxContainer/Music
@onready var SFXSlider : Slider = $Panel/MarginContainer/VBoxContainer/VBoxContainer/SFXOption/HBoxContainer/SFX

var newAllSounds : int
var newMusic     : int
var newSFX       : int

var changeAll   : bool = false
var changeMusic : bool = false
var changeSFX   : bool = false

func _ready() -> void:
	self.hide()
	pass

func open() -> void:
	newAllSounds = AudioManager.AllSoundsVolume
	newMusic     = AudioManager.MusicVolume
	newSFX       = AudioManager.SFXVolume
	_update_ui()
	self.show()

func _update_ui() -> void:
	AllSoundsLabel.text   = str(AudioManager.AllSoundsVolume) + "%"
	MusicLabel.text       = str(AudioManager.MusicVolume) + "%"
	SFXLabel.text         = str(AudioManager.SFXVolume) + "%"
	
	AllSoundsSlider.value = AudioManager.AllSoundsVolume
	MusicSlider.value     = AudioManager.MusicVolume
	SFXSlider.value       = AudioManager.SFXVolume

func _on_all_sounds_value_changed(value: int) -> void:
	newAllSounds = value
	process_change()

func _on_music_value_changed(value: int) -> void:
	newMusic = value
	process_change()

func _on_sfx_value_changed(value: int) -> void:
	newSFX = value
	process_change()

func process_change() -> void:
	if newAllSounds != AudioManager.AllSoundsVolume:
		AllSoundsLabel.text = "* " + str(newAllSounds) + "%"
	else:
		AllSoundsLabel.text = str(newAllSounds) + "%"
	if newMusic != AudioManager.MusicVolume:
		MusicLabel.text = "* " + str(newMusic) + "%"
	else:
		MusicLabel.text = str(newMusic) + "%"
	if newSFX != AudioManager.SFXVolume:
		SFXLabel.text = "* " + str(newSFX) + "%"
	else:
		SFXLabel.text = str(newSFX) + "%"
func _on_save_button_pressed() -> void:
	changeAll   = false
	changeMusic = false
	changeSFX   = false
	
	AudioManager.AllSoundsVolume = newAllSounds
	AudioManager.MusicVolume     = newMusic
	AudioManager.SFXVolume       = newSFX
	
	AudioManager.update()
	
	_update_ui()
	process_change()
	self.hide()

func _on_discard_button_pressed() -> void:
	changeAll   = false
	changeMusic = false
	changeSFX   = false
	
	_update_ui()
	process_change()
