extends Node2D

@onready var GAME_OVER_UI  : Control = $GUI/GameOver
@onready var PAUSE_MENU    : Control = $GUI/PauseMenu
@onready var GAME_UI       : Control = $GUI/GameUI
@onready var SHOP_UI       : Control = $GUI/ShopUI

@onready var PLAYER : CharacterBody2D = $Player
@onready var SHOP_LABEL : Label = $Ship/ShopLabel
@onready var WAYPOINT : Sprite2D = $BoxWaypoint
@onready var SHIPWAYPOINT : Sprite2D = $ShipWaypoint
@onready var PARTICLES : GPUParticles2D = $GPUParticles2D
@onready var ENEMY_SPAWNER : ObjectSpawner = $EnemySpawner
@export var MAX_FUEL : float = 120
@export var FUEL_PER_SECOND_STILL : float = 0.5
@export var FUEL_PER_SECOND_MOVING : float = 1

@export var celestialBodies : Array[PackedScene]
@export var CBtoSpawn : int = 10
@export var maxCelestialBodies : int = 30
@export var package : PackedScene
var currentPackage : Box
var pickedUpPackages : Array[Box]
var activeBodies : Array[Node2D]
var isInTheShip : bool = false
var shopBindPressed : bool = false

var BoxPrice : int = 10
var fuel : float = 0
var numOfPackagesCarry : int = 0
var isGameOver : bool = false
var paused : bool = false

# Statistics
var _timePlayed : float = 0
var _totalFuelSpent : float = 0
var _totalMoneyEarned : int = 0
var _totalPackagesDelivered : int = 0


func _on_picked_up() -> void:
	WAYPOINT.TARGET_POSITION = Vector2(0, 0)
	numOfPackagesCarry += 1
	generate()


func _ready() -> void:
	$Player/HealthComponent.healthChanged.connect(_on_player_health_changed)
	SHIPWAYPOINT.TARGET_POSITION = Vector2(0, 0)
	fuel = MAX_FUEL
	generate()

func _on_player_health_changed(newHealth : float) -> void:
	GAME_UI.update_health(PLAYER.HealthComp.MAX_HEALTH, newHealth)

func generate():
	if currentPackage != null:
		currentPackage.picked_up.disconnect(_on_picked_up)
		pickedUpPackages.append(currentPackage)
	
	currentPackage = package.instantiate() as Box
	currentPackage.picked_up.connect(_on_picked_up)
	var randomDir : Vector2 = Vector2.RIGHT.rotated(randf_range(-PI, PI))
	var randomDist : float = randf_range(400, 3500)
	currentPackage.global_position = PLAYER.global_position + randomDir * randomDist
	WAYPOINT.TARGET_POSITION = currentPackage.global_position
	
	while activeBodies.size() > maxCelestialBodies:
		activeBodies.front().queue_free()
		activeBodies.pop_front()
	
	var currentPos : float = 0
	while currentPos < 1.2*randomDist:
		currentPos +=  randf_range(350, 1000)
		var body = celestialBodies.pick_random().instantiate() as Node2D
		body.global_position = PLAYER.global_position + \
		currentPos* randomDir+ \
		randf_range(100, 500)*randomDir.rotated(randf_range(-PI/4, PI/4))
		activeBodies.append(body)
		call_deferred("add_child", body)
	call_deferred("add_child", currentPackage)
	
	#ako crash onda 
	for i in range(activeBodies.size() - 1, -1, -1):
		var body = activeBodies[i]
		if not is_instance_valid(body):
			activeBodies.remove_at(i)
			continue
		if body.global_position.distance_squared_to(currentPackage.global_position) < 2000:
			body.queue_free()
			activeBodies.remove_at(i)

func _process(delta: float) -> void:
	_timePlayed += delta
	
	if fuel <= 0:
		GameOver()
		return
	
	if PLAYER.isMoving:
		fuel -= FUEL_PER_SECOND_MOVING * delta
		_totalFuelSpent += FUEL_PER_SECOND_MOVING * delta
	else:
		fuel -= FUEL_PER_SECOND_STILL * delta
		_totalFuelSpent += FUEL_PER_SECOND_STILL * delta
	
	PARTICLES.global_position = PLAYER.global_position

	if isGameOver : 
		return
	
	GAME_UI.update_fuel(MAX_FUEL, fuel)
	
	if Input.is_action_just_pressed("Pause"):
		pause_menu()
	
	if isInTheShip:
		SHOP_LABEL.show()
	else:
		SHOP_LABEL.hide()
	
	if Input.is_action_just_pressed("openShop") and isInTheShip and !shopBindPressed:
		SHOP_LABEL.hide()
		SHOP_UI.open(MAX_FUEL, fuel)
		pause_game(true)
		shopBindPressed = true
	elif Input.is_action_just_pressed("openShop") and isInTheShip and shopBindPressed:
		SHOP_LABEL.show()
		SHOP_UI.hide()
		pause_game(false)
		shopBindPressed = false

func pause_menu():
	paused = !paused
	pause_game(paused)
	
	if paused:
		PAUSE_MENU.show()
	else:
		PAUSE_MENU.hide()

func pause_game(pause : bool):
	if pause:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1



# GAME OVER - kada istekne timer
func GameOver() -> void:
	isGameOver = true
	pause_game(true)
	GAME_OVER_UI.updateStatistics(_timePlayed, _totalFuelSpent, _totalMoneyEarned, _totalPackagesDelivered)
	GAME_OVER_UI.show()


func _on_ship_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	
	isInTheShip = true
	if  body.is_in_group("player") and numOfPackagesCarry > 0:
		for i in pickedUpPackages:
			i.queue_free()
		pickedUpPackages = []
		_totalPackagesDelivered += numOfPackagesCarry
		var earnedMoney = numOfPackagesCarry * BoxPrice
		SHOP_UI.money += earnedMoney
		_totalMoneyEarned += earnedMoney
		GAME_UI.update_money(SHOP_UI.money)
		numOfPackagesCarry = 0
		
		if not ENEMY_SPAWNER._active:
			ENEMY_SPAWNER.Activate()

func _on_ship_body_exited(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	isInTheShip = false

func _on_shop_ui_bought_speed() -> void:
	PLAYER.acc += PLAYER.BASE_ACC * 0.1

func _on_shop_ui_bought_waypoint_distance() -> void:
	pass

func _on_shop_ui_bought_pickup_speed() -> void:
	Box.COLLECTION_TIME *= 0.75


func _on_shop_ui_money_changed(newMoney: int) -> void:
	GAME_UI.update_money(newMoney)


func _on_shop_ui_bought_fuel(amount: float) -> void:
	fuel += amount


func _on_enemy_spawner_object_created(object: Node) -> void:
	var enemy = object as CharacterBody2D
	enemy.Player = PLAYER
	call_deferred("add_child", enemy)
