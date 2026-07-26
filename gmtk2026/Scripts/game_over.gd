extends Control

@onready var totalTime : Label = $Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/TimeLabel
@onready var totalFuel : Label = $"Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/Fuel Spent"
@onready var totalMoney : Label = $Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/MoneyLabel
@onready var totalPackages : Label = $Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/PackagesLabel

func format_time(total_seconds: float) -> String:
	var minutes : int = int(total_seconds / 60.0)
	var seconds : int = int(total_seconds) % 60
	var milliseconds: int = int((total_seconds - floor(total_seconds)) * 100)
	
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]


func updateStatistics(time : float, fuel : float, money : float , packages : int) -> void:
	totalTime.text = format_time(time)
	totalFuel.text = str(int(fuel))
	totalMoney.text = str(money) + "$"
	totalPackages.text = str(packages)

func _on_new_game_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/game.tscn")


func _on_back_to_menu_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
