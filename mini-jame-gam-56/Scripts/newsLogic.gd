extends Node2D
class_name NewsManager

signal breaking_news(newsImpact, affectedTime, delay)

@onready var game_manager = get_tree().current_scene

var listNews: Array[NewsArticle] = NewsDataBase.listNewsArticles

func _ready() -> void:
	game_manager.connect("update_news", changeNews)
	pass

func changeNews() -> void:
	var i = randi_range(0, listNews.size() - 1);
	var n = listNews.get(i);
	pickNews(n)
	setNews(n)
	
func pickNews(n : NewsArticle) -> void:
	breaking_news.emit(n.getImpact(), n.getAffectedTime(), n.getDelay())

func setNews(n : NewsArticle) -> void:
	print(n.getTitle())
	print(n.getDescription())
	print(n.getImpact())
	print(n.getAffectedTime())
	print(n.getDelay())
