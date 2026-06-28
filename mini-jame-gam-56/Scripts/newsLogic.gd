extends Node2D

signal breaking_news(newsImpact, affectedTime, delay)

var listNews: Array[NewsArticle] = NewsDataBase.listNewsArticles

func _ready() -> void:
	#self.connect("update_news", changeNews)
	pass

func _physics_process(delta: float) -> void:
	changeNews()

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
