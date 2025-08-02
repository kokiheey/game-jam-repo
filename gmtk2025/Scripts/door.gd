extends Toggle

@onready var body: StaticBody2D = $StaticBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func toggle_on(echo: bool):
	toggled = true
	if not echo: on_toggled_on.emit(self)
	body.collision_layer = 0
	sprite.hide()

func toggle_off(echo: bool):
	toggled = false
	if not echo: on_toggled_off.emit(self)
	body.collision_layer = 1
	sprite.show()
	
