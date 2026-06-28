class_name NewsDataBase
extends RefCounted

static var delay: float = 3

static var arc1 = NewsArticle.new("Amaizing news", null, "Carrot corp. CEO bought X for 10 million carrots!", Vector2i(100, 500), 3.0, delay);
static var arc2 = NewsArticle.new("Good news", null, "Carrot corp. Excecutive hired 100 new workers", Vector2i(-100, 100), 2.0, delay);
static var arc3 = NewsArticle.new("Bad news", null, "Carrot corp. CEO fired 500 workers", Vector2i(-200, 10), 4.0, delay);

static var listNewsArticles: Array[NewsArticle] = [arc1, arc2, arc3];
