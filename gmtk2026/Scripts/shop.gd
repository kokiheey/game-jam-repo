extends Control

signal moneyChanged(newMoney : int)
signal boughtSpeed
signal boughtWaypointDistance
signal boughtPickupSpeed

var money : int
@export var speedUpgradeCost     : int = 4
@export var waypointDistanceCost : int = 4
@export var pickupSpeedCost  : int = 4
var upgrades : Array = []

func _ready():
	upgrades = [
		{ "cost": speedUpgradeCost    , "signal": boughtSpeed},
		{ "cost": waypointDistanceCost, "signal": boughtWaypointDistance},
		{ "cost": pickupSpeedCost     , "signal": boughtPickupSpeed },
	]
	$SpeedButton.pressed.connect(try_purchase(0))
	$WaypointDistButton.pressed.connect(try_purchase(1))
	$CollectionSpeed.pressed.connect(try_purchase(2))

func try_purchase(index : int):
	var upgrade = upgrades[index]
	if money >= upgrade["cost"]:
		money -= upgrade["cost"]
		upgrade["signal"].emit()
		moneyChanged.emit(money)
