extends Node
class_name StockManager

@onready var news_manager := get_tree().current_scene.get_node("News") as NewsManager
@onready var game_manager := get_tree().current_scene as GameManager

@onready var delayTimer : Timer = $Delay
@onready var affectTimer : Timer = $Affect
@onready var balanceLbl : Label = $VBoxContainer/TabPanel2/HBoxContainer/begin/Panel/BalanceLbl
@onready var profitLbl : Label = $VBoxContainer/TabPanel2/HBoxContainer/begin/Panel2/ProfitLbl
@onready var timeLbl : Label = $VBoxContainer/TabPanel2/HBoxContainer/center/PanelContainer/TimeLbl

signal update_graph(pricePoint)

@export var START_STOCK_VALUE : int =  100000000
@export var DEFAULT_PRICE_RANGE : Vector2i = Vector2i(-10, 10)
@export var POINTS_SHOWN : int = 64
@export var SCALING_FACTOR : int = 3

var testing : bool = false

var prices : Array
var currentPriceRange : Vector2i
var newsPriceRange : Vector2i
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	currentPriceRange = DEFAULT_PRICE_RANGE
	
	if news_manager is NewsManager:
		news_manager.connect("breaking_news", breakingNews)
	else: print_rich("[color=yellow]WARNING: News manager not connected for stock line![/color]")
		
	if game_manager is GameManager:
		game_manager.connect("update_stock", updateStock)
	else: 
		testing = true
		print_rich("[color=yellow]WARNING: Root node is not game, switching to scene testing![/color]")
	
	prices.append(START_STOCK_VALUE)
	for i in POINTS_SHOWN:
		var newPricePoint = max(0, prices[prices.size()-1] + rng.randi_range(currentPriceRange.x, currentPriceRange.y))
		prices.append(newPricePoint)
		update_graph.emit(newPricePoint)

func breakingNews(range : Vector2i, duration : float, delay : float) -> void:
	delayTimer.wait_time = delay
	affectTimer.wait_time = duration
	newsPriceRange = range
	delayTimer.start()

func updateStock() -> void:
	var newPricePoint = max(0, prices[prices.size()-1] + rng.randi_range(currentPriceRange.x, currentPriceRange.y))
	prices.append(newPricePoint)
	prices.pop_front()
	update_graph.emit(newPricePoint)

func _on_delay_timeout() -> void:
	affectTimer.start()
	print("Starting the news range now with range of [", newsPriceRange.x, ", ", newsPriceRange.y, "]")
	currentPriceRange = newsPriceRange

func _on_affect_timeout() -> void:
	currentPriceRange = DEFAULT_PRICE_RANGE

func _process(delta: float) -> void:
	if testing:
		updateStock()
