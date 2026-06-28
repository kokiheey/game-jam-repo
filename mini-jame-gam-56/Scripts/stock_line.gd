extends PanelContainer

@onready var stock_manager := get_tree().current_scene.get_node("Stocks") as StockManager

@export var POINTS_SHOWN : int = 64
@export var SCALING_FACTOR : int = 3
@export var LINE_WIDTH : float = 3.0

var WINDOW_WIDTH : int
var WINDOW_HEIGHT : int

var prices : Array

func _ready() -> void:
	if stock_manager == null:
		stock_manager = get_tree().current_scene as StockManager
	stock_manager.connect("update_graph", updateGraph)
	await get_tree().process_frame
	WINDOW_WIDTH = size.x
	WINDOW_HEIGHT = size.y

func updateGraph(pricePoint):
	prices.append(pricePoint)
	if prices.size() > POINTS_SHOWN + 1:
		prices.pop_front()
	queue_redraw()

func _draw():
	var coordY = 0.5 * WINDOW_HEIGHT
	var coordX = 0.75 * WINDOW_WIDTH
	var deltaX = coordX / POINTS_SHOWN
	for i in range(1, min(prices.size() + 1, POINTS_SHOWN + 1)):
		var currentX = coordX - deltaX
		var currentY = coordY + (prices[prices.size() - i] - prices[prices.size() - i - 1]) * SCALING_FACTOR
		draw_line(Vector2(coordX,coordY), Vector2(currentX, currentY), Color.GREEN, LINE_WIDTH)
		coordX = currentX
		coordY = currentY
