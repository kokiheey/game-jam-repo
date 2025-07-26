extends TextureProgressBar
class_name HealthBar

@export var player: PlayerCharacter

func _ready():
	value = player.health / player.MaxHealth * 100

func _process(delta: float) -> void:
	value = float(player.health) / player.MaxHealth * 100
