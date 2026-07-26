extends Control

signal moneyChanged(newMoney : int)
signal boughtSpeed
signal boughtWaypointDistance
signal boughtPickupSpeed

var money : int
@export var speedUpgradeCost     : int = 1
@export var waypointDistanceCost : int = 1
@export var pickupSpeedCost  : int = 1
var upgrades : Array = []

func try_purchase(index : int):
	var upgrade = upgrades[index]
	if money >= upgrade["cost"]:
		money -= upgrade["cost"]
		upgrade["signal"].emit()
		moneyChanged.emit(money)

func _ready():
	upgrades = [
		{ "cost": speedUpgradeCost    , "signal": boughtSpeed},
		{ "cost": pickupSpeedCost     , "signal": boughtPickupSpeed },
	]
	$MarginContainer/BoxContainer/ShopBorder/MarginContainer/VBoxContainer/SpeedButton.pressed.connect(try_purchase.bind(0))
	$MarginContainer/BoxContainer/ShopBorder/MarginContainer/VBoxContainer/CollectionSpeed.pressed.connect(try_purchase.bind(1))
