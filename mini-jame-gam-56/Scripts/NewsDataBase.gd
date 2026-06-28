class_name NewsDataBase
extends RefCounted

static var delay: float = 3

static var arc1 = NewsArticle.new("Amazing news", null, "Carrot corp. CEO bought X for 10 million carrots!", Vector2i(2, 20), 3.0, delay);
static var arc2 = NewsArticle.new("Good news", null, "Carrot corp. Excecutive hired 100 new workers", Vector2i(-5, 20), 2.0, delay);
static var arc3 = NewsArticle.new("Bad news", null, "Carrot corp. CEO fired 500 workers", Vector2i(-10, 2), 4.0, delay);

static var listNewsArticles: Array[NewsArticle] = [arc1, arc2, arc3];
