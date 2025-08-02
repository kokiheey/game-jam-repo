extends Toggle

@onready var body: StaticBody2D = $StaticBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func toggle_on(echo: bool):
	on_toggles += 1
	print("tg ", on_toggles)
	if on_toggles > 0:
		if not echo: on_toggled_on.emit(self)
		body.collision_layer = 0
		sprite.hide()

func toggle_off(echo: bool):
	on_toggles -= 1
	print("tg ", on_toggles)
	if on_toggles <= 0:
		if not echo: on_toggled_off.emit(self)
		body.collision_layer = 1
		sprite.show()
	
