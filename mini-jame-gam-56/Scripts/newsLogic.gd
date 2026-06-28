extends Node2D

signal breaking_news(newsImpact, affectedTime, delay)

var listNews: Array[NewsArticle] = NewsDataBase.listNewsArticles

func _ready() -> void:
	self.connect("update_news", pickNews)
	
func changeNews() -> void:
	pickNews()
	setNews()
	
func pickNews() -> void:
	var i = randi_range(0, listNews.size());
	var n = listNews.get(i);
	breaking_news.emit(n.getImpact(), n.getAffectedTime(), n.getDelay())

func setNews() -> void:
	pass	
