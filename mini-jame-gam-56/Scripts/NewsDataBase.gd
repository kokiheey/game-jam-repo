class_name NewsDataBase
extends RefCounted

static var delay: float = 5000.0

static var arc1 = NewsArticle.new("Amaizing news", null, "Carrot corp. CEO bought X for 10 million carrots!", Vector2(100, 500), 3000.0, delay);
static var arc2 = NewsArticle.new("Good news", null, "Carrot corp. Excecutive hired 100 new workers", Vector2(-100, 100), 2000.0, delay);
static var arc3 = NewsArticle.new("Bad news", null, "Carrot corp. CEO fired 500 workers", Vector2(-200, 10), 4000.0, delay);

static var listNewsArticles: Array[NewsArticle] = [arc1, arc2, arc3];
