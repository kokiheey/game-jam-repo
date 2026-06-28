extends Node2D
class_name GameManager

signal update_stock
signal update_news

@export var STOCK_LINE_INTERVAL : float = 1
@export var NEWS_INTERVAL : float = 2

var stock_tick : float = 0
var news_tick : float = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	stock_tick += delta
	news_tick += delta
	
	if stock_tick >= STOCK_LINE_INTERVAL:
		stock_tick = 0
		update_stock.emit()
	
	if news_tick >= NEWS_INTERVAL:
		news_tick = 0
		update_news.emit()
