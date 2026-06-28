extends PanelContainer

@onready var news_manager := get_tree().current_scene.get_node("News") as NewsManager
@onready var game_manager := get_tree().current_scene as GameManager

@onready var delayTimer : Timer = $Delay
@onready var affectTimer : Timer = $Affect

@export var START_STOCK_VALUE : int =  100000000
@export var DEFAULT_PRICE_RANGE : Vector2i = Vector2i(-10, 10)
@export var POINTS_SHOWN : int = 64
@export var SCALING_FACTOR : int = 3
@export var LINE_WIDTH : float = 3.0

var WINDOW_WIDTH : int
var WINDOW_HEIGHT : int

var currentPriceRange : Vector2i
var newsPriceRange : Vector2i
var prices : Array
var rng = RandomNumberGenerator.new()

var testing : bool = false

func _process(delta: float) -> void:
	if testing:
		updateStock()

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
		prices.append(max(0, prices[prices.size()-1] + rng.randi_range(currentPriceRange.x, currentPriceRange.y)))
	await get_tree().process_frame
	WINDOW_WIDTH = size.x
	WINDOW_HEIGHT = size.y


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
	currentPriceRange = DEFAULT_PRICE_RANGE


func _draw():
	var coordY = 0.5 * WINDOW_HEIGHT
	var coordX = 0.75 * WINDOW_WIDTH
	var deltaX = ceil(coordX / POINTS_SHOWN)
	for i in range(1, POINTS_SHOWN + 1):
		var currentX = coordX - deltaX
		var currentY = coordY + (prices[prices.size() - i] - prices[prices.size() - i - 1]) * SCALING_FACTOR
		draw_line(Vector2(coordX,coordY), Vector2(currentX, currentY), Color.GREEN, LINE_WIDTH)
		coordX = currentX
		coordY = currentY
