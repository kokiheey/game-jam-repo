extends CanvasLayer

@onready var title = $MarginContainer/Panel/MarginContainer/VBox/Title
@onready var description = $MarginContainer/Panel/MarginContainer/VBox/Description
@onready var con = $MarginContainer/Panel/MarginContainer/VBox/Continue

var current_step = 0
var shouldStop : bool = false
var next : bool = true

var player
var ship
var fuel_bar
var money_label
var waypoint

enum Steps{
	#INTRO,
	#SHIP,
	PLAYER,
	FUEL,
	BLACKHOLE,
	MONEY,
	#WAYPOINT,
	#PACKAGE,
	DELIVERING,
	#SHOP,
	END
}

func start():
	visible = true
	self.show()
	Engine.time_scale = 0
	current_step = 0
	show_step()
	
func cont():
	visible = false
	next = false
	print("here")
	Engine.time_scale = 1
	
func next_step():
	visible = true
	next = true
	Engine.time_scale = 0
	show_step()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("uiAccept") and next:
		current_step += 1
		print(shouldStop)
		if shouldStop:
			cont()
		else:
			print(current_step)
			next_step()
	if current_step > Steps.END:
		visible = false
		Engine.time_scale = 1
		SceneTransition.change_scene("res://Scenes/game.tscn")

func show_step():
	match current_step:
		#Steps.INTRO:
		#	title.text = "Welcome"
		#	description.text = "Your goal is to deliver packages, explore the galaxy, and survive the dangers you encounter along the way.\nManage your resources carefully and make smart decisions to complete your missions."
		#	con.text = "SPACE - next step"

		#Steps.SHIP:
		#	title.text = "Your Ship"
		#	description.text = "This is your main ship and your safe location. Return here after completing deliveries to unload packages, prepare for your next mission, and manage your equipment."
		#	con.text = "SPACE - next step"

		Steps.PLAYER:
			title.text = "Movement"
			description.text = "Move your mouse around the screen to steer the ship\n\n Hold W or LMB to move."
			con.text = "SPACE - next step"

		Steps.FUEL:
			title.text = "Fuel"
			description.text = "You lose fuel constantly.\n While moving you lose more fuel.\n\n DON'T RUN OUT OF FUEL"
			con.text = "SPACE - next step"
			
		Steps.BLACKHOLE:
			shouldStop = true
			title.text = "Blackhole"
			description.text = "Black holes move you to them.\n\n If you touch the center you lose health."
			con.text = "SPACE - next step"
		
		Steps.MONEY:
			title.text = "Money"
			description.text = "Delivering packages earns money.\n\nSpend it in the Shop to buy useful upgrades."
			con.text = "SPACE - Next Step"

		Steps.DELIVERING:
			title.text = "Delivering"
			description.text = "Entering your ship automatically delivers every collected package and rewards you with money.\n\n Enemies cannot enter this area."
			con.text = "SPACE - Next Step"


		#Steps.WAYPOINT:
		#	title.text = "Waypoint"
		#	description.text = "The waypoint always points toward your current package.\nFollow it whenever you're lost."
		#	con.text = "SPACE - Next Step"

		#Steps.PACKAGE:
		#	title.text = "Packages"
		#	description.text = "Fly close to a package to collect it.\nAfter collecting it, return to your ship."
		#	con.text = "SPACE - Next Step"

		#Steps.SHOP:
		#	title.text = "Shop"
		#	description.text = "Press the Shop key while inside your ship to open the Shop.\nBuy upgrades to improve your abilities."
		#	con.text = "SPACE - Next Step"

		Steps.END:
			title.text = "Tutorial Complete!"
			description.text = "You're ready!\nFind packages, deliver them, earn money, buy upgrades, and survive for as long as possible.\nGood luck, Pilot!"
			con.text = "SPACE - Start Playing"
