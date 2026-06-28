extends Node2D

@export var showLast : int = 16
var prices : Array
var rng = RandomNumberGenerator.new()
 
func _ready() -> void:
	#self.connect("breaking_news", breakingNews)
	
	prices.append(rng.randi_range(500, 1000))
	for i in showLast:
		prices.append(max(0, prices[prices.size()-1] + rng.randi_range(-10.0, 10.0)))
	pass

func _draw():
	var coordY = 324 # 1/2 ekrana
	var coordX = 864 #3/4 do kraja ekrana
	for i in range(1, showLast):
		var currentX = coordX - 54
		var currentY = coordY + (prices[prices.size() - i] - prices[prices.size() - i - 1]) * 5
		draw_line(Vector2(coordX,coordY), Vector2(currentX, currentY), Color.GREEN, 5.0)
		coordX = currentX
		coordY = currentY


func breakingNews(range, duration, delay) -> void:
	pass

func _process(delta: float) -> void:
	prices.append(max(0, prices[prices.size()-1] + rng.randi_range(-10.0, 10.0)))
	queue_redraw()
