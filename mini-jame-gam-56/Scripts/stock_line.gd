extends Node2D

@onready var news_manager := get_tree().current_scene.get_node("News") as NewsManager
@onready var game_manager := get_tree().current_scene as GameManager

@onready var delayTimer : Timer = $Delay
@onready var affectTimer : Timer = $Affect

@export var startStockValue : int =  100000000
@export var defaultPriceRange : Vector2i = Vector2i(-10, 10)
@export var showLast : int = 16

var currentPriceRange : Vector2i
var newsPriceRange : Vector2i
var prices : Array
var rng = RandomNumberGenerator.new()

var testing : bool = false

func _process(delta: float) -> void:
	if testing:
		updateStock()

func _ready() -> void:
	currentPriceRange = defaultPriceRange
	
	if news_manager is NewsManager:
		news_manager.connect("breaking_news", breakingNews)
	else: print_rich("[color=yellow]WARNING: News manager not connected for stock line![/color]")
		
	if game_manager is GameManager:
		game_manager.connect("update_stock", updateStock)
	else: 
		testing = true
		print_rich("[color=yellow]WARNING: Root node is not game, switching to scene testing![/color]")
	
	prices.append(startStockValue)
	for i in showLast:
		prices.append(max(0, prices[prices.size()-1] + rng.randi_range(currentPriceRange.x, currentPriceRange.y)))
	pass


func updateStock() -> void:
	prices.append(max(0, prices[prices.size()-1] + rng.randi_range(currentPriceRange.x, currentPriceRange.y)))
	prices.pop_front()
	queue_redraw()

func breakingNews(range : Vector2i, duration : float, delay : float) -> void:
	delayTimer.wait_time = delay
	affectTimer.wait_time = duration
	newsPriceRange = range
	delayTimer.start()

func _on_delay_timeout() -> void:
	affectTimer.start()
	print("Starting the news range now with range of [", newsPriceRange.x, ", ", newsPriceRange.y, "]")
	currentPriceRange = newsPriceRange

func _on_affect_timeout() -> void:
	currentPriceRange = defaultPriceRange



func _draw():
	var coordY = 324 # 1/2 ekrana 
	var coordX = 864 #3/4 do kraja ekrana
	for i in range(1, showLast + 1):
		var currentX = coordX - 54
		var currentY = coordY + (prices[prices.size() - i] - prices[prices.size() - i - 1]) * 5 
		draw_line(Vector2(coordX,coordY), Vector2(currentX, currentY), Color.GREEN, 5.0)
		coordX = currentX
		coordY = currentY
