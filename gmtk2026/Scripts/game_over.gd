extends Control

@onready var totalScore : Label = $Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/ScoreLabel
@onready var totalMoney : Label = $Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/MoneyLabel
@onready var totalPackages : Label = $Panel/MarginContainer/VBoxContainer/Stats/HBoxContainer/MarginContainer2/VBoxContainer/PackagesLabel

func updateStatistics(score : float, money : float , packages : int) -> void:
	totalScore.text = str(score)
	totalMoney.text = str(money)
	totalPackages.text = str(packages)

func _on_new_game_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/game.tscn")


func _on_back_to_menu_button_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
