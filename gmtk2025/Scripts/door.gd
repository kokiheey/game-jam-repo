extends Toggle

@onready var body: StaticBody2D = $StaticBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func toggle():
	toggled = not toggled
	update()


func update():
	if toggled:
		#otvori se
		body.collision_layer = 0
		sprite.hide()
		print("t")
	else:
		body.collision_layer = 1
		sprite.show()
		#zatvori
		
