extends Control

@onready var volumeSlider = $VBoxContainer/Volume
@onready var fullscreenToggle = $VBoxContainer/FullscreenToggle

func _ready():
	fullscreenToggle.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	volumeSlider.value = AudioServer.get_bus_volume_linear(0) * 100

func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value/100.0)


func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
