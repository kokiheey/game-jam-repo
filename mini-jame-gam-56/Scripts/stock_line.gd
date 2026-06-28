extends Node2D

@export var news_manager : Node2D
@onready var game_manager : Node2D = get_tree().current_scene

@export var showLast : int = 16
var prices : Array
var rng = RandomNumberGenerator.new()

var testing : bool = false

func _ready() -> void:
	if news_manager == null:
		print_rich("[color=yellow]WARNING: News manager not connected for stock line![/color]")
	else: news_manager.connect("breaking_news", breakingNews)
		
	if game_manager.name != "Game":
		testing = true
		print_rich("[color=yellow]WARNING: Root node is not game, switching to scene testing![/color]")
	else: game_manager.connect("update_stock", updateStock)
	
	prices.append(rng.randi_range(500, 1000))
	for i in showLast:
		prices.append(max(0, prices[prices.size()-1] + rng.randi_range(-10.0, 10.0)))
	pass

func _process(delta: float) -> void:
	if testing:
		updateStock()

func _draw():
	var coordY = 324 # 1/2 ekrana
	var coordX = 864 #3/4 do kraja ekrana
	for i in range(1, showLast + 1):
		var currentX = coordX - 54
		var currentY = coordY + (prices[prices.size() - i] - prices[prices.size() - i - 1]) * 5 
		draw_line(Vector2(coordX,coordY), Vector2(currentX, currentY), Color.GREEN, 5.0)
		coordX = currentX
		coordY = currentY


func breakingNews(range, duration, delay) -> void:
	pass

func updateStock() -> void:
	prices.append(max(0, prices[prices.size()-1] + rng.randi_range(-10.0, 10.0)))
	prices.pop_front()
	queue_redraw()
