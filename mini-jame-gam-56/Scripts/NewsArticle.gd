class_name NewsArticle
extends RefCounted

var newsArticleTitle: String
var newsArticleImage: Image
var newsArticleDescription: String

var newsImpact: Vector2
var affectedTime: float
var delay: float

func _init(p_newsArticleTitle : String, p_newsArticleImage : Image, p_newsArticleDescription : String,
		   p_newsImpact: Vector2, p_affectedTime: float, p_delay: float):
	newsArticleTitle = p_newsArticleTitle
	newsArticleImage = p_newsArticleImage
	newsArticleDescription = p_newsArticleDescription
	newsImpact = p_newsImpact
	affectedTime = p_affectedTime
	delay = p_delay
	
func getTitle() -> String:
	return newsArticleTitle
	
func getImage() -> Image:
	return newsArticleImage
	
func getDescription() -> String:
	return newsArticleDescription
	
func getImpact() -> Vector2:
	return newsImpact
	
func getAffectedTime() -> float:
	return affectedTime
	
func getDelay() -> float:
	return delay
